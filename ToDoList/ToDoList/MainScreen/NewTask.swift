

import UIKit

class NewTask: UITableViewCell {
    static let identifier = "NewTask"
    
    private lazy var newLabel: UILabel = {
        let label = UILabel()
        label.text = "Новое"
        label.font = UIFont.body
        label.textColor = Colors.labelTertiary
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Colors.backSecondary
        setup()
    }
    
    private func setup() {
        contentView.addSubview(newLabel)
        NSLayoutConstraint.activate([
            newLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            newLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 52),
            newLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            newLabel.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
      super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
    }

}
