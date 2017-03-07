//
//  AudioPlayerViewController.swift
//  MediaLibrary
//
//  Created by Andriy Zymenko on 14.11.16.
//  Copyright © 2016 Anzim. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class AudioPlayerViewController: AVPlayerViewController {
//    var dataProvider: DataProviderProtocol = AppDelegate.dataProvider
    var tracks: [Track]? {
        didSet {
            setup()
        }
    }
    
    func setup() {
        if let url = Bundle.main.url(forResource: "Moon", withExtension: "mp4",
                                     subdirectory: "Data//Video")
        {
            player = AVPlayer(url: url)
        }
        guard let tracks = self.tracks, view != nil else {
            return
        }
        //TODO: 
        
    }
    
    override func viewDidLoad() {
        if player == nil && tracks != nil {
            setup()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        player?.play()
    }
}
