////
////  PlayTableViewCell.swift
////  CookStream
////
////  Created by Andriy Zymenko on 10/13/16.
////  Copyright © 2016 Andriy Zymenko. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//import AVKit
//
//protocol PlayStreamUpdating {
//    func updatePlayStream(_ playStream: PlayStream)
//}
//
//private var avPlayerStatusContext: Int = 0
//private let statusKey = "status"
//
//class PlayTableViewCell: UITableViewCell {
//
//    @IBOutlet weak var TitleLabel: UILabel!
//    @IBOutlet weak var DescriptionLabel: UILabel!
//    @IBOutlet weak var StarRatingView: CosmosView!
//    @IBOutlet weak var LikeButton: UIButton!
//    
//    @IBOutlet weak var VolumeButton: UIButton!
//    @IBOutlet weak var PlayPauseButton: UIButton!
//
//    @IBOutlet weak var VideoView: UIView!
//    @IBOutlet weak var VideoViewHeightConstraint: NSLayoutConstraint!
//
//    var delegate: PlayStreamUpdating?
//    var model: PlayStream?
//
////    private var asset: AVAsset?
//    private var playerLayer: AVPlayerLayer? {
//        didSet {
//            if let oldLayer = oldValue {
//                oldLayer.removeFromSuperlayer()
//            }
//            if let newLayer = playerLayer {
//                VideoView.layer.insertSublayer(newLayer, at: 0)
//            }
//        }
//    }
//
//    private var player: AVPlayer? {
//        didSet {
//            if let oldPlayer = oldValue {
//                oldPlayer.removeObserver(self, forKeyPath: statusKey,
//                                         context: &avPlayerStatusContext)
//                if let item = oldPlayer.currentItem {
//                    NotificationCenter.default.removeObserver(self,
//                        name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
//                        object: item)
//                }
//            }
//            if (player != nil) {
//                player!.addObserver(self, forKeyPath: statusKey,
//                                    options: NSKeyValueObservingOptions.new,
//                                    context: &avPlayerStatusContext)
//                if let item = player!.currentItem {
//                    NotificationCenter.default.addObserver(self,
//                        selector: #selector(self.itemDidFinishPlaying),
//                        name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
//                        object: item)
//                }
//            }
//        }
//    }
//
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
//    {
//        if let status = change?[NSKeyValueChangeKey.newKey],
//            keyPath == statusKey,
//            context != nil && context! == &avPlayerStatusContext
//        {
//            if let avStatus = status as? Int,
//                avStatus == AVPlayerStatus.readyToPlay.rawValue
//            {
//                if setupPlayLayer() && isPlaying {
//                    self.player!.play()
//                }
//                return
//            }
//        }
//
//        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
//    }
//
//    deinit {
//        player = nil
//        playerLayer = nil
//    }
//
//    var isMuted: Bool = true {
//        didSet {
//            let volumeImage = isMuted ? #imageLiteral(resourceName: "volume-off") : #imageLiteral(resourceName: "volume-high")
//            self.VolumeButton.setImage(volumeImage, for: .normal)
//            player?.isMuted = isMuted
//
//        }
//    }
//
//    var isPlaying: Bool = false {
//        didSet {
//            if player == nil { return }
//            let playPauseImage = isPlaying ? #imageLiteral(resourceName: "pause"): #imageLiteral(resourceName: "play")
//            self.PlayPauseButton.setImage(playPauseImage, for: .normal)
//            if (isPlaying) {
//                if playerLayer != nil {
//                    player!.play()
//                }
////                asset = player?.currentItem?.asset
////                let tracks = asset?.tracks
////                let isPlayable = asset?.isPlayable ?? false
////                let hasTracks = tracks?.count ?? 0 > 0
////                print("isPlayable: \(isPlayable), hasTracks: \(hasTracks)")
//
//            } else {
//                player!.pause()
//            }
//        }
//    }
//
//    var isFavorite: Bool = false {
//        didSet {
//            let heartImage = isFavorite ? #imageLiteral(resourceName: "heart") : #imageLiteral(resourceName: "heart-outline")
//            self.LikeButton.setImage(heartImage, for: .normal)
//            if model != nil {
//                model!.favorite = isFavorite
//                delegate?.updatePlayStream(model!)
//            }
//        }
//    }
//
////    var ratingChanged: ((Double)->()) = {[weak self] (rating) in
////        self?.model?.rating = rating
////    }
//
//    func setupModel(playStream: PlayStream) -> String? {
//        model = playStream
//        let result = setupPlayer(urlString: playStream.videoUrl)
//
//        self.TitleLabel.text = playStream.title
//        self.DescriptionLabel.text = playStream.description
//        self.StarRatingView?.rating = Double(playStream.rating)
//        self.StarRatingView?.didFinishTouchingCosmos = { [weak self] (rating: Double) in
//            guard let this = self else { return }
//            if this.model != nil {
//                this.model!.rating = Int(round(rating))
//                this.delegate?.updatePlayStream(this.model!)
//            }
//        }
//
//        isMuted = true
//        isPlaying = false
//        isFavorite = playStream.favorite
//
//        adjustVideoHeight()
////        VideoViewHeightConstraint.constant = VideoView.bounds.width * playStream.aspectRatio
//
//        return result
//    }
//
//    func setupPlayLayer() -> Bool {
//        guard let tracks = player?.currentItem?.asset.tracks(withMediaType: AVMediaTypeVideo),
//            tracks.count > 0 else
//        {
//            return false
//        }
//
////        if let aspectRatio = aspectRatioForLocalVideo(track: tracks.first!) {
////            VideoViewHeightConstraint.constant = aspectRatio * VideoView.bounds.width
////            layoutIfNeeded() //??
////        }
//        adjustVideoHeight()
//        if (playerLayer != nil && playerLayer!.player != player) {
//            playerLayer = nil
//        }
//        if (self.playerLayer == nil) {
//            self.playerLayer = AVPlayerLayer(player: self.player)
//            self.playerLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
//        }
//        self.playerLayer!.frame = self.VideoView.bounds
//
//        return true
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.playerLayer?.frame = self.VideoView.bounds
//    }
//
//    func adjustVideoHeight() {
//        if (model != nil) {
//            var height = VideoView.bounds.width * model!.aspectRatio
////            let maxHeight = superview?.bounds.height ?? bounds.height
////            if (height > maxHeight) {
////                height = maxHeight
////            }
//            VideoViewHeightConstraint.constant = height
//            setNeedsLayout()
//            layoutIfNeeded()
//        }
//    }
//
//
//    func setupPlayer(urlString: String) -> String? {
//        guard let url = URL(string: urlString) else {
//            return "Invalid URL: \(urlString)"
//        }
////        if let oldPlayer = player {
////            let asset = oldPlayer.currentItem?.asset as? AVURLAsset
////            let tracks = asset?.tracks
////            let isPlayable = asset?.isPlayable ?? false
////            let hasTracks = tracks?.count ?? 0 > 0
//////            print("old player exists: \(asset?.url), isPlayable: \(isPlayable), hasTracks: \(hasTracks)")
//////            print("new player url: \(url)")
////        } else {
//            let asset = AVURLAsset(url: url)
//            let playerItem = AVPlayerItem(asset: asset)
//            player = AVPlayer(playerItem: playerItem)
////        }
//        return player!.error?.localizedDescription
//    }
//
//    func itemDidFinishPlaying(notification: NSNotification) {
////        print("did finish playing")
//        player?.seek(to: kCMTimeZero) { (done) in
//            if (done && self.isPlaying) {
//                self.player?.play()
////                print("playing from start")
//            }
//        }
//    }
//    func aspectRatioForLocalVideo(track: AVAssetTrack) -> CGFloat? {
//        let size = track.naturalSize.applying(track.preferredTransform)
//        return fabs(size.width) / fabs(size.height)
//    }
//
//    @IBAction func heartClicked() {
//        isFavorite = !isFavorite
//    }
//
//    @IBAction func playPauseClicked() {
//        isPlaying = !isPlaying
//    }
//
//    @IBAction func muteClicked() {
//        isMuted = !isMuted
//    }
////    override func awakeFromNib() {
////        super.awakeFromNib()
////        // Initialization code
//////        VideoViewHeightConstraint.constant = VideoView.bounds.width
////    }
////
////    override func setSelected(_ selected: Bool, animated: Bool) {
////        super.setSelected(selected, animated: animated)
////
////        // Configure the view for the selected state
////    }
//
//}
