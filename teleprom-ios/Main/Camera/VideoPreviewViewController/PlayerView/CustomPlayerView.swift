//
//  CustomPlayerView.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/7/22.
//

import UIKit
import AVFoundation

class CustomPlayerView: BaseCustomView, BasePlayerView {

    @IBOutlet private weak var contentView: UIView!
    
    private weak var progressView: BaseProgressView?
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer!
    private var timeObserverToken: Any?
    private var finishObserverToken: Any?
    
    weak var delegate: PlayerViewDelegate?
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
    
    func setConfigure(videoUrl: URL, progressView: BaseProgressView? = nil) {
        player = AVPlayer(url: videoUrl)
        playerLayer.player = player
        addPeriodicTimeObserver()
        addVideoFinishedObserver()
        setProgressView(progressView)
    }
    
    func setProgressView(_ view: BaseProgressView?) {
        progressView = view
        progressView?.setPlayer(self)
    }
    
    func getCurrentTime() -> Double {
        return player?.currentTime().seconds ?? 0.0
    }
    
    func getCurrentAsset() -> AVAsset? {
        return player?.currentItem?.asset
    }
    
    func getDuration() -> Double {
        return player?.currentItem?.duration.seconds ?? 0.0
    }
    
    func play() {
        player?.play()
        delegate?.playPauseAction(true)
    }
    
    func pause() {
        player?.pause()
        delegate?.playPauseAction(false)
    }
    
    func seekTo(time: Double) {
        guard let isPlaying = player?.isPlaying() else { return }
        
        player?.seek(to: CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
        isPlaying ? play() : pause()
    }
    
    func isPlaying() -> Bool {
        return player?.isPlaying() ?? false
    }
    
    private func addPeriodicTimeObserver() {
        removePeriodicTimeObserver()

        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.016, preferredTimescale: timeScale)

        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: time, queue: .main, using: { [unowned self] time in
            self.updateTime?(time.seconds)
            self.progressView?.updateTime(time.seconds)
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
            seekTo(time: 0)
            pause()
        }
    }
    
    private func removeVideoFinishedObserver() {
        if let finishObserverToken = finishObserverToken {
            NotificationCenter.default.removeObserver(player)
            NotificationCenter.default.removeObserver(player?.currentItem)
            self.finishObserverToken = nil
        }
    }
    
    deinit {
        print("asd deinit")
        
        removePeriodicTimeObserver()
        removeVideoFinishedObserver()
    }
}
