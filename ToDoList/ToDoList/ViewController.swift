//
//  ViewController.swift
//  ToDoList
//
//  Created by Элина Борисова on 15.06.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var item = TodoItem(taskId: "1", text: "2", importance: .usual)
        var item2 = TodoItem(text: "2", importance: .usual)

        var item3 = TodoItem(text: "2", importance: .usual)

        var item4 = TodoItem(text: "2", importance: .usual)

        var item5 = TodoItem(text: "2", importance: .usual)

                var item1 = TodoItem(taskId: "1",text: "3", importance: .usual)
                print(item.json)
                print(TodoItem.parse(json: item.json))
                var cache = FileCache()
        
                cache.addTodoItem(item)
                cache.addTodoItem(item1)
        cache.addTodoItem(item2)
        cache.addTodoItem(item3)
        cache.addTodoItem(item4)
        cache.addTodoItem(item5)

                print(cache.todoItems[0].text)
        cache.save(to: "biba")
                var cache2 = FileCache()
        print(cache2.todoItems)
        cache2.load(to: "biba")
        print(cache2.todoItems)
        // Do any additional setup after loading the view.
    }


}

