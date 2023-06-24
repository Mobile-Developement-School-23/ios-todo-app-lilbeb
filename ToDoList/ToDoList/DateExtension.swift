//
//  DateExtension.swift
//  ToDoList
//
//  Created by Элина Борисова on 23.06.2023.
//

import Foundation



public extension Date {
    var tomorrow: Date {
        let today = Date()
        let calendar = Calendar.current
        let nextDay = calendar.date(byAdding: .day, value: 1 , to: today)
        return today
    }
}
