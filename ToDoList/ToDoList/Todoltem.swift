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
            "taskId": taskId,
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
    
    private var todoItems = [TodoItem]()
    private let fileManager = FileManager.default
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private var fileName: String = ""

    var allTodoItems: [TodoItem] {
        return todoItems
    }
    func addTodoItem(_ item: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.taskId == item.taskId }) {
            todoItems[index] = item
        } else {
            todoItems.append(item)
        }
        save()
    }
    
    func removeTodoItem(id: String) {
        if let index = todoItems.firstIndex(where: { $0.taskId == id }) {
            todoItems.remove(at: index)
            save()
        }
    }
    private func save() {
        do {
            let json = todoItems.map {$0.json}
            let data = try JSONSerialization.data(withJSONObject: json)
            let url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = url.appendingPathComponent(fileName)
            try data.write(to: fileURL)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    private func load() {
        do {
            let url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = url.appendingPathComponent(fileName)
            let data = try Data(contentsOf: fileURL)
            let items = try JSONSerialization.data(withJSONObject: data)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
