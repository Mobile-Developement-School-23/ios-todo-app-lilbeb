

import UIKit


class HeaderView: UIView {
    weak var delegate: HeaderViewDelegate?

    let isDoneCountLabel: UILabel = {
        let label = UILabel()
        label.text = "Выполнено - 0)"
        label.font = UIFont.subhead
        label.textColor = Colors.labelTertiary

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var showHideButton: UIButton = {
        let button = UIButton()
        button.setTitle("Скрыть", for: .normal)
        button.setTitleColor(Colors.colorBlue, for: .normal)
        button.titleLabel?.font = UIFont.subhead
        button.addTarget(self, action: #selector(hideButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func hideButtonPressed(_ sender: UIButton) {
      delegate?.hideButtonPressed(sender)
    }
    
    override init(frame: CGRect) {
      super.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: 40))
      addSubview(isDoneCountLabel)
      NSLayoutConstraint.activate([
        isDoneCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        isDoneCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      ])
      addSubview(showHideButton)
      NSLayoutConstraint.activate([
        showHideButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        showHideButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

}
