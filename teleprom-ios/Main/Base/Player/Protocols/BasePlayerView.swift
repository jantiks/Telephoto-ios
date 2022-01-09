//
//  BasePlayer.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/8/22.
//

import AVFoundation

protocol BasePlayerView: AnyObject {
    func getCurrentTime() -> Double
    func getCurrentAsset() -> AVAsset?
    func seekTo(time: Double)
    func getDuration() -> Double
    func play()
    func pause()
}
