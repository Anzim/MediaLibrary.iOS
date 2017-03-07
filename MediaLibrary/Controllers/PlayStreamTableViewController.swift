//
//  PlayStreamTableViewController.swift
//  CookStream
//
//  Created by Andriy Zymenko on 10/21/16.
//  Copyright © 2016 Andriy Zymenko. All rights reserved.
//

import UIKit

protocol PlayStreamControllerDelegate: class {
    func updatePlayStream(_ playStream: PlayStream)
    func showDetails(withLayout: PlayStreamLayout)
}

//class PlayStreamTableViewController: UITableViewController {
//
//    //model
//    var playStreamData = [PlayStream]()
//    var searchResults = [PlayStream]()
////    private weak var mainCell: PlayStreamTableViewCell
//
//    func loadData() {
//        PlayStreamDataProvider.GetData { (playStreamData) in
//            DispatchQueue.main.async {
//                self.playStreamData = playStreamData
//                self.searchResults = playStreamData + playStreamData + playStreamData
//                self.tableView.reloadData()
//                self.refreshControl?.endRefreshing()
//            }
//        }
//
//    }
//
//    @IBAction func refreshTable() {
//        self.loadData()
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
////        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
//
//        if let navBar = navigationController?.navigationBar {
//            navBar.setBackgroundImage(UIImage(), for: .default)
//            navBar.shadowImage = UIImage()
//            navBar.isTranslucent = true
//        }
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
////        refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
//        tableView.allowsSelection = false
//        tableView.rowHeight = UITableViewAutomaticDimension //view.bounds.height * 1.5
//        tableView.estimatedRowHeight = view.bounds.height
////        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: UIApplication.shared.statusBarFrame.height))
//            //(0, 0, view.frame.size.width, 20))
//
////        extendedLayoutIncludesOpaqueBars = true;
////        tableView.contentInset.top = UIApplication.shared.statusBarFrame.height
////        tableView.scrollIndicatorInsets.top = UIApplication.shared.statusBarFrame.height
////        edgesForExtendedLayout = []
//        // Do network data fetching
//        loadData()
//    }
//
////    override func didReceiveMemoryWarning() {
////        super.didReceiveMemoryWarning()
////        // Dispose of any resources that can be recreated.
////    }
//
//    func presentAlertError(_ error: String,
//                           completion: (() -> Swift.Void)? = nil)
//    {
//        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
//        present(alert, animated: true, completion: completion)
//    }
//
//    private var playingState: [IndexPath:Bool] = [:]
//
//    func stopPlaying() {
//        playingState.removeAll()
//        guard let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows else {
//            return
//        }
//        for path in indexPathsForVisibleRows  {
//            if let cell = tableView.cellForRow(at: path) as? PlayStreamTableViewCell {
//                playingState[path] = cell.isPlaying
//                cell.isPlaying = false
//            }
//        }
//    }
//
//    func resumePlaying() {
//        guard let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows else {
//            return
//        }
//        for path in indexPathsForVisibleRows  {
//            if let cell = tableView.cellForRow(at: path) as? PlayStreamTableViewCell,
//               let isPlaying = playingState[path]
//            {
//                cell.isPlaying = isPlaying
//            }
//        }
//    }
//
//    override func viewDidLayoutSubviews()
//    {
//        super.viewDidLayoutSubviews()
//        tableView.contentInset.top = topLayoutGuide.length
//    }
//
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1;
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//        return section == 0 ? searchResults.count: 0
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayStreamTableViewCell", for: indexPath) as? PlayStreamTableViewCell
//            else {
//                return UITableViewCell()
//        }
//        let row = indexPath.row
//        if row < searchResults.count {
//            let playStream = searchResults[row]
//            if let error = cell.setupModel(playStream) {
//                presentAlertError(error)
//            } else {
//                cell.delegate = self
//                cell.adjustVideoSize(superViewSize: tableView.bounds.size)
//            }
//        }
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
//    {
//        guard let playCell = cell as? PlayStreamTableViewCell else { return }
//        playCell.isPlaying = true
//        let visibleCells = tableView.visibleCells
//        playCell.isMuted = visibleCells.count > 0
//        //        visibleCellRows.append(indexPath.row)
//    }
//
//    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
//    {
//        guard let playCell = cell as? PlayStreamTableViewCell else { return }
//        playCell.isPlaying = false
//        playCell.isMuted = true
//        //        if let row = visibleCellRows.index(of: indexPath.row) {
//        //            visibleCellRows.remove(at: row)
//        //        }
//        var visibleCells = tableView.visibleCells
//        if let index = visibleCells.index(of: cell) {
//            visibleCells.remove(at: index)
//        }
//        if let firstCell = visibleCells.first as? PlayStreamTableViewCell {
//            firstCell.isMuted = false
//        }
//    }
//
////    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
////    {
////        tableView.deselectRow(at: indexPath, animated: false)
////        if let cell = tableView.cellForRow(at: indexPath) as? PlayStreamTableViewCell,
////            let model = cell.model
////        {
////            performSegue(withIdentifier: "FromPlayStreamToCookViewController",
////                         sender: model)
////        }
////    }
//
////    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
////    {
////        return
////    }
//    /*
//    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//    */
//
//    /*
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
//    */
//
//    /*
//    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//    }
//    */
//
//    /*
//    // Override to support conditional rearranging of the table view.
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
//    */
//
//
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        let senderType = Mirror(reflecting: sender!).subjectType
////        print(senderType)
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if  let destination = segue.destination as? CookViewController,
////            let tap = sender as? UITapGestureRecognizer,
////            let tableView = tap.view as? VideoView,
//            let layout = sender as? PlayStreamLayout, //tableView.model,
//            segue.identifier == "FromPlayStreamToCookViewController"
//        {
//            destination.layout = layout
//        }
//    }
//}
//
//extension PlayStreamTableViewController: PlayStreamControllerDelegate {
//
//    internal func showDetails(withLayout playStreamLayout: PlayStreamLayout)
//    {
//        performSegue(withIdentifier: "FromPlayStreamToCookViewController",
//                     sender: playStreamLayout)
//    }
//
//    internal func updatePlayStream(_ playStream: PlayStream) {
//        //TODO: impl
//    }
//
//}
