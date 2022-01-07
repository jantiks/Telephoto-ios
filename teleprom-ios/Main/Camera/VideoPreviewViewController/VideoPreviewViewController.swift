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
        playerView.setPlayer(videoUrl)
        progressView.setPlayer(playerView.getUnsafePlayer())
    }
    
    private func videoSavedAction() {
        hideLoading()
    }
    
    private func videoSavingFailedAction() {
        print("fialed to save video")
    }
    
    private func showLoading() {
        
    }
    
    private func hideLoading() {
        
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        showLoading()
        SaveVideoCommand(videoUrl, savedAction: videoSavedAction, failedAction: videoSavingFailedAction).execute()
    }
    
    @IBAction func playPuseAction(_ sender: UIButton) {
        if playerView.isPlaying() {
            playerView.pasue()
            playButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        } else {
            playerView.play()
            playButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        }
    }
    
    @IBAction func deletAction(_ sender: UIButton) {
        do {
            try FileManager.default.removeItem(at: videoUrl)
        } catch let error {
            print("FAILED TO DELETE \(error.localizedDescription)")
        }
    }
}
