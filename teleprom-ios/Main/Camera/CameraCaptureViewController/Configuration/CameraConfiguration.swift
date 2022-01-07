//
//  CameraConfiguration.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/6/22.
//

import Foundation
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
    
    var captureSession: AVCaptureSession?
    var frontCamera: AVCaptureDevice?
    var rearCamera: AVCaptureDevice?
    var audioDevice: AVCaptureDevice?
    
    var currentCameraPosition: CameraPosition?
    var frontCameraInput: AVCaptureDeviceInput?
    var rearCameraInput: AVCaptureDeviceInput?
    var photoOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var flashMode: AVCaptureDevice.FlashMode = AVCaptureDevice.FlashMode.off
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    var videoRecordCompletionBlock: ((URL?, Error?) -> Void)?
    
    var videoOutput: AVCaptureMovieFileOutput?
    var audioInput: AVCaptureDeviceInput?
    var outputType: OutputType?
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
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(previewLayer!, at: 0)
        previewLayer?.frame = CGRect(x: 0, y: 0, width: view.frame.width , height: view.frame.height)
    }
    
    func recordVideo(completion: @escaping (URL?, Error?)-> Void) {
        guard let captureSession = captureSession, captureSession.isRunning else {
            completion(nil, CameraControllerError.captureSessionIsMissing)
            return
        }
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = paths[0].appendingPathComponent("output.mp4")
        try? FileManager.default.removeItem(at: fileUrl)
        videoOutput!.startRecording(to: fileUrl, recordingDelegate: self)
        videoRecordCompletionBlock = completion
    }
    
    func stopRecording(completion: @escaping (Error?)->Void) {
        guard let captureSession = captureSession, captureSession.isRunning else {
            completion(CameraControllerError.captureSessionIsMissing)
            return
        }
        videoOutput?.stopRecording()
    }
    
    private func createCaptureSession() {
        captureSession = AVCaptureSession()
        captureSession?.startRunning()
    }
    
    private func configureCaptureDevices() throws {
        let session = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.front)
        
        let cameras = (session.devices.compactMap{$0})

        for camera in cameras {
            if camera.position == .front {
                frontCamera = camera
            }
        }
        audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
    }
    
    //Configure inputs with capture session
    //only allows one camera-based input per capture session at a time.
    private func configureDeviceInputs() throws {
        guard let captureSession = captureSession else {
            throw CameraControllerError.captureSessionIsMissing
        }

        if let frontCamera = frontCamera {
            frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            if captureSession.canAddInput(frontCameraInput!) {
                captureSession.addInput(frontCameraInput!)
                currentCameraPosition = .front
            } else {
                throw CameraControllerError.inputsAreInvalid
            }
        }
            
        else {
            throw CameraControllerError.noCamerasAvailable
        }
        
        if let audioDevice = audioDevice {
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

