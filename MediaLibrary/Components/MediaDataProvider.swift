//
//  MediaDataProvider.swift
//  MediaLibrary
//
//  Created by Andriy Zymenko on 10/21/16.
//  Copyright © 2016 Andriy Zymenko. All rights reserved.
//

import UIKit
//
//class TestMediaDataProvider: DataProviderProtocol {

enum DataResult {
//    case Error(NSError)
    case Error(String)
    case Data(Data)
//    case JSON(String)
}

//enum ItemResult<TItem> where TItem: Parsable {
//    //    case Error(NSError)
//    case Error(String)
//    case Item(TItem)
//    case Items([TItem])
//    //    case JSON(String)
//}

struct LocalDataSource: DataSourceProtocol {
    func GetData(resourceString: String, id: Int?, callback: (DataResult) -> ()) {
        var resourcePath = resourceString
        if let id = id, id != 0 {
//            resourcePath += "/\(id)"
            resourcePath += ".\(id)"
        }
        if let url = Bundle.main.url(forResource: resourcePath, withExtension: "json", subdirectory: "Data") {
            do {
                let data = try Data(contentsOf: url, options: .alwaysMapped)
                callback(DataResult.Data(data))
            } catch let error {
                callback(DataResult.Error(error.localizedDescription))
            }
        } else {
            callback(DataResult.Error("Bundle resource \(resourcePath) not found."))
        }
    }
}
////    static let defaultJson = "[{"folderId":14185,"folderName":"Аудио Библия","isCategory":true}]"
//    static func GetFolders(parentId: Int = 0, callback: ([Folder]) -> ())
//    {
//        var folderData = [Folder]()
//        var fileName = "folders"
//        if parentId != 0 {
//            fileName += "." + parentId.description
//        }
//        if let array = loadJson(forFilename: fileName) as? [[String: Any]] {
//            for folderDictionary in array {
//                if let folder = Folder(JSONDictionary: folderDictionary) {
//                    folderData.append(folder)
//                } else {
//                    print("JSON \(folderDictionary) can not be converted to Folder class")
//                }
//            }
//        } else {
//            print("JSON is not array of dictionaries")
//        }
//        
//        callback(folderData)
//    }
//    
//    static func GetTracks(parentId: Int, callback: ([Track]) -> ()) {
//        callback([Track]())
//    }
//    
//    static func GetTrack(id: Int, callback: (Track) -> ()) {
//        
//    }
//}
//
struct MediaDataProvider: DataProviderProtocol {
    var dataSource: DataSourceProtocol  = LocalDataSource()
}
