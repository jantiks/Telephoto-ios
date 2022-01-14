//
//  AVCaptureSessionExtension.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/13/22.
//

import AVFoundation

extension AVCaptureDevice {
    
    func setActiveFormat(videoSetting: VideoSetting) {
        
        if let format = formats.first(where: { format in
            format.videoSupportedFrameRateRanges.contains(where: {
                $0.minFrameRate <= videoSetting.fps &&
                videoSetting.fps <= $0.maxFrameRate &&
                format.formatDescription.dimensions.width == Int32(videoSetting.dimension.width) &&
                format.formatDescription.dimensions.height == Int32(videoSetting.dimension.height)
            })
        }) {
            activeFormat = format
            
            activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: Int32(videoSetting.fps))
            activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: Int32(videoSetting.fps))
        }
    }
}
