//
//  PlayerViewDelegate.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/9/22.
//

import Foundation

protocol PlayerViewDelegate: AnyObject {
    func playPauseAction(_ isPlaying: Bool)
}
