
import UIKit


class TaskDetailView: UIView {
    
    weak var delegate: TaskDetailViewDelegate?
    let settingsView = TaskSettings()
    var item = TodoItem(text: "", importance: .important, isDone: false, creationDate: .now)
    let taskTextView = TaskTextView()
    var taskText: String = ""
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.backSecondary
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.isEnabled = true
        button.setTitleColor(Colors.labelTertiary, for: .disabled)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func deleteButtonPressed() {
        
    }
    
    init() {
        super.init(frame: .zero)
        setupObservers()
        setupView()
        setupTapGesture()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshView() {
        if !item.text.isEmpty {
            taskTextView.text = item.text
            taskTextView.textColor = Colors.labelPrimary
            
            switch item.importance {
            case .important:
                settingsView.importancePicker.selectedSegmentIndex = 2
            case .notImportant:
                settingsView.importancePicker.selectedSegmentIndex = 0
            default:
                settingsView.importancePicker.selectedSegmentIndex = 1
            }
            
            if let deadline = item.deadline {
                settingsView.deadlineSwitch.isOn = true
                settingsView.deadlineDateButton.setTitle(formatDayMonthYear(for: deadline), for: .normal)
                settingsView.deadlineDateButton.isHidden = false
                deleteButton.isEnabled = true
            }
        }
    }
    
    private func setupView() {
        backgroundColor = Colors.backPrimary
        taskTextView.taskDelegate = self
        settingsView.delegate = self
        translatesAutoresizingMaskIntoConstraints = false
        
        setupScrollView()
        setupStackView()
        setupTaskDescriptionTextView()
        setupParametersView()
        setupDeleteButton()
    }
    private func setupScrollView() {
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 16),
        ])
    }
    private func setupStackView() {
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            scrollView.contentLayoutGuide.heightAnchor.constraint(equalTo: stackView.heightAnchor, constant: 138.5
                                                                 ),
        ])
    }
    
    private func setupTaskDescriptionTextView() {
        stackView.addArrangedSubview(taskTextView)
        NSLayoutConstraint.activate([
            taskTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
        ])
    }
    
    private func setupParametersView() {
        stackView.addArrangedSubview(settingsView)
        NSLayoutConstraint.activate([
            settingsView.heightAnchor.constraint(greaterThanOrEqualToConstant: 112.5),
            settingsView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    private func setupDeleteButton() {
        addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: settingsView.bottomAnchor, constant: 16),
            deleteButton.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
}
  // MARK: Keyboard
  extension TaskDetailView {
    private func setupObservers() {
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(keyboardWillShow),
        name: UIResponder.keyboardWillShowNotification,
        object: nil
      )
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(keyboardWillHide),
        name: UIResponder.keyboardWillHideNotification,
        object: nil
      )
    }
    @objc private func keyboardWillShow(notification: NSNotification) {
      if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset.bottom = keyboardHeight
      }
    }
    @objc private func keyboardWillHide(_: NSNotification) {
      scrollView.contentInset.bottom = 0.0
    }
    private func setupTapGesture() {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
      tapGesture.cancelsTouchesInView = false
      addGestureRecognizer(tapGesture)
    }
    @objc private func handleTap() {
      endEditing(true)
    }
  }
  extension TaskDetailView: TaskTextViewDelegate {
      func fetchTaskDescription(_ textView: UITextView) {
          delegate?.fetchTaskText(textView)
      }
    func textViewDidChangeText(_ textView: UITextView) {
      taskText = textView.text
      delegate?.fetchTaskText(textView)
      delegate?.toggleSaveButton(textView)
    }
  }
extension TaskDetailView: TaskSettingsDelegate {
    func dateSelection(_ date: DateComponents?) {
        delegate?.dateSelection(date)
    }
    @objc func switchTapped(_ sender: UISwitch) {
        delegate?.switchTapped(sender)
    }
    @objc func segmentControlTapped(_ sender: UISegmentedControl) {
        delegate?.segmentControlTapped(sender)
    }
}
