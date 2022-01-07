//
//  CameraCaptureViewController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/5/22.
//

import UIKit
import AVFoundation
import AVKit

class CameraCaptureViewController: UIViewController {
    
    @IBOutlet weak var previewView: UIView!
    private var recButton: UIButton!
    private var tabBarBg: VisualEffectWithIntensityView?
    private var cameraConfig: CameraConfiguration!
    private let recButtonSize = CGSize(width: 100, height: 100)
    
    private var videoRecordingStarted: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getTabBar()?.tabBar.backgroundColor = .clear
        cameraConfig?.startRunning()
        addRecButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        getTabBar()?.tabBar.backgroundColor = .tabBarGray
        getTabBar()?.tabBar.isHidden = false
        
        tabBarBg?.removeFromSuperview()
        removeRecButton()
        cameraConfig?.stopRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setTabBarBg()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCameraConfig()
        registerNotification()
    }
    
    private func setCameraConfig() {
        self.cameraConfig = CameraConfiguration()
        cameraConfig.setup { [weak self] (error) in
            guard let self = self else { return }
            
            if error != nil {
                print(error!.localizedDescription)
            }
            
            try? self.cameraConfig.displayPreview(self.previewView)
        }
    }
    
    private func addRecButton() {
        recButton?.removeFromSuperview()
        
        recButton = UIButton()
        recButton.contentMode = .scaleToFill
        recButton.addTarget(self, action: #selector(didTapOnRecButton(_:)), for: .touchUpInside)
        getTabBar()?.view.addSubview(recButton)
        let centerButtonFrame = (getTabBar()?.tabBar.subviews[2].globalFrame)!
        let recButtonXPosition = centerButtonFrame.minX + (centerButtonFrame.width - recButtonSize.width) / 2
        let recButtonYPosition = centerButtonFrame.minY + (centerButtonFrame.height - recButtonSize.height) / 2 - 8 // 8 is the bottom inset
        recButton.frame = CGRect(x: recButtonXPosition , y: recButtonYPosition, width: recButtonSize.width, height: recButtonSize.width)
        recButton.setBackgroundImage(UIImage(named: "startRec")!, for: .normal)
    }
    
    private func removeRecButton() {
        recButton.removeFromSuperview()
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
        
        started ? recButton.setBackgroundImage(UIImage(named: "stopRec")!, for: .normal) : recButton.setBackgroundImage(UIImage(named: "startRec")!, for: .normal)
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
    
    @IBAction func didTapOnRecButton(_ sender: UIButton) {
        if videoRecordingStarted {
            recordingStarted(false)

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
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }

    }

}
