//
//  CameraConfiguration.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/6/22.
//

import AVFoundation
import UIKit

class CameraConfiguration: NSObject {
    
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
    public enum CameraPosition {
        case front
        case rear
    }
    
    public enum OutputType {
        case photo
        case video
    }
    
    private var captureSession: AVCaptureSession?
    private var frontCamera: AVCaptureDevice?
    private var rearCamera: AVCaptureDevice?
    private var audioDevice: AVCaptureDevice?
    
    private var currentCameraPosition: CameraPosition?
    private var frontCameraInput: AVCaptureDeviceInput?
    private var rearCameraInput: AVCaptureDeviceInput?
    private var photoOutput: AVCapturePhotoOutput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var flashMode: AVCaptureDevice.FlashMode = AVCaptureDevice.FlashMode.off
    private var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    private var videoRecordCompletionBlock: ((URL?, Error?) -> Void)?
    
    private var videoOutput: AVCaptureMovieFileOutput?
    private var audioInput: AVCaptureDeviceInput?
    private var outputType: OutputType?
    private var durationTimer: Timer?
    private var duration: Int = 0
    
    var durationUpdated: ((Int) -> ())?
    
    deinit {
        print("deinit \(CameraConfiguration.self)")
    }
}

extension CameraConfiguration {
    
    func setup(handler: @escaping (Error?)-> Void ) {
        
        DispatchQueue(label: "setup").async { [unowned self] in
            do {
                self.createCaptureSession()
                try self.configureCaptureDevices()
                try self.configureDeviceInputs()
                try self.configureVideoOutput()
            } catch {
                DispatchQueue.main.async {
                    handler(error)
                }
                return
            }
            
            DispatchQueue.main.async {
                handler(nil)
            }
        }
    }
    
    func startRunning() {
        captureSession?.startRunning()
    }
    
    func stopRunning() {
        captureSession?.stopRunning()
    }
    
    func displayPreview(_ view: UIView) throws {
        guard let captureSession = captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        
        previewLayer?.removeFromSuperlayer()
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(previewLayer!, at: 0)
        previewLayer?.frame = view.bounds
    }
    
    func recordVideo(completion: @escaping (URL?, Error?)-> Void) {
        guard let captureSession = captureSession, captureSession.isRunning else {
            completion(nil, CameraControllerError.captureSessionIsMissing)
            return
        }
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = paths[0].appendingPathComponent("output.mp4")
        try? FileManager.default.removeItem(at: fileUrl)
        videoOutput?.startRecording(to: fileUrl, recordingDelegate: self)
        videoRecordCompletionBlock = completion
        initDurationTimer()
    }
    
    func stopRecording(completion: @escaping (Error?)->Void) {
        guard let captureSession = captureSession, captureSession.isRunning else {
            completion(CameraControllerError.captureSessionIsMissing)
            return
        }
        videoOutput?.stopRecording()
        durationTimer?.invalidate()
    }
    
    private func initDurationTimer() {
        duration = 0
        durationTimer?.invalidate()
        
        durationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(increaseDuration), userInfo: nil, repeats: true)
    }
    
    @objc private func increaseDuration() {
        duration += 1
        durationUpdated?(duration)
    }
    
    private func createCaptureSession() {
        captureSession = AVCaptureSession()
        captureSession?.startRunning()
    }
    
    private func configureCaptureDevices() throws {
        let session = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        let cameras = (session.devices.compactMap{$0})

        try? setCameras(cameras: cameras)
        audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
    }
    
    private func setCameras(cameras: [AVCaptureDevice]) throws {
        for camera in cameras {
            if camera.position == .front {
                frontCamera = camera
            }
            
            if camera.position == .back {
                rearCamera = camera
                
                try camera.lockForConfiguration()
                camera.focusMode = .continuousAutoFocus
                camera.unlockForConfiguration()
            }
        }
    }
    
    //Configure inputs with capture session
    //only allows one camera-based input per capture session at a time.
    private func configureDeviceInputs() throws {
        guard let captureSession = captureSession else {
            throw CameraControllerError.captureSessionIsMissing
        }

        setFrontCameraInput()
        try? configureAudioInput(captureSession)
    }
    
    private func configureAudioInput(_ captureSession: AVCaptureSession) throws {
        if let audioDevice = audioDevice {
            if let audioInput = audioInput {
                captureSession.removeInput(audioInput)
            }
            audioInput = try AVCaptureDeviceInput(device: audioDevice)
            if captureSession.canAddInput(audioInput!) {
                captureSession.addInput(audioInput!)
            } else {
                throw CameraControllerError.inputsAreInvalid
            }
        }
    }
    
    private func configureVideoOutput() throws {
        guard let captureSession = captureSession else {
            throw CameraControllerError.captureSessionIsMissing
        }

        videoOutput = AVCaptureMovieFileOutput()
        if captureSession.canAddOutput(videoOutput!) {
            captureSession.addOutput(videoOutput!)
        }
    }
    
    func switchCameras() throws {
        guard let currentCameraPosition = currentCameraPosition, let captureSession = captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        captureSession.beginConfiguration()
        let inputs = captureSession.inputs
        
        switch currentCameraPosition {
        case .front:
            switchToRearCamera(inputs: inputs)
            
        case .rear:
            switchToFrontCamera(inputs: inputs)
        }
        captureSession.commitConfiguration()
    }
    
    private func switchToFrontCamera(inputs: [AVCaptureInput]) {
        guard let rearCameraInput = rearCameraInput, inputs.contains(rearCameraInput) else { return }
        
        captureSession?.removeInput(rearCameraInput)
        setFrontCameraInput()
    }
    
    private func switchToRearCamera(inputs: [AVCaptureInput]) {
        guard let frontCameraInput = self.frontCameraInput, inputs.contains(frontCameraInput) else { return }
        
        captureSession?.removeInput(frontCameraInput)
        setBackCameraInput()
    }
    
    private func setFrontCameraInput() {
        guard let frontCamera = frontCamera else { return }
        
        frontCameraInput = try? AVCaptureDeviceInput(device: frontCamera)
        if captureSession?.canAddInput(frontCameraInput!) == true {
            captureSession?.addInput(frontCameraInput!)
            currentCameraPosition = .front
        }
        
        setActiveFormatFor(frontCamera)
    }
    
    private func setBackCameraInput() {
        guard let rearCamera = rearCamera else { return }
        
        rearCameraInput = try? AVCaptureDeviceInput(device: rearCamera)
        if captureSession?.canAddInput(rearCameraInput!) == true {
            captureSession?.addInput(rearCameraInput!)
            self.currentCameraPosition = .rear
        }
        
        setActiveFormatFor(rearCamera)
    }
    
    private func setActiveFormatFor(_ camera: AVCaptureDevice) {
        try? camera.lockForConfiguration()
        camera.setActiveFormat(videoSetting: UserSettingsManager.shared.getVideoSetting())
        camera.unlockForConfiguration()
    }
}

extension CameraConfiguration: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error == nil {
            videoRecordCompletionBlock?(outputFileURL, nil)
        } else {
            videoRecordCompletionBlock?(nil, error)
        }
    }
}

extension CameraConfiguration: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("did output")
    }
}

