//
//  AVCaptureSessionExtension.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/13/22.
//

import AVFoundation

extension AVCaptureDevice {
    
    func setFrameRate(_ frameRate: Float64) {
        print("asd \(activeFormat.videoSupportedFrameRateRanges)")
        activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: Int32(frameRate))
        activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: Int32(frameRate))
    }
}
