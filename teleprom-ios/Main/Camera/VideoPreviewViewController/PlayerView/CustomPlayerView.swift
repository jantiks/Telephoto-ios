//
//  CustomPlayerView.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/7/22.
//

import UIKit
import AVFoundation

class CustomPlayerView: BaseCustomView {

    @IBOutlet private weak var contentView: UIView!
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer!
    private var timeObserverToken: Any?
    private var finishObserverToken: Any?
    
    var updateTime: ((Double) -> (Void))?
    var playerFinished: (() -> ())?
    
    override func getXibName() -> String {
        return "\(CustomPlayerView.self)"
    }
    
    override func getContentView() -> UIView {
        return contentView
    }
    
    override func commonInit() {
        super.commonInit()
        
        playerLayer = AVPlayerLayer(player: nil)
        playerLayer.videoGravity = .resizeAspect
        playerLayer.frame = bounds
        layer.addSublayer(playerLayer)
    }
    
    func setPlayer(_ url: URL) {
        player = AVPlayer(url: url)
        playerLayer.player = player
        addPeriodicTimeObserver()
    }
    
    func getUnsafePlayer() -> AVPlayer {
        return player!
    }
    
    func play() {
        player?.play()
    }
    
    func pasue() {
        player?.pause()
    }
    
    func isPlaying() -> Bool {
        return player?.isPlaying() ?? false
    }
    
    private func addPeriodicTimeObserver() {
        removePeriodicTimeObserver()

        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.1, preferredTimescale: timeScale)

        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: time, queue: .main, using: { [unowned self] time in
            self.updateTime?(time.seconds)
        })
    }

    private func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    private func addVideoFinishedObserver() {
        removeVideoFinishedObserver()
        finishObserverToken = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { [unowned self] _ in
            self.playerFinished?()
        }
    }
    
    private func removeVideoFinishedObserver() {
        if let finishObserverToken = finishObserverToken {
            player?.removeTimeObserver(finishObserverToken)
            self.finishObserverToken = nil
        }
    }
    
    deinit {
        removePeriodicTimeObserver()
        removeVideoFinishedObserver()
    }
}
