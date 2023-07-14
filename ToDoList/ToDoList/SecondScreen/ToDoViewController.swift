

import UIKit

class ToDoViewController: UIViewController {
    
    private var taskText: String = ""
    var itemDetailsView = TaskDetailView()
    var selectedItem: TodoItem?
    var isNewItem: Bool = false
    weak var delegate: ToDoViewControllerDelegate?
    
    lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveTapped))
        button.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.headline], for: .normal)
        button.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: Colors.labelTertiary,
             NSAttributedString.Key.font: UIFont.headline],
            for: .disabled
        )
        button.isEnabled = false
        return button
    }()
    
    lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancelTapped))
        button.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.body], for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupItemDetailsView()
        hideAllExceptTextViewIfNeeded()
    }
    
    override func viewWillTransition(to _: CGSize, with _: UIViewControllerTransitionCoordinator) {
        hideAllExceptTextViewIfNeeded()
    }
    
    func hideAllExceptTextViewIfNeeded() {
        UIView.transition(with: itemDetailsView, duration: 0.2, options: .transitionCrossDissolve, animations: { [self] in
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let interfaceOrientation = windowScene.interfaceOrientation
                if interfaceOrientation.isLandscape {
                    itemDetailsView.settingsView.isHidden = true
                    itemDetailsView.deleteButton.isHidden = true
                } else {
                    itemDetailsView.settingsView.isHidden = false
                    itemDetailsView.deleteButton.isHidden = false
                }
            }
        }, completion: nil)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Дело"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.headline]
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func setupItemDetailsView() {
        view.addSubview(itemDetailsView)
        itemDetailsView.deleteButton.isEnabled = !isNewItem
        itemDetailsView.delegate = self
        itemDetailsView.item = selectedItem ?? TodoItem(text: "", importance: .important, isDone: false, creationDate: .now)
        itemDetailsView.refreshView()
        NSLayoutConstraint.activate([
            itemDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            itemDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            itemDetailsView.topAnchor.constraint(equalTo: view.topAnchor),
            itemDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension ToDoViewController: TaskDetailViewDelegate {
    func fetchTaskText(_ textView: UITextView) {
        taskText = textView.text
    }
    @objc func cancelTapped() {
        dismiss(animated: true)
    }
    @objc func saveTapped() {
        fetchTaskText(itemDetailsView.taskTextView)
        itemDetailsView.item.text = taskText
        delegate?.saveItem(itemDetailsView.item, isNewItem)
        dismiss(animated: true)
    }
    func deleteButtonTapped() {
        delegate?.deleteItem(selectedItem?.taskId ?? "")
        dismiss(animated: true)
        clearView()
    }
    private func clearView() {
        itemDetailsView.taskTextView.text = "Что надо сделать?"
        itemDetailsView.taskTextView.textColor = Colors.labelTertiary
        itemDetailsView.settingsView.importancePicker.selectedSegmentIndex = 2
        itemDetailsView.settingsView.deadlineSwitch.isOn = false
        itemDetailsView.settingsView.deadlineDateButton.isHidden = true
        saveButton.isEnabled = false
    }
    func toggleSaveButton(_ textView: UITextView) {
        if !textView.text.isEmpty {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}

extension ToDoViewController: TaskSettingsDelegate {
    func switchTapped(_ sender: UISwitch) {
        if sender.isOn {
            itemDetailsView.item.deadline = .now + 24 * 60 * 60
        } else {
            itemDetailsView.item.deadline = nil
        }
        saveButton.isEnabled = true
    }
    
    func segmentControlTapped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: itemDetailsView.item.importance = .notImportant
        case 2: itemDetailsView.item.importance = .important
        default: itemDetailsView.item.importance = .usual
        }
        saveButton.isEnabled = true
    }
    
    func dateSelection(_ date: DateComponents?) {
        itemDetailsView.item.deadline = date!.date
        saveButton.isEnabled = true
    }
}
