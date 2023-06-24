//
//  ViewController.swift
//  ToDoList
//
//  Created by Элина Борисова on 23.06.2023.
//

import UIKit

class ToDoViewController: UIViewController {
    
    private var fileCache = FileCache()
    private var toDoItems = TodoItem(text: "", importance: .usual, isDone: false, creationDate: .now)
    private let textView = textViewFunc()
    private let scrollView = scrollViewFunc()
    private let stackView = stackViewFunc()
    private let deadlineLabel = deadlineLabelFunc()
    private let importanceLable = importanceLableFunc()
    private let importanceControl = importanceControlFunc()
    private let importanceStackView = importanceStackViewFunc()
    private let dateLabel = dateLabelFunc()
    private let deadlineSwitch = deadlineSwitchFunc()
    private let deadlineStack = deadlineStackFunc()
    private let deadlinePicker = deadlinePickerFunc()
    private let deleteButton = deleteButtonFunc()
    private let allStackView = allStackViewFunc()
    private let firstSeparator = firstSeparatorFunc()
    private let secondSeparator = secondSeparatorFunc()
    private let saveButton = UIBarButtonItem(title: "Сохранить", style: .plain , target: nil, action: nil)
    private let cancelButton = UIBarButtonItem(title: "Отменить", style: .plain, target: nil, action: nil)
    private var veiwBottomConstraint: NSLayoutConstraint?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Дело"
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)
        
        navigationBarFunc()
        subviewFunc()
    }
    
   
    private func navigationBarFunc() {
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    
    private func subviewFunc() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(allStackView)

        stackView.addArrangedSubview(deleteButton)
        importanceStackView.addArrangedSubview(importanceLable)
        importanceStackView.addArrangedSubview(importanceControl)
        deadlineStack.addArrangedSubview(deadlineLabel)
        deadlineStack.addArrangedSubview(dateLabel)
        deadlineStack.addArrangedSubview(deadlineSwitch)
        
        allStackView.addArrangedSubview(importanceControl)
        allStackView.addArrangedSubview(secondSeparator)
        allStackView.addArrangedSubview(deadlineStack)
        allStackView.addArrangedSubview(firstSeparator)
        allStackView.addArrangedSubview(deadlinePicker)
        
        let bottomConstraint = scrollView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: 16
        )
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bottomConstraint
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            allStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            allStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            deleteButton.heightAnchor.constraint(equalToConstant: 56),
            
            importanceControl.widthAnchor.constraint(equalToConstant: 150),
            importanceControl.heightAnchor.constraint(equalToConstant: 36),
            
            deadlinePicker.widthAnchor.constraint(equalTo: allStackView.widthAnchor)
        ])
        
        self.veiwBottomConstraint = bottomConstraint
        
        updateSwitch()
    }
    @objc private func updateSwitch() {
        if deadlineSwitch.isOn == true {
            UIView.animate(withDuration: 0.5) {
                self.dateLabel.isHidden = !self.deadlineSwitch.isOn
                self.toDoItems.deadline = Date(timeIntervalSinceNow: 60*60*24)
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.dateLabel.isHidden = !self.deadlineSwitch.isOn
                self.deadlinePicker.isHidden = !self.deadlineSwitch.isOn
                self.toDoItems.deadline = nil
            }
        }
    }
}

private extension ToDoViewController {
    
    func setUpView() {
        view.backgroundColor = UIColor(named: "Back")
        
    }
    
    static func textViewFunc() -> UITextView {
        let text = UITextView()
        text.text = "Что надо сделать?"
        text.layer.cornerRadius = 16
        text.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        text.font = .systemFont(ofSize: 17)
        text.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        text.textContainerInset = UIEdgeInsets(top: 17, left: 16, bottom: 17, right: 16)
        text.isEditable = true
        text.isScrollEnabled = false
        text.textAlignment = .left
        
        return text
    }
    
    static func scrollViewFunc() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }
    
    static func stackViewFunc() -> UIStackView {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }
    
    static func importanceStackViewFunc() -> UIStackView {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 16, right: 12)
        stackView.isLayoutMarginsRelativeArrangement = true

        
        return stackView
    }
    static func deadlineLabelFunc() -> UILabel {
       let deadline = UILabel()
        deadline.font = .systemFont(ofSize: 17)
        deadline.text = "Сделать до"
        
        return deadline
    }
    
    static func importanceLableFunc() -> UILabel {
        let lable = UILabel()
        lable.font = .systemFont(ofSize: 17)
        lable.text = "Важность"
        
        return lable
    }
    
    static func importanceControlFunc() -> UISegmentedControl {
        let importanceControl = UISegmentedControl(items: ["", "нет", ""])
        importanceControl.setImage(UIImage(named: "low"), forSegmentAt: 0)
        importanceControl.setImage(UIImage(named: "high"), forSegmentAt: 2)

        importanceControl.selectedSegmentIndex = 1

        
        return importanceControl
    }
    
    static func dateLabelFunc() -> UILabel {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = .blue
        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.text = "\(Date().formatted(.dateTime.day().month().year(.defaultDigits)))"
        return dateLabel
    }
    
    static func deadlineSwitchFunc() -> UISwitch {
        let deadlineSwitch = UISwitch()
        deadlineSwitch.isEnabled = false
        deadlineSwitch.setOn(false, animated: true)
        deadlineSwitch.addTarget(self, action: #selector(updateSwitch), for: .valueChanged)
        
        return deadlineSwitch
    }
    
    
    static func deadlineStackFunc() -> UIStackView {
        let deadlineStack = UIStackView()
        deadlineStack.distribution = .fill
        deadlineStack.axis = .horizontal
        deadlineStack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 12)
        deadlineStack.isLayoutMarginsRelativeArrangement = true

        return deadlineStack
    }
    
    static func deadlinePickerFunc() -> UIDatePicker {
        let picker = UIDatePicker()
        
        return picker
    }
    
    static func deleteButtonFunc() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(named: "BackSecondary")
        button.isEnabled = false

        return button
    }
    
    static func allStackViewFunc() -> UIStackView {
        let stack = UIStackView()
        stack.spacing = 0
        stack.distribution = .fill
        stack.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        stack.axis = .vertical
        stack.layer.cornerRadius = 16
        
        return stack
    }
    
    static func firstSeparatorFunc() -> UIView {
        let sep = UIView()
        sep.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
        sep.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        return sep
    }
    static func secondSeparatorFunc() -> UIView {
        let sep = UIView()
        sep.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
        sep.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        return sep
    }
    
}
