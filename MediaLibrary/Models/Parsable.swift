//
//  Parsable.swift
//  MediaLibrary
//
//  Created by Andriy Zymenko on 09.11.16.
//  Copyright © 2016 Anzim. All rights reserved.
//

import UIKit

protocol Parsable {
    static var resourceString: String { get }
    init?(JSONDictionary: [String: Any])
    func propertyTitle(property: String) -> String
//    func propertyValue(property: String) -> String
}

extension Parsable {
    init?(JSONString: String) {
        
        guard let JSONData = JSONString.data(using: String.Encoding.utf8, allowLossyConversion: false),
            let JSONDictionaryObject = try? JSONSerialization.jsonObject(with: JSONData, options: []),
            let JSONDictionary = JSONDictionaryObject as? [String: Any] else
        {
            return nil
        }
        self.init(JSONDictionary: JSONDictionary)
    }
    
    
}

class Asset: NSObject {
//    static var resourceString: String = "Asset"

    static var excludedProperties: [String] = [
        "parentId", "hasMp3", "isCategory", "trackId",
        "folderId", "downloadable", "musicFile", "privacy"
    ]
    static var propertyTitles: [String: String] = [
        "folderName": "Наименование",
//        "parentId": "Код категории",
        "zipFile": "Имя zip файла",
//        "hasMp3": "Есть mp3",
//        "isCategory": "Категория",
//        "trackId": "Код записи",
        "trackTitle": "Название",
//        "folderId": "Код альбома",
        "artist": "Артист",
        "album": "Альбом",
        "trackYear": "Год",
        "comments": "Заметки",
        "genre": "Жанр",
        "trackNumber": "Номер записи",
        "trackFile": "Имя файла",
        "trackDisplayOption": "Порядок отображения",
//        "downloadable": "Скачиваемый",
//        "musicFile": "Проигрываемый",
        "width": "Ширина",
        "height": "Высота",
//        "privacy": "Состояние",
        "fileSize": "Размер файла",
        "duration": "Длительность",
        "addDate": "Дата создания",
        "updateDate": "Дата обновления"
    ]
    var descriptions = [(String,String)]()
    
    var folderId: Int = 0
    var privacy = Privacy.Private
    var downloadable: Bool = false
    var addDate: String = "" //Date? = nil
//    var addDateValue: Date? = nil
    var updateDate: String = "" //Date? = nil
    
    func propertyTitle(property: String) -> String {
        return Asset.propertyTitles[property] ?? property
    }
    
    func hasPropertyTitle(property: String) -> String {
        return Asset.propertyTitles[property] ?? property
    }

    convenience init?(JSONDictionary: [String : Any]) {
        self.init()
        for (key, value) in JSONDictionary {
            var value: Any = value
            if let privacyValue = value as? String, key == "privacy" {
                if (privacyValue == "public") {
                    self.privacy = .Public
                    value = "Опубликовано"
                } else {
                    self.privacy = .Private
                    value = "Неопубликовано"
                }
                continue
            } //else if let dateValue = value as? String, key.contains("Date") {
//                let dateFormater = DateFormatter()
//                dateFormater.dateStyle = .medium ??
//                dateFormater.timeStyle = .medium ??
//                let date = dateFormater.date(from: dateValue)
////                value = date as Any
//            }
            
            if (self.responds(to: NSSelectorFromString(key))) { // If property exists
                if (value is NSNull) {
                    continue
                } else {
                    self.setValue(value, forKey: key)
                }
            } else {
                print("Property \(key) is not exist in this class")
            }
            
            if Asset.excludedProperties.contains(key) { continue }
            if let setValue = self.value(forKey: key) {
                let title = propertyTitle(property: key)
                var description = "\(setValue)"
                if let date = setValue as? Date {
                    description = "\(date)"
                }
                descriptions.append((title, description))
            }
        }
        
    }
    
    func propertyValue(property: String) -> String {
        let result = value(forKey: property)
        return result.debugDescription
    }
    
//    func properties() -> [String: String] {
//        let result = value(forKey: )
//    }
}

//extension Asset {
//    static var resourceString: String { return "Assets" }
//}

//protocol ParsableClassProtocol: NSObjectProtocol, Parsable {
//    init()
//}
//
//class ParsableClass: NSObject, ParsableClassProtocol {
//
//    convenience init?(JSONDictionary: [String: Any]) {
//        self.init()
//        // Loop
//        for (key, value) in JSONDictionary {
//            "keyName = key as String
//
//            if (self.respondsToSelector(NSSelectorFromString(keyName))) {
//                let keyValue: String = value as? String
//                // If property exists
//                self.setValue(keyValue, forKey: keyName)
//            }
//        }
//        // Or you can do it with using
//        self.setValuesForKeys(JSONDictionary)
//        // instead of loop method above
//    }
//    
//}
