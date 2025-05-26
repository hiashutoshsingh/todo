//
//  TodoItem.swift
//  todo
//
//  Created by Ashutosh Singh on 24/05/25.
//
import Foundation

struct TodoItem: Equatable {
    var id: UUID
    var title: String
    var colorHex: String
    var isCompleted: Bool
    let timeStamp: Date
    
    init(id: UUID = UUID(), title: String, colorHex: String, isCompleted: Bool = false, timeStamp: Date = Date()) {
        self.id = id
        self.title = title
        self.colorHex = colorHex
        self.isCompleted = isCompleted
        self.timeStamp = timeStamp
    }
}
