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
   
    let taskId: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isDone: Bool
    let creationDate: Date
    let modificationDate: Date?
    
    
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


extension TodoItem {
    
    static func parse(json: Any) -> TodoItem? {
        do {
            guard let dict = json as? [String: Any ] else { return nil }
            
            guard
                  let taskId = dict["textId"] as? String,
                  let text = dict["text"] as? String,
                  let creationDate = (dict["creationDate"] as? Int).flatMap ({ Date(timeIntervalSince1970: TimeInterval($0)) }) else {
                return nil
            }
            let importance = (dict["importance"] as? String).flatMap(Importance.init(rawValue:)) ?? .usual
            let deadline = (dict["deadline"] as? Int).flatMap { Date(timeIntervalSince1970: TimeInterval($0)) }
            let isDone = (dict["isDone"] as? Bool) ?? false
            let modificationDate = (dict["modificationDate"] as? Int).flatMap { Date(timeIntervalSince1970: TimeInterval($0)) }
            
            return TodoItem(
                taskId: taskId,
                text: text,
                importance: importance,
                deadline: deadline,
                isDone: isDone,
                creationDate: creationDate,
                modificationDate: modificationDate
            )
        }
    }
    var json: Any {
        var dict: [String: Any] = [
            "text": text,
            "isDone": isDone,
            "importance": importance.rawValue,
            "deadline": deadline,
            "isDone": isDone,
            "creationDate": creationDate,
            "modificationDate": modificationDate
        ]
        return dict
    }
}

class FileCache {
    
    private(set) var toDoItems: [String: TodoItem] = [:]
    
    func addNewTask(_ item: TodoItem) -> TodoItem? {
        let previousItem = toDoItems[item.taskId]
        toDoItems[item.taskId] = item
        return previousItem
    }
    
    func deleteTask(_ taskId: String) -> TodoItem? {
        let item = toDoItems[taskId]
        toDoItems[taskId] = nil
        return item
    }
    func save(to file: String) -> TodoItem? {
        
    }
}
