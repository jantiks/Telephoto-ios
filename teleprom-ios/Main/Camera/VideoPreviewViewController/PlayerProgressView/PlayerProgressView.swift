//
//  PlayerProgressView.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/8/22.
//

import UIKit
import AVFoundation

class PlayerProgressView: BaseCustomView, BaseProgressView {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var imagesStackView: UIStackView!
    @IBOutlet private weak var sliderButton: UIButton!
    @IBOutlet private weak var sliderButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var timeLabel: UILabel!
    
    private weak var playerView: BasePlayerView?
    private var isDragging: Bool = false
    private let chunkCount: Double = 10
    
    override func getContentView() -> UIView {
        return contentView
    }
    
    override func getXibName() -> String {
        return "\(PlayerProgressView.self)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touchPoint = (event?.allTouches?.first?.location(in: self)) else { return }
        
        let frameForTouch = CGRect(x: sliderButton.frame.origin.x - 25, y: sliderButton.frame.origin.y, width: sliderButton.frame.width + 25, height: sliderButton.frame.height)
        
        if frameForTouch.contains(touchPoint) {
            isDragging = true
            playerView?.pause()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let touchPoint = event?.allTouches?.first?.location(in: self) else { return }
                
        if (isDragging) {
            updateSliderPosition(touchPoint.x)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if isDragging {
            playerView?.play()
            isDragging = false
        }
    }
    
    func setPlayer(_ player: BasePlayerView) {
        self.playerView = player
        setProgressImages()
    }
    
    func updateTime(_ time: Double) {
        guard let duration = playerView?.getDuration(), duration != 0 else { return }
        
        setTimeText(time)
        sliderButtonLeadingConstraint.constant = (time / duration) * (imagesStackView.bounds.width - sliderButton.frame.width)
    }
    
    private func setTimeText(_ time: Double) {
        timeLabel.text = time.getTimeFormattedWithoutHour()
    }
    
    private func updateSliderPosition(_ position: CGFloat) {
        guard let duration = playerView?.getDuration() else { return }
        
        sliderButtonLeadingConstraint.constant = position
        playerView?.seekTo(time: duration * (position / imagesStackView.bounds.width))
    }
    
    private func setProgressImages() {
        guard let asset = playerView?.getCurrentAsset() else { return }
        
        let duration = asset.duration.seconds
        let chunkDuration = duration / chunkCount
        
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.requestedTimeToleranceAfter = CMTime(seconds: duration / 2 * chunkCount, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        imageGenerator.requestedTimeToleranceBefore = CMTime(seconds: duration / 2 * chunkCount, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        for i in 0..<Int(chunkCount) {
            let thumb = try! imageGenerator.copyCGImage(at: CMTime(seconds: chunkDuration * Double(i), preferredTimescale: CMTimeScale(NSEC_PER_SEC)), actualTime: nil)
            let image = UIImage(cgImage: thumb, scale: 1.0, orientation: UIImage.Orientation.right)
            
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleToFill
            
            imagesStackView.addArrangedSubview(imageView)
        }
    }
}
