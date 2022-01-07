//
//  AVPlayerExtension.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/8/22.
//

import AVFoundation

extension AVPlayer {
    
    func isPlaying() -> Bool {
        return rate != 0 && error == nil
    }
}
