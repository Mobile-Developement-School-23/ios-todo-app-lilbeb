
import UIKit

class ToDoTableViewCell: UITableViewCell {
    let textItem = UILabel()
    let deadlineLabel = UILabel()
    let isDoneButton = UIButton(type: .system)
    let labelsStack = UIStackView()
    var item: TodoItem!

    private var importanceStatus = Importance.usual
    private var isDone = false
    private var text: String?
//    private let deadlineView = DeadlineView()
    
    public var isDoneButtonCompletion: ((Bool) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      
      setupUI()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
      super.prepareForReuse()
      textItem.attributedText = NSAttributedString(string: text ?? "", attributes: [NSAttributedString.Key.strikethroughStyle: 0])
    }
    private func setupUI() {
      setupIsDoneButton()
      setupLabelsStack()
      setupConstraints()
    }
    
    private func setupText() {
      textItem.font = .systemFont(ofSize: 17)
      textItem.numberOfLines = 3
      textItem.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupDeadlineLabel() {
      
      deadlineLabel.font = .systemFont(ofSize: 14)
      
      deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
      deadlineLabel.isHidden = true
    }
    private func setupLabelsStack() {
      setupText()
      setupDeadlineLabel()
      labelsStack.addArrangedSubview(textItem)
      labelsStack.addArrangedSubview(deadlineLabel)
      labelsStack.spacing = 5
      labelsStack.axis = .vertical
      labelsStack.alignment = .leading
      labelsStack.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview(labelsStack)
    }
    private func setupIsDoneButton() {
      isDoneButton.setImage(UIImage(systemName: "circle"), for: .normal)
      isDoneButton.addTarget(self, action: #selector(changeIsDoneState), for: .touchUpInside)
      isDoneButton.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview(isDoneButton)
    }
    
    @objc private func changeIsDoneState() {
      isDone = !isDone
      isDoneButtonCompletion?(isDone)
    }
    
    private lazy var radioButtonView: UIImageView = {
        let radioButtonView = UIImageView()
        var radioButtonViewImage = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))!.withTintColor( #colorLiteral(red: 0.6274510622, green: 0.6274510026, blue: 0.6274510026, alpha: 1), renderingMode: .alwaysOriginal)
        if item.importance == .important {
            print("1")
            radioButtonViewImage = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))!.withTintColor( #colorLiteral(red: 1, green: 0.2332399487, blue: 0.1861645281, alpha: 1), renderingMode: .alwaysOriginal)
        }
        radioButtonView.image = radioButtonViewImage
        return radioButtonView
    }()
    
    
      private func addImageString(text: String, image: UIImage) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: NSTextAlignment.center]
        let attributtedString = NSMutableAttributedString(string: "", attributes: attributes)
        
        let attachment = NSTextAttachment(image: image)
        let imageString = NSMutableAttributedString(attachment: attachment)
        imageString.append(NSAttributedString(string: "\u{2002}"))
        attributtedString.append(imageString)
        
        attributtedString.append(NSAttributedString(string: text))
        
        return attributtedString
      }
    
    private func setupConstraints() {
      NSLayoutConstraint.activate([
        isDoneButton.heightAnchor.constraint(equalToConstant: 24),
        isDoneButton.widthAnchor.constraint(equalToConstant: 24),
        
        isDoneButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        isDoneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        isDoneButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
        
        labelsStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
        labelsStack.leadingAnchor.constraint(equalTo: isDoneButton.trailingAnchor, constant: 12),
        labelsStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -39),
        labelsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
      ])
    }
    
    func configure(item: TodoItem) {
      textItem.text = item.text
      self.text = item.text
      importanceStatus = item.importance
      isDone = item.isDone
      if let date = item.deadline,
         let image = UIImage(systemName: "calendar") {
        deadlineLabel.isHidden = false
        deadlineLabel.attributedText = addImageString(text: formatDateWithoutYearToString(date), image: image)
      } else {
        deadlineLabel.isHidden = true
      }
    }
  }

  extension ToDoTableViewCell {
    static var identifire: String {
      return String(describing: Self.self)
    }
  }

