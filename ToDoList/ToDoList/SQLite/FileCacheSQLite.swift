

import Foundation
import SQLite

class FileCacheSQLite {
    private var db: Connection?
    private let items = Table("TodoItems")
    private let taskId = Expression<String>("taskId")
    private let text = Expression<String>("text")
    private let importance = Expression<String>("importance")
    private let deadline = Expression<Date?>("deadline")
    private let isDone = Expression<Bool>("isDone")
    private let creationDate = Expression<Date>("dateCreated")
    private let modificationDate = Expression<Date?>("dateModified")
    
    func save() {
        guard let db = db else {
            return
        }
        do {
            try db.run(items.create(ifNotExists: true) { table in
                table.column(taskId, primaryKey: true)
                table.column(text)
                table.column(importance)
                table.column(deadline)
                table.column(isDone)
                table.column(creationDate)
                table.column(modificationDate)
            })
        } catch {
            print("Could not save. \(error)")
        }
    }

    
    func load() -> [TodoItem] {
        guard let db = db else { return [] }
        var loadedItems: [TodoItem] = []
        
        do {
            let query = items.select(taskId, text, importance, deadline, isDone, creationDate, modificationDate)
            let rows = try db.prepare(query)
            for row in rows {
                let item = TodoItem(taskId: row[taskId], text: row[text], importance: Importance(rawValue: row[importance]) ?? <#default value#>, deadline: row[deadline], isDone: row[isDone], creationDate: row[creationDate], modificationDate: row[modificationDate])
                loadedItems.append(item)
                
            }
        } catch {
            print("Could not fetch. \(error)")
        }
        return loadedItems
    }

}
