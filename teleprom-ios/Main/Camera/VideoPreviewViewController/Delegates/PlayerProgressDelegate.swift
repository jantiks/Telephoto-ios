//
//  PlayerProgressDelegate.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/8/22.
//

import Foundation

protocol PlayerProgressDelegate {
    func updateTime(_ time: Double)
    func didFinish(_ time: Double)
}
