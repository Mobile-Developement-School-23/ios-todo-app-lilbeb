

import UIKit

protocol headerViewDelegate: AnyObject {
  func showHideButtonTapped(_ sender: UIButton)
}

class headerView: UIView {
    weak var delegate: headerViewDelegate?

    let isDoneCountLabel: UILabel = {
      let label = UILabel()
      label.text = "Выполнено - 0)"
      label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }()
    
    lazy var showHideButton: UIButton = {
      let button = UIButton()
      button.setTitle("Скрыть", for: .normal)
        button.setTitleColor(UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0), for: .normal)
      button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
      button.addTarget(self, action: #selector(showHideButtonTapped), for: .touchUpInside)
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
    }()
    
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

    @objc private func showHideButtonTapped(_ sender: UIButton) {
      delegate?.showHideButtonTapped(sender)
    }
}
