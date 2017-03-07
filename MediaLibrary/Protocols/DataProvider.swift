import UIKit

protocol DataSourceProtocol {
    func GetData(resourceString: String, id: Int?, callback: (DataResult) -> ())
}

protocol DataProviderProtocol {
    var dataSource: DataSourceProtocol { get }
    
//    func GetFolders(parentId: Int, callback: ([Folder]) -> ())
//    func GetTracks(parentId: Int, callback: ([Track]) -> ())
    func GetItems<TItem>(parentId: Int, callback: ([TItem], _ errors: [String]) -> ()) where TItem: Parsable
    func Get<TItem>(id: Int, callback: (TItem?, String?) -> ()) where TItem: Parsable
}

extension DataProviderProtocol {
    func GetItems<TItem>(parentId: Int, callback: (_ items: [TItem], _ errors: [String]) -> ()) where TItem: Parsable {
        let resourceString = TItem.resourceString;
        dataSource.GetData(resourceString: resourceString, id: parentId)
        { (dataResult: DataResult) in
            var items = [TItem]()
            var errors = [String]()
            switch dataResult {
            case .Error(let error): errors.append(error)
            case .Data(let data):
                do {
                    let object = try JSONSerialization.jsonObject(with: data, options: [])
                    if let array = object as? [[String: Any]] {
                        for itemDictionary in array {
                            if let item = TItem(JSONDictionary: itemDictionary) {
                                items.append(item)
                            } else {
                                errors.append("JSON \(itemDictionary) can not be converted to \(TItem.resourceString) class")
                            }
                        }
                    } else {
                        errors.append("JSON is not array of dictionaries")
                    }
                } catch let error as NSError {
                    errors.append(error.localizedDescription)
                }
            }
            callback(items, errors)
        }
    }
    
    func Get<TItem>(id: Int, callback: (TItem?, String?) -> ()) where TItem: Parsable {
        let resourceString = TItem.resourceString;
        dataSource.GetData(resourceString: resourceString, id: id) { (dataResult: DataResult) in
            var errorString: String?
            switch dataResult {
            case .Error(let error): errorString = error
            case .Data(let data):
                do {
                    let object = try JSONSerialization.jsonObject(with: data, options: [])
                    if let itemDictionary = object as? [String: Any] {
                        if let item = TItem(JSONDictionary: itemDictionary) {
                            callback(item, nil)
                        } else {
                            errorString = "JSON \(itemDictionary) can not be converted to \(TItem.resourceString) class"
                        }
                    } else {
                        errorString = "JSON is not a dictionary"
                    }
                } catch let error as NSError {
                    errorString = error.localizedDescription
                }
            }
            callback(nil, errorString)
        }
    }
    
}
