//
//  PlayerProgressView.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/8/22.
//

import UIKit
import AVFoundation

class PlayerProgressView: BaseCustomView {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var imagesStackView: UIStackView!
    @IBOutlet private weak var sliderButton: UIButton!
    @IBOutlet private weak var sliderButtonLeadingConstraint: NSLayoutConstraint!
    
    private var player: AVPlayer!
    private let chunkCount: Double = 10
    
    override func getContentView() -> UIView {
        return contentView
    }
    
    override func getXibName() -> String {
        return "\(PlayerProgressView.self)"
    }
    
    func setPlayer(_ player: AVPlayer) {
        self.player = player
        setProgressImages()
    }
    
    private func setProgressImages() {
        guard let asset = player.currentItem?.asset else { return }
        
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
