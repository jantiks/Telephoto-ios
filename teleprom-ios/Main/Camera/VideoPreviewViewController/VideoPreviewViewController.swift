//
//  VideoPreviewViewController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/6/22.
//

import UIKit
import AVFoundation

class VideoPreviewViewController: BaseViewController {

    @IBOutlet weak var safeAreaView: UIView!
    @IBOutlet weak var actionButtonsView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var videoUrl: URL!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.backgroundColor = .clear
        view.backgroundColor = .clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initPlayer()
    }
    
    private func initPlayer() {
        let player = AVPlayer(url: videoUrl)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        view.layer.addSublayer(playerLayer)
        
        player.play()
    }

    
    @IBAction func saveAction(_ sender: UIButton) {
    }
    @IBAction func playAction(_ sender: UIButton) {
    }
    @IBAction func deletAction(_ sender: UIButton) {
    }
}
