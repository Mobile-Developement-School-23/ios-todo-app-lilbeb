
import Foundation
 
class FileCache {
    private var todoItems: [TodoItem]
    private let fileName: String
    private let fileManager = FileManager.default
    
    init(fileName: String) {
        self.fileName = fileName
        self.todoItems = []
        loadFromFile()
    }
    
    var allTodoItems: [TodoItem] {
        return todoItems
    }
    
    func addTodoItem(_ item: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.id == item.id }) {
            todoItems[index] = item
        } else {
            todoItems.append(item)
        }
        saveToFile()
    }
    
    func removeTodoItem(with id: String) {
        todoItems.removeAll(where: { $0.id == id })
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
        } catch {
            print("Error decoding JSON data: \(error.localizedDescription)")
        }
    }
}
