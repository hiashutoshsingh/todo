//
//  TodoViewModel.swift
//  todo
//
//  Created by Ashutosh Singh on 24/05/25.
//
import Foundation

final class TodoViewModel {
    
    private(set) var todos: [TodoItem] = []
    
    var onTodosUpdated: (() -> Void)?
    
    func addTodo(title: String, colorHex: String){
        let newTodo = TodoItem(title: title, colorHex: colorHex)
        todos.append(newTodo)
        onTodosUpdated?()
    }
    
    func updateTodo(id: UUID, newTitle: String, newColorHex: String){
        guard let index = todos.firstIndex(where: { $0.id == id }) else { return }
        todos[index].title = newTitle
        todos[index].colorHex = newColorHex
        onTodosUpdated?()
    }
    
    func deleteTodo(id: UUID){
        guard let index = todos.firstIndex(where: { $0.id == id }) else {return}
        todos.remove(at: index)
        onTodosUpdated?()
    }
    
    func toggleCompleted(id: UUID){
        guard let index = todos.firstIndex(where: { $0.id == id }) else {return}
        todos[index].isCompleted = !todos[index].isCompleted
    }
    
    func getTodo(at index: Int) -> TodoItem? {
        guard index < todos.count else { return nil }
        return todos[index]
    }
    
    var count: Int {
        return todos.count
    }
}

