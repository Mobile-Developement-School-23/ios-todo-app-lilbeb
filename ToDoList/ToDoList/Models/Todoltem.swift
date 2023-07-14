//
//  TodoItem.swift
//  ToDoList
//
//

import Foundation


enum Importance: String {
    case notImportant = "неважная"
    case usual = "обычная"
    case important = "важная"
}

struct TodoItem {
    
    let taskId: String
    var text: String
    var importance: Importance
    var deadline: Date?
    var isDone: Bool
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
                let taskId = dict["taskId"] as? String,
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
        var res: [String: Any] = [:]
        res["taskId"] = taskId
        res["text"] = text
        if importance != .usual {
            res["importance"] = importance.rawValue
        }
        if let deadline = deadline {
            res["deadline"] = Int(deadline.timeIntervalSince1970)
        }
        res["isDone"] = isDone
        res["creationDate"] = Int(creationDate.timeIntervalSince1970)
        if let modificationDate = modificationDate {
            res["modificationDate"] = Int(modificationDate.timeIntervalSince1970)
        }
        return res
    }
}
