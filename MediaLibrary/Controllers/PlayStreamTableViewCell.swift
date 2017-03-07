//
//  FolderTableViewCell.swift
//  MediaLibrary
//
//  Created by Andriy Zymenko on 10/21/16.
//  Copyright © 2016 Andriy Zymenko. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class FolderTableViewCell: UITableViewCell, FolderDelegate
{
    let VideoViewMargins: CGFloat = 8 * 2
//    var view: UIView? { return self }

    @IBOutlet weak var InfoView: UIView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
//    @IBOutlet weak var StarRatingView: CosmosView!
    @IBOutlet weak var LikeButton: UIButton!

    @IBOutlet weak var VolumeButton: UIButton!
    @IBOutlet weak var PlayPauseButton: UIButton!

    @IBOutlet weak var VideoView: VideoView!
    @IBOutlet weak var VideoViewHeightConstraint: NSLayoutConstraint!
    weak var aspectRatioConstraint: NSLayoutConstraint?

    @IBAction func heartClicked() {
        isFavorite = !isFavorite
    }

    @IBAction func playPauseClicked() {
        isPlaying = !isPlaying
    }

    @IBAction func muteClicked() {
        isMuted = !isMuted
    }

    weak var delegate: FolderControllerDelegate?
    var model: Folder?

    var isMuted: Bool = true {
        didSet {
            let volumeImage = isMuted ? #imageLiteral(resourceName: "volume-off") : #imageLiteral(resourceName: "volume-high")
            self.VolumeButton?.setImage(volumeImage, for: .normal)
            VideoView?.isMuted = isMuted

        }
    }

    var isPlaying: Bool = false {
        didSet {
//            guard let player = player else { return }
            VideoView.isPlaying = isPlaying
            let playPauseImage = isPlaying ? #imageLiteral(resourceName: "pause"): #imageLiteral(resourceName: "play")
            self.PlayPauseButton?.setImage(playPauseImage, for: .normal)
//            if (isPlaying) {
//                if playerLayer != nil {
//                    player!.play()
//                }
//                //                asset = player?.currentItem?.asset
//                //                let tracks = asset?.tracks
//                //                let isPlayable = asset?.isPlayable ?? false
//                //                let hasTracks = tracks?.count ?? 0 > 0
//                //                print("isPlayable: \(isPlayable), hasTracks: \(hasTracks)")
//
//            } else {
//                player!.pause()
//            }
        }
    }

    private var isFavorite: Bool = false {
        didSet {
            let heartImage = isFavorite ? #imageLiteral(resourceName: "heart") : #imageLiteral(resourceName: "heart-outline")
            self.LikeButton.setImage(heartImage, for: .normal)
//            if model != nil {
//                model!.favorite = isFavorite
//                delegate?.updateFolder(model!)
//            }
        }
    }


    func setupModel(_ Folder: Folder) -> String? {
        model = Folder
        let result = VideoView.setupModel(Folder)
        let newAspectRatioConstraint = NSLayoutConstraint(item: VideoView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: VideoView, attribute: NSLayoutAttribute.width, multiplier: Folder.aspectRatio, constant: 0)
        aspectRatioConstraint?.isActive = false
//        VideoView.addConstraint(newAspectRatioConstraint)
        aspectRatioConstraint = newAspectRatioConstraint
        newAspectRatioConstraint.isActive = true
        setNeedsUpdateConstraints()
//        adjustVideoHeight()

//        InfoView.setupModel(Folder: Folder)
        self.TitleLabel.text = Folder.title
        self.DescriptionLabel.text = Folder.desc
//        self.StarRatingView?.rating = Double(Folder.rating)
//        self.StarRatingView?.didFinishTouchingCosmos = { [weak self] (rating: Double) in
//            guard let this = self else { return }
//            if this.model != nil {
//                this.model!.rating = Int(round(rating))
//                this.delegate?.updateFolder(this.model!)
//            }
//        }

        isMuted = true
        isPlaying = false
        isFavorite = Folder.favorite

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showDetails))
        VideoView.addGestureRecognizer(gestureRecognizer)
        return result
    }

    func showDetails() {
//        guard let layout = createFolderLayout() else { return }
//        delegate?.showDetails(withLayout: layout)
    }

    func adjustVideoSize(superViewSize: CGSize?) {
        guard let model = self.model, let sizeWithMargins = superViewSize else { return }
        let aspectRatio = model.aspectRatio

        let maxHeight = sizeWithMargins.height - VideoViewMargins
        let maxWidth = sizeWithMargins.width - VideoViewMargins

        var height = maxWidth * aspectRatio
//        var width = maxWidth

        if (height > maxHeight) {
            height = maxHeight
//            width = maxHeight / aspectRatio
        }
        if (VideoViewHeightConstraint.constant != height) {
            VideoViewHeightConstraint.constant = height
            setNeedsUpdateConstraints()
            setNeedsLayout()
        }
    }

//    func createFolderLayout() -> FolderLayout? {
//        guard let topView = superview?.superview?.superview,
//              let Folder = model
//            else { return nil }
//
//        let result = FolderLayout(model: Folder)
//        result.superViewFrame = topView.frame
//
//        result.videoViewFrame = convert(VideoView.frame, to: topView)
//        result.volumeButtonFrame = VolumeButton.frame
//        result.playPauseButtonFrame = PlayPauseButton.frame
//
//        result.infoViewFrame = convert(InfoView.frame, to: topView)
//        result.titleLabelFrame = TitleLabel.frame
//        result.descriptionLabelFrame = DescriptionLabel.frame
//        result.likeButtonFrame = LikeButton.frame
//        result.starRatingViewFrame = StarRatingView.frame
//
//        return result
//    }

    override func layoutSubviews() {
        super.layoutSubviews()
        adjustVideoSize(superViewSize: superview?.bounds.size)
    }

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        if (!animated) {
//            super.setSelected(selected, animated: false)
//        }

        // Configure the view for the selected state
//    }
}
