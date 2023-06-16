//
//  TodoItem.swift
//  ToDoList
//
//

import Foundation


struct TodoItem {
    
    enum Importance: String {
        case notImportant = "неважная"
        case usual = "обычная"
        case important = "важная"
    }
   
    var taskId: String
    var text: String
    var importance: Importance
    var deadline: Date?
    var isDone: Bool
    var creationDate: Date
    var modificationDate: Date?
    
    
    init(taskId: String = UUID().uuidString, text: String, importance: Importance, deadline: Date? = nil, isDone: Bool = false, creationDate: Date = Date(), modificationDate: Date? = nil) {
        self.taskId = taskId
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.creationDate = creationDate
        self.modificationDate = modificationDate
    }

}


extension TodoItem{
    static func parse(json: Any) -> TodoItem? {
        let data = Data(TodoItem.utf8)
        do {
            guard let dictionary = try! JSONSerialization.jsonObject(with: Data((data as! String).utf8)) as? [String: Any] else
            {return nil}
            print(dictionary)
            
            guard let textId = dictionary["textId"] as? String,
                  let text = dictionary["text"] as? String,
                  let importance = dictionary["importance"] as? String,
                  let isDone = dictionary["isDone"] as? Bool,
                  let creationDate = (dictionary["creationDate"] as? Int)?.Date else {
                return nil
            }
          var importance = Importance.usual
          if let dictImportance = dictionary["importance"] as? String,
             let dictImportance = Importance(rawValue: dictImportance) else{
              return nil
          }
            let deadline = (dictionary["deadline"]as? Int)?.date
            let modificationDate = (dictionary["modificationDate"]as? Int)?.date
            
            return TodoItem(
                taskId: taskId,
                text: text,
                importance: deadline,
                isDone: isDone,
                creationDate: creationDate,
                deadline: deadline,
                modificationDate: modificationDate
    }
                var json: Any {
                    var dictionary: [String: Any] = [
                        "taskId" = taskId
                        "text" = text
                        "importance" = deadline
                        "isDone" = isDone
                        "creationDate" = creationDate
                        "deadline" = deadline
                        "modificationDate" = modificationDate
                        
                    ]
                    
                    if let deadline = self.deadline {
                        dictionary["deadline"] = deadline.stringRepresentation
                    }
                    
                    return dictionary
                }
                }
                }


                
class FileCache {
     var todoItems: [TodoItem]
     let fileName: String
     let fileManager = FileManager.default
    
    init(fileName: String) {
        self.fileName = fileName
        self.todoItems = []
        loadFromFile()
    }
    
    var allTodoItems: [TodoItem] {
        return todoItems
    }
    
    func addTask(_ item: TodoItem) {
        if let index = todoItems.firstIndex(where: ) {
            todoItems[index] = item
        } else {
            todoItems.append(item)
        }
        saveToFile()
    }
    
    func removeTodoItem(with id: String) {
        todoItems.removeAll(where:)
        saveToFile()
    }
    
    private func getPath() -> URL? {
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let folderURL = documentDirectory.appendingPathComponent("TodoItems", isDirectory: true)
        
        if !fileManager.fileExists(atPath: folderURL.path) {
            do {
                try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating folder for TodoItems: \(error.localizedDescription)")
                return nil
            }
        }
        
        return folderURL.appendingPathComponent(fileName)
    }
    
    private func saveToFile() {
        guard let path = getPath() else { return }
        do {
            let jsonData = try JSONEncoder().encode(todoItems)
            try jsonData.write(to: path)
        } catch {
            print("Error writing to file: \(error.localizedDescription)")
        }
    }
    
    private func loadFromFile() {
        guard let path = getPath(),
              let jsonData = try? Data(contentsOf: path) else { return }
        do {
            todoItems = try JSONDecoder().decode([TodoItem].self, from: jsonData)
        }
    }
}
