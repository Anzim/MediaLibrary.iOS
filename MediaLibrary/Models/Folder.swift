//
//  Folder.swift
//  MediaLibrary
//
//  Created by Andriy Zymenko on 10/13/16.
//  Copyright © 2016 Andriy Zymenko. All rights reserved.
//

import UIKit

protocol FolderDelegate {
    var model: Folder? { get }
}

enum Privacy {
    case Public
    case Private
}

protocol AssetProtocol {
    var folderId: Int { get }
    var privacy: Privacy { get }
    var downloadable: Bool { get }
    var addDate: Date? { get }
    var updateDate: Date? { get }
}

protocol FolderProtocol : AssetProtocol {
    var folderId: Int { get }
    var folderName: String { get }
    var parentId: Int { get }
    var privacy: Privacy { get }
    var downloadable: Bool { get }
    var zipFile: String { get }
    var hasMp3: Bool { get }
    var addDate: String { get }
    var updateDate: String { get }
    var isCategory: Bool { get }
}
extension FolderProtocol {
    static var resourceString: String { return "Folders" }
}

//struct FolderModel: FolderProtocol {
//    let folderId: Int
//    let folderName: String
//    let parentId: Int
//    let privacy: Privacy
//    let downloadable: Bool
//    let zipFile: String
//    let hasMp3: Bool
//    let addDate: String
//    let updateDate: String
//    let isCategory: Bool
//}

final class Folder: Asset, Parsable, FolderProtocol {
//    convenience init?(JSONDictionary: [String : Any]) {
//        self.init()
//        for (key, value) in JSONDictionary {
//            if let privacyValue = value as? String, key == "privacy" {
//                if (privacyValue == "public") {
//                    self.privacy = .Public
//                } else {
//                    self.privacy = .Private
//                }
//                continue
//            }
//            
//            if (self.responds(to: NSSelectorFromString(key))) { // If property exists
//                if !(value is NSNull) {
//                    self.setValue(value, forKey: key)
//                }
//            } else {
//                print("Property \(key) is not exist in Folder class")
//            }
//        }
//    }

    var folderName: String = ""
    var parentId: Int = 0
    var zipFile: String = ""
    var hasMp3: Bool = false
    var isCategory: Bool = false
    
//    let videoUrl: String
//    let title: String
//    let desc: String
//    var favorite: Bool = false
//    var rating: Int = 0
//    var tags =  [String]()
//    let width: Int
//    let height: Int
//    var aspectRatio: CGFloat { return CGFloat(height) / CGFloat(width) }
//    var asset: AVURLAsset? = nil
//
//    init(//videoUrl: String,
//         title: String, desc: String,
//         favorite: Bool = false, rating: Int = 0,
//         tags: [String] = [], width: Int, height: Int,
//         asset: AVURLAsset? = nil)
//    {
////        self.videoUrl = videoUrl
//        self.title = title
//        self.desc = desc
//        self.favorite = favorite
//        self.rating = rating
//        self.tags = tags
//        self.width = width
//        self.height = height
//        self.asset = asset
//    }
    
}


