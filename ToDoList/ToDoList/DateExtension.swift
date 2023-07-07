//
//  DateExtension.swift
//  ToDoList
//
//  Created by Элина Борисова on 23.06.2023.
//

import UIKit

public func formatDayMonthYear(for date: Date?) -> String {
  guard let date = date else { return "invalid date" }
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "d MMMM yyyy"
  let dateString = dateFormatter.string(from: date)
  return dateString
}

public func formatDayMonth(for date: Date?) -> String {
  guard let date = date else { return "invalid date" }
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "d MMMM"
  let dateString = dateFormatter.string(from: date)
  return dateString
}

