//
//  CookViewController.swift
//  CookStream
//
//  Created by Andriy Zymenko on 10/25/16.
//  Copyright © 2016 Andriy Zymenko. All rights reserved.
//

import UIKit
import CoreMedia
import AVFoundation

class CookViewController: UIViewController, PlayStreamDelegate {


    //MARK: - outlets
    @IBOutlet weak var InfoView: UIView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var StarRatingView: CosmosView!
    @IBOutlet weak var LikeButton: UIButton!

    @IBOutlet weak var VolumeButton: UIButton!
    @IBOutlet weak var PlayPauseButton: UIButton!
    @IBOutlet weak var PlayControlView: UIView!

    @IBOutlet weak var VideoView: VideoView!

    @IBOutlet weak var AspectRatioConstraint: NSLayoutConstraint!
    @IBOutlet weak var VideoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var VideoViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet var VideoViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var VideoViewCenterXConstraint: NSLayoutConstraint!
    @IBOutlet var VideoViewCenterYConstraint: NSLayoutConstraint!

    @IBOutlet var InfoViewTopToSuperViewConstraint: NSLayoutConstraint!
    @IBOutlet var InfoViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var TimeSlider: UISlider!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var FullTimeLabel: UILabel!

    //MARK: - actions
    @IBAction func BackClicked() {
        //        _ = navigationController?.popViewController(animated: true)
        dismiss(animated: false, completion: nil)
    }

    @IBAction func RotateClicked() {
    }

    @IBAction func heartClicked() {
        isFavorite = !isFavorite
    }

    @IBAction func playPauseClicked() {
        isPlaying = !isPlaying
    }

    @IBAction func muteClicked() {
        isMuted = !isMuted
    }

    @IBAction func timeSliderTouchedDown(_ sender: UISlider) {
        isDraggingTimeSlider = true
//        setTimeObserver(active: false)
    }

    @IBAction func sliderDragged(_ sender: UISlider) {
        updateTimeLabelFromSlider()
    }

    var seeking = false

    @IBAction func playTimeChanged(_ sender: UISlider) {
        self.isDraggingTimeSlider = false
        if let player = player {
//            player.pause()
            let prevTime = player.currentTime()
            let cmTime = CMTimeMake(Int64(round(sender.value * Float(prevTime.timescale))), prevTime.timescale)
            //        self.timeToSet = cmTime
            seeking = true
            player.seek(to: cmTime) {[weak self] _ in
                guard let this = self else { return }
                this.seeking = false
                this.displayAudioTime(cmTime: cmTime)
            }
            //        print("playTimeChanged seeking")
//            DispatchQueue.main.async {
//                player.play()
//
////                print("defered playing, observer was set")
//                let deadLine = DispatchTime(uptimeNanoseconds:
//                    DispatchTime.now().rawValue + NSEC_PER_SEC)
//                DispatchQueue.main.asyncAfter(deadline: deadLine)
//                { [weak self] in
//                    guard let this = self else { return }
//                    if !this.isDraggingTimeSlider {
//                        this.setTimeObserver(active: true)
//                    }
//                }
//            }
        }
    }

    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        IsDetailsHidden = !IsDetailsHidden
    }
    //MARK: - variables
