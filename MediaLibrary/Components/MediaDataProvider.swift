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
            resourcePath += ".\(id)"
        }
        if let url = Bundle.main.url(forResource: resourcePath, withExtension: "json", subdirectory: "Data")
        {
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

struct NetworkDataSource: DataSourceProtocol {
    static let basePath = "http://api.propovednik.com/"
    func GetData(resourceString: String, id: Int?, callback: (DataResult) -> ()) {
        var resourcePath = NetworkDataSource.basePath + resourceString
        if let id = id, id != 0 {
            if resourceString == "Folders" {
                resourcePath += "/\(id)/Children"
            } else if resourceString == "Tracks" {
                resourcePath = NetworkDataSource.basePath + "Folders/\(id)/Tracks"
            } else {
                resourcePath += "/\(id)"
            }
        }
        if let url = URL(string: resourcePath)
        {
            do {
                let data = try Data(contentsOf: url, options: .alwaysMapped)
                callback(DataResult.Data(data))
            } catch let error {
                callback(DataResult.Error(error.localizedDescription))
            }
        } else {
            callback(DataResult.Error("URL \(resourcePath) is not valid."))
        }
    }
}

struct MediaDataProvider: DataProviderProtocol {
    var dataSource: DataSourceProtocol  = NetworkDataSource()
}
