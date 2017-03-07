//
//  MediaDataSource.swift
//  MediaLibrary
//
//  Created by Andriy Zymenko on 10.11.16.
//  Copyright © 2016 Anzim. All rights reserved.
//

import UIKit



class MediaDataSource: NSObject {
    func loadJson(forFilename fileName: String) -> Any? {
        
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
            let data = NSData(contentsOf: url)
        {
            do {
                let object = try JSONSerialization.jsonObject(with: data as Data, options: [])
                
                return object
            } catch {
                print("Error!! Unable to parse  \(fileName).json")
            }
            print("Error!! Unable to load  \(fileName).json")
        }
        
        return nil
    }
}
