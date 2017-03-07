//
//  MasterViewController.swift
//  MediaLibrary
//
//  Created by Андрей Зименко on 08.11.16.
//  Copyright © 2016 Anzim. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var dataProvider: DataProviderProtocol = AppDelegate.dataProvider
    var FolderTracksViewController: FolderTracksViewController? = nil
    var folders = [Folder]()
    var folderId = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        dataProvider.GetItems(parentId: folderId) { (folders: [Folder], errors: [String]) in
            if (errors.count == 0) {
                self.folders = folders
                return
            }
            for error in errors {
                print(error)
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
//        self.navigationItem.leftBarButtonItem = self.editButtonItem

//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
//        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.FolderTracksViewController = (controllers[controllers.count-1] as? UINavigationController)?.topViewController as? FolderTracksViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController?.isCollapsed ?? true
        super.viewWillAppear(animated)
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

//    func insertNewObject(_ sender: Any) {
//        objects.insert(NSDate(), at: 0)
//        let indexPath = IndexPath(row: 0, section: 0)
//        self.tableView.insertRows(at: [indexPath], with: .automatic)
//    }

    // MARK: - Segues
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let cell = sender as? FolderTableViewCell, identifier == "showDetail",
           let folder = cell.folder, folder.isCategory
        {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let topController = (segue.destination as? UINavigationController)?.topViewController else { return }
        
        var folder: Folder?
        if let controller = topController as? MasterViewController,
            //indexPath = self.tableView.indexPathForSelectedRow,
            segue.identifier == "showMaster"
        {
            folder = sender as? Folder
//            folder = folders[indexPath.row]
            controller.folderId = folder!.folderId
        }
        else if let controller = topController as? FolderTracksViewController,
            segue.identifier == "showDetail"
        {
            if let cell = sender as? FolderTableViewCell {
                folder = cell.folder
            } else {
                folder = sender as? Folder
            }
            controller.folder = folder
        } else {
            return
        }
        
        let navigationItem: UINavigationItem = topController.navigationItem
        navigationItem.title = folder?.folderName
        navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
    }

    // MARK: - Table View
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let folder = folders[indexPath.row]
        var segueId = "showDetail"
        if folder.isCategory {
            segueId = "showMaster"
        }
        performSegue(withIdentifier: segueId, sender: folder)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath) as? FolderTableViewCell else { return UITableViewCell() }
        let folder = folders[indexPath.row]
        
        cell.folder = folder
        cell.textLabel?.text = folder.folderName
        cell.detailTextLabel?.text = folder.zipFile
        if (folder.isCategory) {
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            objects.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        }
//    }


}

