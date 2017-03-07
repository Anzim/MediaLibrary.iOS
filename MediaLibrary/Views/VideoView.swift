//
//  VideoView.swift
//  CookStream
//
//  Created by Andriy Zymenko on 10/22/16.
//  Copyright © 2016 Andriy Zymenko. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

private var avPlayerStatusContext: Int = 0

class VideoView: UIView {
    private let avPlayerStatusKey = "status"

    var model: Track?
    weak var delegate: TrackControllerDelegate?
//        {
//        didSet {
//
//        }
//    }

    private var playerLayer: AVPlayerLayer? {
        didSet {
            if let oldLayer = oldValue {
                oldLayer.removeFromSuperlayer()
            }
            if let newLayer = playerLayer {
                layer.insertSublayer(newLayer, at: 0)
            }
        }
    }

    var player: AVPlayer? {
        didSet {
            if let oldPlayer = oldValue {
                removeObservers(from: oldPlayer)
            }
            addObservers(to: player)
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if let status = change?[NSKeyValueChangeKey.newKey],
            keyPath == avPlayerStatusKey,
            context != nil && context! == &avPlayerStatusContext
        {
            if let avStatus = status as? Int,
                avStatus == AVPlayerStatus.readyToPlay.rawValue
            {
                if setupPlayLayer() && isPlaying {
                    self.player!.play()
                }
                return
            }
        }

        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }

    deinit {
        removeObservers(from: player)
        player = nil
        playerLayer = nil
    }

    func addObservers(to player: AVPlayer?) {
        player?.addObserver(self, forKeyPath: avPlayerStatusKey,
                            options: NSKeyValueObservingOptions.new,
                            context: &avPlayerStatusContext)
        if let item = player?.currentItem {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.itemDidFinishPlaying),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                   object: item)
        }
    }
    func removeObservers(from player: AVPlayer?) {
        player?.removeObserver(self, forKeyPath: avPlayerStatusKey,
                                 context: &avPlayerStatusContext)
        if let item = player?.currentItem {
            NotificationCenter.default.removeObserver(self,
                                                      name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                      object: item)
        }
    }

    var isMuted: Bool = true {
        didSet {
//            let volumeImage = isMuted ? #imageLiteral(resourceName: "volume-off") : #imageLiteral(resourceName: "volume-high")
//            self.VolumeButton.setImage(volumeImage, for: .normal)
            player?.isMuted = isMuted

        }
    }

    var isPlaying: Bool = false {
        didSet {
            guard let player = player else { return }
//            let playPauseImage = isPlaying ? #imageLiteral(resourceName: "pause"): #imageLiteral(resourceName: "play")
//            self.PlayPauseButton.setImage(playPauseImage, for: .normal)
            if (isPlaying) {
                if player.status == .readyToPlay &&
                   (playerLayer != nil || setupPlayLayer())
                {
                    player.play()
                }
            } else {
                player.pause()
            }
        }
    }

    func setupPlayLayer() -> Bool {
        guard let tracks = player?.currentItem?.asset.tracks(withMediaType: AVMediaTypeVideo),
            tracks.count > 0 else
        {
            return false
        }

        //        if let aspectRatio = aspectRatioForLocalVideo(track: tracks.first!) {
        //            VideoViewHeightConstraint.constant = aspectRatio * VideoView.bounds.width
        //            layoutIfNeeded() //??
        //        }
//        adjustVideoHeight()
        if (playerLayer != nil && playerLayer!.player != player) {
            playerLayer = nil
        }
        if (self.playerLayer == nil) {
            self.playerLayer = AVPlayerLayer(player: self.player)
            self.playerLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        }
        self.playerLayer!.frame = self.bounds

        return true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer?.frame = self.bounds
    }

    func setupModel(_ Track: Track) -> String? {
        model = Track

        if (Track.asset == nil) {
            if let url = URL(string: Track.videoUrl) {
                Track.asset = AVURLAsset(url: url)
            } else {
                return "Invalid URL: \(Track.videoUrl)"
            }
        }

        let playerItem = AVPlayerItem(asset: Track.asset!)
        if player == nil {
            player = AVPlayer(playerItem: playerItem)
        } else {
            player!.replaceCurrentItem(with: playerItem)
        }

        return player?.error?.localizedDescription
    }

    func itemDidFinishPlaying(notification: NSNotification) {
        //        print("did finish playing")
        player?.seek(to: kCMTimeZero) { (done) in
            if (done && self.isPlaying) {
                self.player?.play()
                //                print("playing from start")
            }
        }
    }

    class func aspectRatioForVideo(track: AVAssetTrack) -> CGFloat? {
        let size = track.naturalSize.applying(track.preferredTransform)
        return fabs(size.width) / fabs(size.height)
    }
}
