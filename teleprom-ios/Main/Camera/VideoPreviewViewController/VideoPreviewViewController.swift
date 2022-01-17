//
//  VideoPreviewViewController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/6/22.
//

import UIKit
import AVFoundation

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
        loadingView.startLoading()
    }
    
    private func hideLoading() {
        loadingView.stopLoading()
    }
    
    private func deleteVideo() {
        do {
            try FileManager.default.removeItem(at: videoUrl)
        } catch let error {
            print("FAILED TO DELETE \(error.localizedDescription)")
        }
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        showLoading()
        SaveVideoCommand(videoUrl, aspectRatio: aspectRatio, savedAction: videoSavedAction, failedAction: videoSavingFailedAction).execute()
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
        isPlaying ? playButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal) : playButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
    }
}
