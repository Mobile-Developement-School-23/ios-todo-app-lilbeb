

import UIKit


class TableViewCell: UITableViewCell {
    
    static let identifier = "TableViewCell"
    lazy var attributedString: NSMutableAttributedString = .init(string: titleLabel.text ?? "")
    weak var delegate: TableViewCellDelegate?


    private let taskStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 2
        stackView.distribution = .equalSpacing
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let deadlneStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 2
        stackView.distribution = .equalSpacing
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.subhead
        label.textColor = Colors.labelTertiary
        return label
    }()
    
    private var calendarImage: UIImageView = {
      let imageView = UIImageView()
      imageView.image = UIImage(systemName: "calendar")
        
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.body
        label.textColor = Colors.labelPrimary
        label.numberOfLines = 3
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevron: UIImageView = {
      let imageView = UIImageView()
      imageView.image = UIImage(named: "chevron")
        
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
    }()
    
    private let status: UIImageView = {
      let imageView = UIImageView()
      imageView.image = UIImage(named: "greyCircle")
        
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
    }()

    private let statusIcon: UIImageView = {
      let imageView = UIImageView()
      imageView.sizeToFit()
      imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
      imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
      imageView.contentMode = .left
        
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
    }()
    private lazy var statusButton: UIButton = {
      let button = UIButton()
      button.setImage(UIImage(named: "greyCircle"), for: .normal)
      button.addTarget(self, action: #selector(statusButtonTapped), for: .touchUpInside)
      button.frame.size = CGSize(width: 24, height: 24)
        
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Colors.backSecondary
        separatorInset = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 0)
        
      setupUI()
    }
    
    private func setupUI() {
      contentView.addSubview(chevron)
        contentView.addSubview(statusButton)
        contentView.addSubview(taskStack)

      NSLayoutConstraint.activate([
        chevron.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        chevron.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

        statusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        statusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

        taskStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
        taskStack.leadingAnchor.constraint(equalTo: statusButton.trailingAnchor, constant: 12),
        taskStack.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -16),
        taskStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        taskStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 24),
      ])
      taskStack.addArrangedSubview(titleStack)
    }
    
    func configure(with task: TodoItem) {
      titleLabel.text = task.text

      switch task.importance {
      case .important:
          statusButton.setImage(UIImage(named: "redCircle"), for: .normal)
        statusIcon.image = UIImage(named: "exclamationMark")
        titleStack.addArrangedSubview(statusIcon)
        titleStack.addArrangedSubview(titleLabel)
      case .notImportant:
        statusIcon.image = UIImage(named: "arrowDown")
        titleStack.addArrangedSubview(statusIcon)
        titleStack.addArrangedSubview(titleLabel)
      default:
        titleStack.addArrangedSubview(titleLabel)
      }

      if let deadline = task.deadline {
        taskStack.addArrangedSubview(deadlneStack)
        calendarImage.image = UIImage(systemName: "calendar")
        deadlneStack.addArrangedSubview(calendarImage)
        deadlineLabel.text = formatDayMonthYear(for: deadline)
        deadlneStack.addArrangedSubview(deadlineLabel)
      }

      if task.isDone {
        statusButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        let attributeString = NSMutableAttributedString(string: task.text)
        attributeString.addAttribute(
          NSAttributedString.Key.strikethroughStyle,
          value: 1,
          range: NSMakeRange(0, attributeString.length)
        )
          titleLabel.textColor = Colors.labelTertiary
        titleLabel.attributedText = attributedString
        titleStack.addArrangedSubview(titleLabel)
      }
    }

    @objc private func statusButtonTapped() {
      delegate?.TableViewCellButton(self)
    }

      required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
