//
//  VideoPreviewViewController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/6/22.
//

import UIKit
import AVFoundation
import Photos

class VideoPreviewViewController: BaseViewController {

    @IBOutlet weak var playerView: CustomPlayerView!
    @IBOutlet weak var progressView: PlayerProgressView!
    @IBOutlet weak var safeAreaView: UIView!
    @IBOutlet weak var actionButtonsView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var loadingView: LoadingView!
    
    private var aspectRatio: CGSize = CGSize(width: 9, height: 16)
    var videoUrl: URL! // should be setted before present
    
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .controllerGray
        navigationController?.setNavigationBarTransparent()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initPlayer()
        initUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setAspectView()
    }
    
    func setPlayerApectRatio(_ aspectRatio: CGSize) {
        self.aspectRatio = aspectRatio
        
        setAspectView()
    }
    
    private func setAspectView() {
        let viewSize = view.bounds.size
        let height = viewSize.width * aspectRatio.height / aspectRatio.width
        let rect = CGRect(x: 0, y: (viewSize.height / 2) - (height / 2), width: viewSize.width, height: height)
        // Cuts rectangle inside view
        playerView.mask(withRect: rect)
    }
    
    private func initUI() {
        safeAreaView.backgroundColor = .controllerGray
        actionButtonsView.backgroundColor = .controllerGray
        
        view.bringSubviewToFront(actionButtonsView)
        view.bringSubviewToFront(safeAreaView)
        
        saveButton.setTitle("video.download".localized, for: .normal)
        deleteButton.setTitle("video.delete".localized, for: .normal)
        
        saveButton.alignVertical()
        deleteButton.alignVertical()
    }
    
    private func initPlayer() {
        playerView.setConfigure(videoUrl: videoUrl, progressView: progressView)
        playerView.delegate = self
    }
    
    private func videoSavedAction() {
        hideLoading()
    }
    
    private func videoSavingFailedAction() {
        print("fialed to save video")
    }
    
    private func showLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.startLoading()
        }
    }
    
    private func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.stopLoading()
        }
    }
    
    private func deleteVideo() {
        do {
            try FileManager.default.removeItem(at: videoUrl)
        } catch let error {
            print("FAILED TO DELETE \(error.localizedDescription)")
        }
    }
    
    private func showSubscriptionsController() {
        let vc = SubscriptionViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func alertCameraAccessNeeded() {
        DispatchQueue.main.async { [weak self] in
            let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
            
            let alert = UIAlertController(
                title: "gallery.access.title".localized,
                message: "gallery.access.message".localized,
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "alert.cancel".localized, style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "alert.allow".localized, style: .cancel, handler: { (alert) -> Void in
                UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
            }))
            
            self?.present(alert, animated: true)
        }
    }
    
    private func saveVideo() {
        showLoading()
        SaveVideoCommand(videoUrl, aspectRatio: aspectRatio, savedAction: videoSavedAction, failedAction: videoSavingFailedAction).execute()
    }
    
    private func downloadVideoIfHasAccess() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            //handle authorized status
            saveVideo()
        case .denied, .restricted :
            alertCameraAccessNeeded()
            //handle denied status
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                status == .authorized ? self?.saveVideo() : self?.alertCameraAccessNeeded()
            }
        default:
            alertCameraAccessNeeded()
        }
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        IAPManager.shared.checkPermissions { [weak self] hasPermition in
            guard let self = self else { return }
            
            hasPermition ? self.downloadVideoIfHasAccess() : self.showSubscriptionsController()
        }
    }
    
    @IBAction func playPuseAction(_ sender: UIButton) {
        playerView.isPlaying() ? playerView.pause() : playerView.play()
    }
    
    @IBAction func deletAction(_ sender: UIButton) {
        let ac = UIAlertController(title: nil, message: "video.delete.alert.message".localized, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "alert.cancel".localized, style: .default))
        ac.addAction(UIAlertAction(title: "alert.delete".localized, style: .destructive, handler: { [weak self] action in
            self?.deleteVideo()
            self?.dismiss(animated: true)
        }))
        
        present(ac, animated: true)
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    deinit {
        deleteVideo()
    }
}

extension VideoPreviewViewController: PlayerViewDelegate {
    func playPauseAction(_ isPlaying: Bool) {
        isPlaying ? playButton.setImage(UIImage(named: "pause"), for: .normal) : playButton.setImage(UIImage(named: "play"), for: .normal)
    }
}
