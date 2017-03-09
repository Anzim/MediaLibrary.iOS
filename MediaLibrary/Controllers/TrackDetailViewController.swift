//
//  TrackDetailViewController.swift
//  MediaLibrary
//
//  Created by Андрей Зименко on 08.11.16.
//  Copyright © 2016 Anzim. All rights reserved.
//

import UIKit
import AVFoundation

private var avPlayerStatusContext = 0
private let statusKey = "status"

class TrackDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playViewHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var trackDescriptionLabel: UILabel!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    @IBAction func stopClicked() {
        setPlayState(.stop)
    }
    
    @IBAction func playPauseClicked(_ sender: UIButton) {
        if playerState == .play {
            setPlayState(.pause)
        } else {
            setPlayState(.play)
        }
    }
    
    @IBAction func timeSliderTouchedDown(_ sender: UISlider) {
        isDraggingTimeSlider = true
        setTimeObserver(false)
    }
    
    @IBAction func sliderDragged(_ sender: UISlider) {
        updateTimeLabelFromSlider()
    }
    
    @IBAction func playTimeChanged(_ sender: UISlider) {
        isDraggingTimeSlider = false
        changePlayTime(sender.value)
    }
    
    var folderId: Int? {
        didSet {
            self.loadData()
        }
    }
    var track: Track? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func loadData() {
        guard let id = folderId  else {
            return
        }
        AppDelegate.dataProvider.Get(id: id) { (track: Track?, error: String?) in
            if (error == nil) {
                self.track = track
                return
            } else {
                print(error!)
            }
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        controlView?.isHidden = !isAudioAvailable || mp3Player == nil ||
            mp3Player.status != AVPlayerStatus.readyToPlay
        if let track = self.track, view != nil {
            if track.musicFile {
                playViewHeightConstraint.constant = 44
            } else {
                let ratio = track.width == 0 ? 1 : track.height / track.width
                playViewHeightConstraint.constant = view.bounds.width * CGFloat(ratio)
            }
//            let file = track.trackFile
//            let url = URL(string:"http://www.stephaniequinn.com/Music/Bach%20-%20Jesu,%20Joy%20of%20Man's%20Desiring.mp3")
            //            // "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8))
            //            //""http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"*/))
            if let url = Bundle.main.url(forResource: "Moon", withExtension: "mp4",
                                         subdirectory: "Data//Video") {
//            if let url = URL(string: file), file.contains(".mp3")
//            {
                if (mp3Player == nil) {
                    self.setupPlayer(url)
                } else {
                    setupControls()
                }
            }
//            } else {
//                let errorString = "Неверный аудио URL: \(file)"
//                print(errorString)
//            }

//            if let label = self.trackDescriptionLabel {
//                trackDescriptionLabel.text = track.trackTitle
//            }
        }
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate var timeObserver: AnyObject? = nil
    //    private var timeToSet: CMTime? = nil
    fileprivate var isDraggingTimeSlider: Bool = false
    fileprivate var isAudioAvailable: Bool = false

    fileprivate enum PlayState {
        case play
        case pause
        case stop
    }
    fileprivate var playerState = PlayState.stop
    fileprivate var mp3Player: AVPlayer! = nil;
    
    //MARK: - Functions
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if let status = change?[NSKeyValueChangeKey.newKey],
            keyPath == statusKey,
            context != nil && context! == &avPlayerStatusContext
        {
            if let avStatus = status as? Int,
                avStatus == AVPlayerStatus.readyToPlay.rawValue
            {
                //                if setupPlayLayer() && isPlaying {
                //                    self.player!.play()
                //                }
                setupControls()
                return
            }
        }
        //        switch context {
        //        case avPlayerStatusContext:
        //            if let status = change?[NSKeyValueChangeKey.newKey], keyPath == statusKey
        //            {
        //                if let avStatus = status as? Int, avStatus == AVPlayerStatus.readyToPlay.rawValue
        //                {
        //                    setupFooter()
        //                }
        //            }
        //        default:
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        //        }
    }
    
    deinit {
        mp3Player?.removeObserver(self, forKeyPath: statusKey, context: &avPlayerStatusContext)
    }
    
    func itemDidFinishPlaying(_ notification: Notification) {
        setPlayState(.stop)
    }
    
    func setTimeObserver(_ active: Bool) {
        if (active) {
            timeObserver = mp3Player.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 2), queue: DispatchQueue.main)
            { (cmTime: CMTime) in
                self.displayAudioTime(cmTime)
                } as AnyObject?
        } else if timeObserver != nil {
            mp3Player.removeTimeObserver(timeObserver!)
            timeObserver = nil
        }
    }
    
    func displayAudioTime(_ cmTime: CMTime) {
        //        print("Audio time: \(cmTime.value)/\(cmTime.timescale)")
        let progress: Float = Float(cmTime.value) / Float(cmTime.timescale)
        self.timeLabel?.text = cmTime.durationText
        self.timeSlider?.value = progress
        //        print("Audio progress: \(progress)")
    }
    
    func updateTimeLabelFromSlider() {
        let prevTime = self.mp3Player.currentTime()
        let cmTime = CMTimeMake(Int64(round(timeSlider.value * Float(prevTime.timescale))), prevTime.timescale)
        //        print("Dragged audio progress: \(timeSlider.value)")
        //        print("Calculated audio time: \(cmTime.value)/\(cmTime.timescale)")
        self.timeLabel?.text = cmTime.durationText
    }
    
    fileprivate func setPlayState(_ state: PlayState = .play) {
        if mp3Player == nil { return }
        stopButton.isHidden = state == .stop
        switch state {
        case .stop:
            mp3Player.seek(to: kCMTimeZero)
            displayAudioTime(kCMTimeZero)
            let item = mp3Player.currentItem
            mp3Player.replaceCurrentItem(with: nil)
            DispatchQueue.main.async {
                self.mp3Player.replaceCurrentItem(with: item)
            }
            fallthrough
        case .pause:
            mp3Player.pause()
            setTimeObserver(false)
            DispatchQueue.main.async(execute: {
                self.setAudioSessionState(active: false)
            })
            playPauseButton.setImage(UIImage(named: "play.png"), for: UIControlState())
        case .play:
            mp3Player.play()
            setTimeObserver(true)
            setAudioSessionState(active: true)
            playPauseButton.setImage(UIImage(named: "pause.png"), for: UIControlState())
        }
        playerState = state
    }
    
    fileprivate func setAudioSessionState(active: Bool) {
        DispatchQueue.main.async {            
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
                print("AVAudioSession Category Playback OK")
                do {
                    try audioSession.setActive(active, with: AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation)
                    if (active) {
                        self.setPlayInfo()
                        //                    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleAudioInterruption(_:)), name: AVAudioSessionInterruptionNotification, object: nil)
                    } else {
                        //                      NSNotificationCenter.defaultCenter().removeObserver(self, name: AVAudioSessionInterruptionNotification, object: nil)
                    }
                    print("AVAudioSession is Active")
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
//    func setPlayInfoMP() {
//        var nowPlayingInfo: [String: AnyObject] = [
//            MPMediaItemPropertyTitle : profile.title as AnyObject,
//            MPMediaItemPropertyComments : "Gorgid" as AnyObject,
//            MPNowPlayingInfoPropertyPlaybackRate : 1.0 as AnyObject
//        ]
//        if let appImage = UIImage(named: "gorgid") {
//            let artwork = MPMediaItemArtwork(image: appImage)
//            nowPlayingInfo.updateValue(artwork, forKey: MPMediaItemPropertyArtwork)
//        }
//        if let duration = mp3Player.currentItem?.asset.duration {
//            nowPlayingInfo.updateValue(CMTimeGetSeconds(duration) as AnyObject, forKey: MPMediaItemPropertyPlaybackDuration)
//        }
//        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
//    }
//    
    func setPlayInfo() {
//        if #available(iOS 7.1, *) {
//            let commandCenter = MPRemoteCommandCenter.shared()
//            
//            //        commandCenter.previousTrackCommand.enabled = true;
//            //        commandCenter.previousTrackCommand.addTarget(self, action: "previousTrack")
//            //
//            //        commandCenter.nextTrackCommand.enabled = true
//            //        commandCenter.nextTrackCommand.addTarget(self, action: "nextTrack")
//            
//            commandCenter.playCommand.isEnabled = true
//            commandCenter.playCommand.addTarget(self, action: #selector(playAudio))
//            
//            commandCenter.pauseCommand.isEnabled = true
//            commandCenter.pauseCommand.addTarget(self, action: #selector(pauseAudio))
//            
//            commandCenter.dislikeCommand.isEnabled = true
//            commandCenter.dislikeCommand.addTarget(self, action: #selector(dislikeAudio))
//            
//            commandCenter.skipBackwardCommand.isEnabled = false
//            commandCenter.skipForwardCommand.isEnabled = false
//        } else {
//            setPlayInfoMP()
//        }
    }
    
    func playAudio() {
        setPlayState(.play)
    }
    
    func pauseAudio() {
        setPlayState(.pause)
    }
    
    func dislikeAudio() {
        setPlayState(.stop)
    }
    
    //    func handleAudioInterruption(notification: NSNotification) {
    //        print("handleInterruption")
    //        guard let value = (notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? NSNumber)?.unsignedIntegerValue,
    //            let interruptionType =  AVAudioSessionInterruptionType(rawValue: value)
    //            else {
    //                print("notification.userInfo?[AVAudioSessionInterruptionTypeKey]", notification.userInfo?[AVAudioSessionInterruptionTypeKey])
    //                return }
    //        switch interruptionType {
    //        case .Began:
    //            print("began interruption")
    //            setPlayState(.Pause)
    //        default :
    //            print("ended interuption")
    //            if let optionValue = (notification.userInfo?[AVAudioSessionInterruptionOptionKey] as? NSNumber)?.unsignedIntegerValue where AVAudioSessionInterruptionOptions(rawValue: optionValue) == .ShouldResume {
    //                print("should resume")
    //                setPlayState(.Play)
    //            }
    //        }
    //    }
    
    func setupPlayer(_ url: URL) {
        self.isAudioAvailable = true
        let avAssert = AVURLAsset(url: url)
        let avPlayerItem = AVPlayerItem(asset: avAssert)
        let player = AVPlayer(playerItem: avPlayerItem)
        mp3Player = player
        //        player.actionAtItemEnd = AVPlayerActionAtItemEnd.Advance
        NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        player.addObserver(self, forKeyPath: statusKey, options: NSKeyValueObservingOptions.new, context: &avPlayerStatusContext)
        setupControls()
    }
    
    func setupControls() {
        guard let player = mp3Player, controlView != nil && player.status == .readyToPlay else { return }
        controlView?.isHidden = false
        let currentTime = mp3Player.currentTime()
        timeSlider.value = Float(CMTimeGetSeconds(currentTime))
        if let duration = mp3Player.currentItem?.asset.duration {
            timeSlider.maximumValue = Float(duration.value) / Float(duration.timescale)
        } else {
            timeSlider.maximumValue = 0.0
        }
        if global.autoPlay {
            setPlayState(.play)
//            let alert = UIAlertView(title: "Автовоспроизведение", message: "Включено автовоспроизведение. Отключить можно в настройках", delegate: self, cancelButtonTitle: "Хорошо", otherButtonTitles: "Отключить")
//            alert.tag = 4
//            alert.show()
//            global.executeAfter(seconds: 3, name: AutoPlayNotificationHiding) {
//                alert.dismiss(withClickedButtonIndex: 0, animated: true)
//            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        if (self.parent == nil) {
            setPlayState(.stop)
        }
        super.viewDidDisappear(animated)
    }
    
    //    override func isBeingDismissed() -> Bool {
    //        setPlayState(.Stop)
    //        return super.isBeingDismissed()
    //    }
    //MARK: Actions

    func changePlayTime(_ newTime: Float) {
        self.mp3Player.pause()
        let prevTime = self.mp3Player.currentTime()
        let cmTime = CMTimeMake(Int64(round(newTime * Float(prevTime.timescale))), prevTime.timescale)
        //        self.timeToSet = cmTime
        self.mp3Player.seek(to: cmTime)
        displayAudioTime(cmTime)
        //        print("playTimeChanged seeking")
        DispatchQueue.main.async {
            self.mp3Player.play()
            //            print("defered playing, observer was set")
            global.executeAfter(seconds: 0.5, name: "enable time observer") {
                if !self.isDraggingTimeSlider {
                    self.setTimeObserver(true)
                }
            }
        }
    }

}

extension TrackDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let result = track?.descriptions.count ?? 0
        return result
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackDescriptionCell", for: indexPath)
        cell.textLabel?.text = track?.descriptions[indexPath.row].0
        cell.detailTextLabel?.text = track?.descriptions[indexPath.row].1
        return cell
    }
}

extension TrackDetailViewController: UITableViewDelegate {
    
}
