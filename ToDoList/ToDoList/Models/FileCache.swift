

import UIKit

private enum FileFormat: String {
    case json = ".json"
    case csv = ".csv"
}

class FileCache {
    
    private(set) var todoItems : [TodoItem] = []
    private let fileManager = FileManager.default
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    
    func addTodoItem(item: TodoItem) {
        todoItems.append(item)
    }
    
    func removeTodoItem(id: String) {
        if let index = todoItems.firstIndex(where: { $0.taskId == id }) {
            todoItems.remove(at: index)
        }
    }
    public func save(to file: String) {
        do {
            let json = todoItems.map {$0.json}
            let data = try JSONSerialization.data(withJSONObject: json)
            let url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            print(url)
            let fileURL = url.appendingPathComponent("\(file).json")
            try data.write(to: fileURL)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    public func load(to file: String) {
        do {
            if let data = try? Data(contentsOf: getUrl(file: file, fileExtension: "json")){
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]{
                    print(json)
                    var toDoItems2: [TodoItem] = []
                    for i in json {
                        if let item = TodoItem.parse(json: i) {
                            toDoItems2.append(item)
                            
                        }
                        
                    }
                    todoItems = toDoItems2
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func loadFromFile(fileName: String) {
        let items = getTextFromFile(fileName: fileName).split(separator: "\n\n")
        for i in 0..<items.count {
            let todoItem = TodoItem.parse(json: items[i])!
            todoItems.append(todoItem)
        }
    }
    func getTextFromFile(fileName: String) -> String {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            do {
                return try String(contentsOf: fileURL, encoding: .utf8)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        return ""
    }
    
    private func getUrl(file: String, fileExtension: String) -> URL {
        var path = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        path = path.appendingPathComponent("\(file).\(fileExtension)")
        return path
    }
}
