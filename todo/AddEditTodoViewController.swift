//
//  AddEditTodoViewController.swift
//  todo
//
//  Created by Ashutosh Singh on 24/05/25.
//
import UIKit

protocol AddEditTodoViewControllerDelegate: AnyObject {
    func didAddTodo(title: String, colorHex: String)
    func didUpdateTodo(id: UUID, title: String, colorHex: String)
}

class AddEditTodoViewController: UIViewController {
    
    private let titleField = UITextField()
    private let colorStackView = UIStackView()
    private let saveButton = UIButton()
    private let updateButton = UIButton()
    private var selectedColor: UIColor = .systemBlue
    private let availableColors: [UIColor] = [.systemRed, .systemGreen, .systemBrown]
    
    weak var delegate: AddEditTodoViewControllerDelegate?
    var currentTodo: TodoItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        if let todo = currentTodo {
            titleField.text = todo.title
            selectedColor = UIColor(hex: todo.colorHex) ?? .systemBlue
        }
    }
    
    private func setupUI() {
        titleField.translatesAutoresizingMaskIntoConstraints = false
        colorStackView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        
        titleField.placeholder = "Enter Title"
        titleField.borderStyle = .roundedRect
        
        colorStackView.axis = .horizontal
        colorStackView.distribution = .fillEqually
        colorStackView.spacing = 12
        
        for color in availableColors {
            let button = UIButton()
            button.backgroundColor = color
            button.layer.cornerRadius = 16
            if color.toHexString() == selectedColor.toHexString() {
                button.layer.borderWidth = 2
                button.layer.borderColor = UIColor.label.cgColor
            }
            button.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
            colorStackView.addArrangedSubview(button)
        }
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 12
        
        updateButton.setTitle("Update", for: .normal)
        updateButton.backgroundColor = .systemBlue
        updateButton.setTitleColor(.white, for: .normal)
        updateButton.layer.cornerRadius = 12
        
        view.addSubview(titleField)
        view.addSubview(colorStackView)
        view.addSubview(saveButton)
        view.addSubview(updateButton)
        
        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            colorStackView.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 20),
            colorStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            colorStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            saveButton.topAnchor.constraint(equalTo: colorStackView.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 100),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            
            updateButton.topAnchor.constraint(equalTo: colorStackView.bottomAnchor, constant: 20),
            updateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            updateButton.widthAnchor.constraint(equalToConstant: 100),
            updateButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        
        if let _ = currentTodo {
            updateButton.isHidden = false
            saveButton.isHidden = true
        } else {
            saveButton.isHidden = false
            updateButton.isHidden = true
        }
    }
    
    @objc private func colorSelected(_ sender: UIButton) {
        selectedColor = sender.backgroundColor ?? .systemBlue
    }
    
    @objc private func saveButtonTapped() {
        guard let title = titleField.text, !title.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Please enter Title", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let colorHex = selectedColor.toHexString()
        delegate?.didAddTodo(title: title, colorHex: colorHex)
        dismiss(animated: true)
    }
    
    @objc private func updateButtonTapped() {
        guard let title = titleField.text, !title.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Please enter Title", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let colorHex = selectedColor.toHexString()
        if let todo = currentTodo {
            delegate?.didUpdateTodo(id: todo.id ,title: title, colorHex: colorHex)
            dismiss(animated: true)
        }
    }
}

extension UIColor {
    func toHexString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgb: Int = (Int)(red*255)<<16 | (Int)(green*255)<<8 | (Int)(blue*255)<<0
        return String(format:"#%06x", rgb)
    }
}

