//
//  Track.swift
//  MediaLibrary
//
//  Created by Andriy Zymenko on 09.11.16.
//  Copyright © 2016 Anzim. All rights reserved.
//

import UIKit

protocol TrackProtocol {
    var trackId: Int { get }
    var trackTitle: String { get }
    var folderId: Int { get }
    var artist: String { get }
    var album: String { get }
    var trackYear: String { get }
    var comments: String { get }
    var genre: String { get }
    var trackNumber: Int { get }
    var trackFile: String { get }
    var trackDisplayOption: String { get }
    var downloadable: Bool { get }
    var musicFile: Bool { get }
    var width: Int { get }
    var height: Int { get }
    var privacy: Privacy { get }
    var fileSize: Int { get }
    var duration: String { get }
    var addDate: Date? { get }
    var updateDate: Date? { get }
}

extension TrackProtocol {
    static var resourceString: String { return "Tracks" }
}

final class Track: Asset, Parsable, TrackProtocol {
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
//                print("Property \(key) is not exist in Track class")
//            }
//        }
//
//    }

    var trackId: Int = 0
    var trackTitle: String = ""
    var artist: String = ""
    var album: String = ""
    var trackYear: String = ""
    var comments:String = ""
    var genre: String = ""
    var trackNumber: Int = 0
    var trackFile: String = ""
    var trackDisplayOption: String = ""
    var musicFile: Bool = false
    var width: Int = 0
    var height: Int = 0
    var fileSize: Int = 0
    var duration: String = ""
}

//struct TrackModel: TrackProtocol {
//    let trackId: Int
//    let trackTitle: String
//    let folderId: Int
//    let artist: String
//    let album: String
//    let trackYear: String
//    let comments: String
//    let genre: String
//    let trackNumber: Int = 0
//    let trackFile: String
//    let trackDisplayOption: String
//    let downloadable: Bool
//    let musicFile: Bool
//    let width: Int = 0
//    let height: Int = 0
//    let privacy: Privacy
//    let fileSize: Int
//    let duration: String
//    let addDate: String
//    let updateDate: String
    
//    init(JSONDictionary: [String : Any]) {
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
//                print("Property \(key) is not exist in Track class")
//            }
//        }
//
//    }

//}
