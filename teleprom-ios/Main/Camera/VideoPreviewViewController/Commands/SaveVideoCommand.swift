//
//  SaveVideoCommand.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/6/22.
//

import UIKit
import AVFoundation

class SaveVideoCommand: NSObject, CommonCommand {
    
    private let videoUrl: URL
    private let savedAction: (() -> ())
    private let failedAction: (() -> ())
    
    init(_ videoUrl: URL, savedAction: @escaping (() -> ()), failedAction: @escaping (() -> ())) {
        self.videoUrl = videoUrl
        self.savedAction = savedAction
        self.failedAction = failedAction
    }
    
    @objc private func video(_ video: String, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print(error.localizedDescription)
            failedAction()
        } else {
            savedAction()
        }
    }
    
    func execute() {
        let videoSetting = UserSettingsManager.shared.getVideoSetting()
        
        cropVideo(videoUrl, videoSetting: videoSetting) { newUrl in
            UISaveVideoAtPathToSavedPhotosAlbum(newUrl.path, self, #selector(self.video(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    func cropVideo( _ outputFileUrl: URL, videoSetting: VideoSetting, callback: @escaping ( _ newUrl: URL ) -> () ) {
        // Get input clip
        let videoAsset: AVAsset = AVAsset( url: outputFileUrl )
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = paths[0].appendingPathComponent("ffmpegOutput.mp4")
        try? FileManager.default.removeItem(at: fileUrl)
        
        videoAsset.cropVideoTrack(at: 0, cropRect: CGRect(x: 0, y: 0, width: videoSetting.dimension.height, height: videoSetting.dimension.height), outputURL: fileUrl) { result in
            callback(fileUrl)
        }
    }
}
