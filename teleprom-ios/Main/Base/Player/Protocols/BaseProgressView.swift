//
//  BaseProgress.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/8/22.
//

import Foundation
import AVFoundation

protocol BaseProgressView: AnyObject {
    func setPlayer(_ player: BasePlayerView)
    func updateTime(_ time: Double)
}