//    var delegate: PlayStreamUpdating?
    var model: PlayStream?
    var layout: PlayStreamLayout? {
        didSet {
            model = layout?.model
        }
    }

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
            setTimeObserver(active: isPlaying)
            let playPauseImage = isPlaying ? #imageLiteral(resourceName: "pause"): #imageLiteral(resourceName: "play")
            self.PlayPauseButton?.setImage(playPauseImage, for: .normal)
        }
    }

    private var isFavorite: Bool = false {
        didSet {
            let heartImage = isFavorite ? #imageLiteral(resourceName: "heart") : #imageLiteral(resourceName: "heart-outline")
            self.LikeButton.setImage(heartImage, for: .normal)
            //            if model != nil {
            //                model!.favorite = isFavorite
            //                delegate?.updatePlayStream(model!)
            //            }
        }
    }

    var IsDetailsHidden: Bool = false {
        didSet {
            InfoView.isHidden = IsDetailsHidden
            PlayControlView.isHidden = IsDetailsHidden
        }
    }

    var player: AVPlayer? { return VideoView?.player }

    var aspectRatio = CGFloat(1) {
        didSet {
            if (aspectRatio != oldValue) {
                let active = AspectRatioConstraint.isActive
                let newAspectRatioConstraint = NSLayoutConstraint(item: VideoView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: VideoView, attribute: NSLayoutAttribute.width, multiplier: aspectRatio, constant: 0)
                AspectRatioConstraint.isActive = false
                AspectRatioConstraint = newAspectRatioConstraint
                newAspectRatioConstraint.isActive = active
            }
        }
    }

    //MARK: - functions
    private func setupLayout() {
        guard let layout = self.layout else { return }

        view.frame = layout.superViewFrame

        VideoView.frame = layout.videoViewFrame
        VideoViewHeightConstraint.constant = VideoView.bounds.height
//        VolumeButton.frame = layout.volumeButtonFrame
//        PlayPauseButton.frame = layout.playPauseButtonFrame

        InfoView.frame = layout.infoViewFrame
        TitleLabel.frame = layout.titleLabelFrame
        DescriptionLabel.frame = layout.descriptionLabelFrame
        LikeButton.frame = layout.likeButtonFrame
        StarRatingView.frame = layout.starRatingViewFrame

        let top = CGFloat(20) //topLayoutGuide.length
        VideoViewTopConstraint.constant = VideoView.frame.origin.y - top
        VideoViewLeftConstraint.constant = VideoView.frame.origin.x
        InfoViewTopToSuperViewConstraint.constant = InfoView.frame.origin.y - top

        toggleConstraints(initialState: true)
    }


    private func setupModel(_ model: PlayStream) -> String? {
        let result = VideoView.setupModel(model)
        setupVideoControls()
        aspectRatio = model.aspectRatio

        TitleLabel.text = model.title
        DescriptionLabel.text = model.desc
        StarRatingView.rating = Double(model.rating)
        StarRatingView.didFinishTouchingCosmos = { [weak self] (rating: Double) in
            guard let this = self else { return }
            if this.model != nil {
                this.model!.rating = Int(round(rating))
//                this.updatePlayStream(this.model!)
            }
        }
        
        isMuted = false
        isPlaying = true
        isFavorite = model.favorite

//        setInitialVideoHeight()

        return result
    }

    func toggleConstraints(initialState: Bool) {
        VideoViewTopConstraint.isActive = initialState
        VideoViewLeftConstraint.isActive = initialState
        VideoViewCenterXConstraint.isActive = !initialState
        VideoViewCenterYConstraint.isActive = !initialState

        InfoViewBottomConstraint.isActive = !initialState
        InfoViewTopToSuperViewConstraint.isActive = initialState
    }

    func setVideoFullScreenWithAnimation()  {
        toggleConstraints(initialState: false)
        //            view.setNeedsLayout()

        let screenSize: CGRect = UIScreen.main.bounds
        //        if (VideoViewHeightConstraint.constant != screenSize.height) {
        VideoViewHeightConstraint.constant = screenSize.height
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations:
            {
                self.view.layoutIfNeeded()
            }, completion: nil)
        //        }
        self.layout = nil
    }


    //MARK: - overridden functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLayout()
        view.sendSubview(toBack: VideoView)
        if (model != nil) {
            _ = setupModel(model!)
        } else {
            PlayStreamDataProvider.GetData {
                model = $0.first
                _ = setupModel(model!)
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        isPlaying = false
    }

    override func viewDidAppear(_ animated: Bool) {
        isPlaying = true
        if (layout != nil) {
            setVideoFullScreenWithAnimation()
        }
    }


//
//    override func viewDidLayoutSubviews() {
////        adjustVideoSize(superViewSize: view?.bounds.size)
//    }
//
//    override func viewWillLayoutSubviews() {
////        adjustVideoSize(superViewSize: view?.bounds.size)
//    }
//

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    private var timeObserver: Any? = nil
    //    private var timeToSet: CMTime? = nil
    private var isDraggingTimeSlider: Bool = false

    func setTimeObserver(active: Bool) {
        if (active) {
            timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 2), queue: DispatchQueue.main)
            { (cmTime: CMTime) in
                if (!self.isDraggingTimeSlider) {
                    self.displayAudioTime(cmTime: cmTime)
                }
            }
        } else if timeObserver != nil {
            player?.removeTimeObserver(timeObserver!)
            timeObserver = nil
        }
    }

    func displayAudioTime(cmTime: CMTime) {
        //        print("Audio time: \(cmTime.value)/\(cmTime.timescale)")
        let progress: Float = Float(cmTime.value) / Float(cmTime.timescale)
        TimeLabel?.text = cmTime.durationText
        TimeSlider?.value = progress
        //        print("Audio progress: \(progress)")
    }

    func updateTimeLabelFromSlider() {
        if let prevTime = player?.currentTime() {
            let cmTime = CMTimeMake(Int64(round(TimeSlider.value * Float(prevTime.timescale))), prevTime.timescale)
            //        print("Dragged audio progress: \(timeSlider.value)")
            //        print("Calculated audio time: \(cmTime.value)/\(cmTime.timescale)")
            self.TimeLabel.text = cmTime.durationText
        }
    }

    func setupVideoControls() {
        guard let player = player, player.status == .readyToPlay else { return }
        let currentTime = player.currentTime()
        TimeLabel.text = currentTime.durationText
        TimeSlider.value = Float(CMTimeGetSeconds(currentTime))
        if let duration = player.currentItem?.asset.duration {
            TimeSlider.maximumValue = Float(duration.value) / Float(duration.timescale)
            FullTimeLabel.text = duration.durationText
        } else {
            TimeSlider.maximumValue = 0.0
        }

    }

}

extension CMTime {
    var durationText:String {
        let totalSeconds = CMTimeGetSeconds(self)
        let hours:Int = Int(totalSeconds / 3600)
        let minutes:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 60))

        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
}
