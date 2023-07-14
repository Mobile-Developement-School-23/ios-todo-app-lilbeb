

import UIKit


class TaskSettings: UIStackView {
    
    weak var delegate: TaskSettingsDelegate?
    
    private let importanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Важность"
        label.font = UIFont.body
        label.textColor = Colors.labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var importancePicker: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [UIImage(named: "arrowDown")?.withRenderingMode(.alwaysOriginal),
                                                          "нет",
                                                          UIImage(named: "exclamationMark")?.withRenderingMode(.alwaysOriginal)])
        segmentedControl.selectedSegmentIndex = 2
        segmentedControl.backgroundColor = Colors.supportOverlay
        segmentedControl.selectedSegmentTintColor = Colors.backElevated
        segmentedControl.addTarget(self, action: #selector(segmentControlTapped), for: .valueChanged)
        segmentedControl.setTitleTextAttributes([.foregroundColor: Colors.labelPrimary,
                                                 .font: UIFont.subhead], for: .normal)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Сделать до"
        label.font = UIFont.body
        label.textColor = Colors.labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let searatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        view.widthAnchor.constraint(equalToConstant: 311).isActive = true
        view.backgroundColor = Colors.supportSeparator
        return view
    }()
    
    private let secondSepView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
        view.widthAnchor.constraint(equalToConstant: 311).isActive = true
        view.isHidden = false
        view.backgroundColor = Colors.backSecondary
        return view
    }()
    
    private let deadlineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var deadlineSwitch: UISwitch = {
        let deadlineSwitch = UISwitch()
        deadlineSwitch.addTarget(self, action: #selector(switchTapped), for: .valueChanged)
        deadlineSwitch.translatesAutoresizingMaskIntoConstraints = false
        return deadlineSwitch
    }()
    
    lazy var deadlineDateButton: UIButton = {
        let button = UIButton()
        button.setTitle("2 июня 2021", for: .normal)
        button.setTitleColor(Colors.colorBlue, for: .normal)
        button.titleLabel?.font = UIFont.footnote
        button.addTarget(self, action: #selector(deadlineDateTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private lazy var calendarView: UICalendarView = {
        let calendarView = UICalendarView()
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.availableDateRange = DateInterval(start: .now, end: .distantFuture)
        calendarView.isHidden = true
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        return calendarView
    }()
    private let firstCell: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let secondCell: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupFirstCell()
        setupDividerView()
        setupSecondCell()
        setupHiddenDividerView()
        setupCalendarView()
    }
    
    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        axis = .vertical
        alignment = .center
        layer.cornerRadius = 16
        backgroundColor = Colors.backSecondary
        spacing = 1
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupFirstCell() {
        addArrangedSubview(firstCell)
        firstCell.heightAnchor.constraint(equalToConstant: 56).isActive = true
        setupImportanceLabel()
        setupImportancePicker()
    }
    
    private func setupImportanceLabel() {
        addSubview(importanceLabel)
        NSLayoutConstraint.activate([
            importanceLabel.heightAnchor.constraint(equalToConstant: 36),
            importanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            importanceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
        ])
    }
    
    private func setupImportancePicker() {
        addSubview(importancePicker)
        NSLayoutConstraint.activate([
            importancePicker.widthAnchor.constraint(equalToConstant: 150),
            importancePicker.heightAnchor.constraint(equalToConstant: 36),
            importancePicker.topAnchor.constraint(equalTo: topAnchor, constant: 17),
            importancePicker.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -12
            ),
        ])
    }
    
    private func setupDividerView() {
        addArrangedSubview(searatorView)
    }
    
    private func setupSecondCell() {
        addArrangedSubview(secondCell)
        secondCell.heightAnchor.constraint(equalToConstant: 56).isActive = true
        setupDeadlineStackView()
        setupDeadlineSwitch()
    }
    
    private func setupDeadlineStackView() {
        addSubview(deadlineStackView)
        NSLayoutConstraint.activate([
            deadlineStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            deadlineStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            deadlineStackView.topAnchor.constraint(equalTo: searatorView.bottomAnchor, constant: 9),
            deadlineStackView.heightAnchor.constraint(equalToConstant: 40),
        ])
        setupDoneByLabel()
        setupDeadlineDateLabel()
    }
    
    private func setupDoneByLabel() {
        deadlineStackView.addArrangedSubview(deadlineLabel)
    }
    
    private func setupDeadlineDateLabel() {
        deadlineStackView.addArrangedSubview(deadlineDateButton)
        NSLayoutConstraint.activate([
            deadlineDateButton.bottomAnchor.constraint(equalTo: deadlineStackView.bottomAnchor),
        ])
    }
    
    private func setupDeadlineSwitch() {
        addSubview(deadlineSwitch)
        NSLayoutConstraint.activate([
            deadlineSwitch.widthAnchor.constraint(equalToConstant: 51),
            deadlineSwitch.heightAnchor.constraint(equalToConstant: 31),
            deadlineSwitch.topAnchor.constraint(equalTo: searatorView.bottomAnchor, constant: 13.5),
            deadlineSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])
    }
    
    private func setupHiddenDividerView() {
        addArrangedSubview(secondSepView)
    }
    
    private func setupCalendarView() {
        addArrangedSubview(calendarView)
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
        NSLayoutConstraint.activate([
            calendarView.widthAnchor.constraint(equalToConstant: 311),
        ])
    }
    
    @objc private func switchTapped(_ sender: UISwitch) {
        UIView.animate(withDuration: 0.3) {
            if sender.isOn {
                self.deadlineDateButton.setTitle(formatDayMonthYear(for: .now + 60 * 60 * 24), for: .normal)
                self.deadlineDateButton.isHidden = false
            } else {
                self.deadlineDateButton.isHidden = true
                self.secondSepView.backgroundColor = Colors.backSecondary
                self.calendarView.isHidden = true
            }
        }
        delegate?.switchTapped(sender)
    }
    
    @objc private func segmentControlTapped(_ sender: UISegmentedControl) {
        delegate?.segmentControlTapped(sender)
    }
    
    @objc private func deadlineDateTapped() {
        UIView.animate(withDuration: 0.3) {
            self.secondSepView.isHidden = false
            self.secondSepView.backgroundColor = Colors.supportSeparator
            while self.calendarView.isHidden == true {
                self.calendarView.isHidden = false
            }
        }
    }
}

extension TaskSettings: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_: UICalendarSelectionSingleDate, didSelectDate date: DateComponents?) {
        guard let date = date else { return }
        delegate?.dateSelection(date)
        deadlineDateButton.setTitle(formatDayMonth(for: date.date), for: .normal)
        UIView.animate(withDuration: 0.3) {
            self.secondSepView.backgroundColor = Colors.backSecondary
            self.calendarView.isHidden = true
        }
    }
}
