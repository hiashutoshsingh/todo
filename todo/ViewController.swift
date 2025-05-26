//
//  ViewController.swift
//  todo
//
//  Created by Ashutosh Singh on 24/05/25.
//

import UIKit

class ViewController: UIViewController {
    
    private let tableView = UITableView()
    private let addButton = UIButton()
    private let viewModel = TodoViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
        setupAddButton()
        viewModel.onTodosUpdated = { [weak self] in
            print("onTodosUpdated called")
            self?.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TodoCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupAddButton() {
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 56),
            addButton.heightAnchor.constraint(equalToConstant: 56),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -56),
        ])
        
        addButton.setTitle("Add +", for: .normal)
        addButton.backgroundColor =  .systemBlue
        addButton.layer.cornerRadius = 28
        addButton.clipsToBounds = true
        addButton.tintColor = .white
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc private func addButtonTapped() {
        let addEditViewController = AddEditTodoViewController()
        addEditViewController.delegate = self
        addEditViewController.view.backgroundColor = .systemBackground
        addEditViewController.modalPresentationStyle = .formSheet
        present(addEditViewController, animated: true, completion: nil)
    }
    
}

extension ViewController: AddEditTodoViewControllerDelegate {
    func didUpdateTodo(id: UUID, title: String, colorHex: String) {
        viewModel.updateTodo(id: id, newTitle: title, newColorHex: colorHex)
    }
    
    func didAddTodo(title: String, colorHex: String) {
        viewModel.addTodo(title: title, colorHex: colorHex)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        if let todo = viewModel.getTodo(at: indexPath.row) {
            print("Displaying: \(todo.title)")
            cell.textLabel?.text = todo.title
            cell.backgroundColor = UIColor(hex: todo.colorHex)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let todo = viewModel.getTodo(at: indexPath.row) else { return }
        modifyTodo(todo)
    }
    
    private func modifyTodo(_ todo: TodoItem) {
        let addEditViewController = AddEditTodoViewController()
        addEditViewController.delegate = self
        addEditViewController.currentTodo = todo
        addEditViewController.view.backgroundColor = .systemBackground
        addEditViewController.modalPresentationStyle = .formSheet
        present(addEditViewController, animated: true, completion: nil)
    }
}

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        guard hexSanitized.count == 6,
              let rgbValue = UInt64(hexSanitized, radix: 16) else {
            return nil
        }
        let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgbValue & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

