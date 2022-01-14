//
//  CameraCaptureViewController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/5/22.
//

import UIKit
import AVFoundation
import AVKit

fileprivate enum SliderMode {
    case textSpeedChange, transparancyChange
}

class CameraCaptureViewController: UIViewController {
    
    @IBOutlet private weak var previewView: UIView!
    @IBOutlet private weak var scrollRecordView: ScrollRecordView!
    @IBOutlet private weak var expandButton: UIButton!
    @IBOutlet private weak var scrollRecordHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var sliderLabel: UILabel!
    @IBOutlet private weak var slider: UISlider!
    @IBOutlet weak var speedChangeButton: UIButton!
    @IBOutlet weak var transparancyChangeButton: UIButton!
    @IBOutlet weak var sliderExplainerLabel: UILabel!
    
    private let recButtonSize = CGSize(width: 100, height: 100)
    private let maxScrollTextViewHeight: Double = 500
    private let minScrollTextViewHeight: Double = 200
    
    private var recButton: UIButton?
    private var tabBarBg: VisualEffectWithIntensityView?
    private var cameraConfig: CameraConfiguration = CameraConfiguration()
    private var isDragging = false
    private var videoRecordingStarted: Bool = false
    private var sliderMode: SliderMode = .textSpeedChange
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getTabBar()?.tabBar.backgroundColor = .clear
        setCameraConfig()
        print("appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        getTabBar()?.tabBar.backgroundColor = .tabBarGray
        getTabBar()?.tabBar.isHidden = false
        tabBarBg?.removeFromSuperview()
        print("dissappear")
        removeRecButton()
        cameraConfig.stopRunning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerNotification()
        sliderExplainerLabel.text = "camera.slider.explainer.speed.change".localized
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setTabBarBg()
        addRecButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touchPoint = (event?.allTouches?.first?.location(in: view)) else { return }
        
        let frameForTouch = CGRect(x: expandButton.frame.origin.x, y: expandButton.frame.origin.y - 25, width: expandButton.frame.width, height: expandButton.frame.height + 25)
        print("frame touch \(frameForTouch)")
        print("touch point \(touchPoint)")
        if frameForTouch.contains(touchPoint) {
            isDragging = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touchPoint = event?.allTouches?.first?.location(in: view) else { return }
                
        if isDragging {
            expandScrollView(touchPoint.y - view.safeAreaInsets.top)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if isDragging {
            isDragging = false
        }
    }
    
    private func expandScrollView(_ point: Double) {
        print("expans \(point)")
        if point < maxScrollTextViewHeight && point > minScrollTextViewHeight {
            scrollRecordHeightConstraint.constant = point
        }
    }
    
    private func setCameraConfig() {
        cameraConfig.setup { [weak self] (error) in
            guard let self = self else { return }
            
            if error != nil {
                print(error!.localizedDescription)
            }
            
            try? self.cameraConfig.displayPreview(self.previewView)
        }
    }
    
    private func addRecButton() {
        removeRecButton()
        
        recButton = UIButton()
        recButton?.contentMode = .scaleToFill
        recButton?.addTarget(self, action: #selector(didTapOnRecButton(_:)), for: .touchUpInside)
        getTabBar()?.view.addSubview(recButton!)
        let centerButtonFrame = (getTabBar()?.orderedTabBarItemViews()[1].globalFrame)!
        let recButtonXPosition = centerButtonFrame.minX + (centerButtonFrame.width - recButtonSize.width) / 2
        let recButtonYPosition = centerButtonFrame.minY + (centerButtonFrame.height - recButtonSize.height) / 2 - 8 // 8 is the bottom inset
        recButton?.frame = CGRect(x: recButtonXPosition , y: recButtonYPosition, width: recButtonSize.width, height: recButtonSize.width)
        recButton?.setBackgroundImage(UIImage(named: "startRec")!, for: .normal)
    }
    
    private func removeRecButton() {
        recButton?.removeFromSuperview()
    }
    
    private func setTabBarBg() {
        guard let tabBar = tabBarController?.tabBar else { return }
        
        tabBarBg?.removeFromSuperview()
        tabBarBg = VisualEffectWithIntensityView(effect:  UIBlurEffect(style: .light), intensity: 0.4)
        view.insertSubview(tabBarBg!, at: 1)
        tabBarBg?.frame = tabBar.frame
    }
    
    private func recordingStarted(_ started: Bool) {
        videoRecordingStarted = started
        getTabBar()?.tabBar.isHidden = started
        tabBarBg?.isHidden = started
        
        started ? recButton?.setBackgroundImage(UIImage(named: "stopRec")!, for: .normal) : recButton?.setBackgroundImage(UIImage(named: "startRec")!, for: .normal)
    }
    
    private func registerNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: NSNotification.Name(rawValue: "App is going background"), object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appMovedToBackground() {
        if videoRecordingStarted {
            videoRecordingStarted = false
            cameraConfig.stopRecording { (error) in
                print(error ?? "Video recording error")
            }
        }
    }
    
    @objc func appCameToForeground() {
        print("app enters foreground")
    }
    
    @IBAction func changeSpeedAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            sliderMode = .textSpeedChange
            transparancyChangeButton.isSelected = false
            sliderExplainerLabel.text = "camera.slider.explainer.speed.change".localized
        } else {
            sliderExplainerLabel.text = "camera.slider.explainer.transparancy.change".localized
            transparancyChangeButton.isSelected = true
            sliderMode = .transparancyChange
        }
    }
    
    @IBAction func changeTransparencyAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            sliderMode = .transparancyChange
            speedChangeButton.isSelected = false
            sliderExplainerLabel.text = "camera.slider.explainer.transparancy.change".localized
        }  else {
            speedChangeButton.isSelected = true
            sliderMode = .textSpeedChange
            sliderExplainerLabel.text = "camera.slider.explainer.speed.change".localized
        }
    }
    
    @IBAction func sliderDidChnageValue(_ sender: UISlider) {
        if sliderMode == .transparancyChange {
            scrollRecordView.setBackgroundOpacity(Double(sender.value) / 4.0)
        } else {
            scrollRecordView.speedScrolling(by: sender.value)
        }
    }
    
    @IBAction func switchCameraAction(_ sender: UIButton) {
        try! cameraConfig.switchCameras()
    }
    
    @IBAction func didTapOnRecButton(_ sender: UIButton) {
        if videoRecordingStarted {
            recordingStarted(false)
            
            scrollRecordView.stopScrolling()
            cameraConfig.stopRecording { (error) in
                print(error ?? "Video recording error")
            }
        } else if !videoRecordingStarted {
            recordingStarted(true)
            
            cameraConfig.recordVideo { [weak self] (url, error) in
                guard let self = self else { return }
                guard let url = url else {
                    print(error ?? "Video recording error")
                    self.recordingStarted(false)
                    return
                }

                let vc = VideoPreviewViewController()
                vc.videoUrl = url
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
            
            scrollRecordView.startScrolling()
        }
    }
}
