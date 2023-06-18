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
            
            guard let taskId = dict["textId"] as? String,
                  let text = dict["text"] as? String,
                  let isDone = dict["isDone"] as? Bool,
                  let creationDate = dict["creationDate"] as? Date else {
                return nil
            }
            var importance = Importance.usual
            if let dictImportance = dict["importance"] as? String,
               let dictImportance = Importance(rawValue: dictImportance) {
                importance = dictImportance
            }
            let deadline = dict["deadline"]as? Date
            let modificationDate = dict["modificationDate"]as? Date
            
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
        var dictionary: [String: Any] = [
            "text": text,
            "isDone": isDone,
            "importance": importance.rawValue
        ]
        return dictionary
    }
}

