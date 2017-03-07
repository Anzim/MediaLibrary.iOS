//
//  TrackDetailViewController.swift
//  MediaLibrary
//
//  Created by Андрей Зименко on 08.11.16.
//  Copyright © 2016 Anzim. All rights reserved.
//

import UIKit

class TrackDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var trackDescriptionLabel: UILabel!
    
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
        if let track = self.track, view != nil {
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
