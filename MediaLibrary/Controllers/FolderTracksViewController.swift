//
//  FolderTracksViewController.swift
//  MediaLibrary
//
//  Created by Andriy Zymenko on 11.11.16.
//  Copyright © 2016 Anzim. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class FolderTracksViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addDateLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var folder: Folder? {
        didSet {
            self.loadData()
        }
    }
    var tracks: [Track]? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func loadData() {
        guard let folder = self.folder, !folder.isCategory  else {
            return
        }
        
        AppDelegate.dataProvider.GetItems(parentId: folder.folderId)
        { (tracks: [Track], errors: [String]) in
            if (errors.count == 0) {
                self.tracks = tracks
                return
            }
            for error in errors {
                print(error)
            }
        }
    }
    
    func configureView() {
        guard let folder = self.folder, view != nil else {
            return
        }
        
        self.navigationItem.title = folder.folderName
        self.addDateLabel.text = folder.addDate
        self.updateDateLabel.text = folder.updateDate
        self.descriptionLabel.text = folder.zipFile
        
        guard let tracks = self.tracks else {
            return
        }
        tableView.isHidden = tracks.count <= 0
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if folder != nil {
            configureView()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if  let controller = segue.destination as? TrackDetailViewController,
            let cell = sender as? TrackTableViewCell,
            segue.identifier == "showTrackDetail"
        {
            controller.track = cell.track
        }
    }
}

extension FolderTracksViewController: UITableViewDelegate {
    private func play(streamURL: URL) {
        let playerController = AVPlayerViewController()
        let player = AVPlayer(url: streamURL)
        playerController.player = player
        playerController.showsPlaybackControls = true
        player.play()
        self.addChildViewController(playerController)
        self.descriptionLabel.addSubview(playerController.view)
        playerController.view.frame = self.descriptionLabel.frame
//        self.navigationController?.pushViewController(playerViewController, animated: true)
//        (playerViewController, animated: true) {
//            playerViewController.dismiss(animated: true, completion: nil)
//        }
        
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
    {
        if let url = Bundle.main.url(forResource: "Moon", withExtension: "mp4",
                                     subdirectory: "Data//Video")
        {
            //            player = AVPlayer(url: url)
            play(streamURL: url)
        }
    }
}

extension FolderTracksViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell", for: indexPath) as! TrackTableViewCell
        cell.track = tracks?[indexPath.row]
//        cell.detailTextLabel?.text = tracks?[indexPath.row].comments
        return cell
    }
}
