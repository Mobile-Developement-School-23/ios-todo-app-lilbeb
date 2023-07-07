

import UIKit

class MainViewController: UIViewController {
    
    let plusButton = UIButton(type: .system)
    var list = FileCache()
    var hideIsDone = true
    var listToDoTableHeightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Мои дела"
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addArrangedSubview(contentDoneView)
        contentDoneView.addArrangedSubview(doneLabel)

        self.setupUI()
        setupPlusButton()
        setupViewsConstraints()
        setupDoneViewConstraints()
    }
    
    private func setupPlusButton() {
      plusButton.backgroundColor = .white
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 33, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "plus.circle.fill", withConfiguration: largeConfig)

        plusButton.setImage(largeBoldDoc, for: .normal)
          plusButton.layer.shadowColor = UIColor.black.cgColor
        plusButton.layer.shadowOpacity = 0.2
        plusButton.layer.shadowOffset = CGSize(width: 0, height: 22)
        plusButton.layer.shadowRadius = 22
        plusButton.layer.cornerRadius = 22
        plusButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
      
        plusButton.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(plusButton)
        NSLayoutConstraint.activate([
            plusButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            plusButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 166),
        ])
    }
    private func setupUI() {
        self.view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.layoutMargins = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 0)
        
    }
    
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.isScrollEnabled = true
        return scrollView
    }()

    private lazy var contentView: UIStackView = {
        let contentView = UIStackView()
        contentView.alignment = .fill
        contentView.axis = .vertical
        return contentView
    }()

    private lazy var contentDoneView: UIStackView = {
        let contentDoneView = UIStackView()
        contentDoneView.distribution = .equalCentering
        contentDoneView.axis = .horizontal
        return contentDoneView
    }()
    
    private let doneLabel: UILabel = {
        let doneLabel = UILabel()
        doneLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        doneLabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        return doneLabel
    }()
    
    func isDoneCountLabel() {
        let doneList = list.todoItems.filter { $0.isDone }
        let count = doneList.count
        doneLabel.text = "Выполнено — \(count)"
    }
    
    private lazy var showHideButton: UIButton = {
        let showDoneButton = UIButton()
        showDoneButton.setTitle("Показать", for: .normal)
        showDoneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        showDoneButton.setTitleColor(#colorLiteral(red: 0, green: 0.4780646563, blue: 0.9985368848, alpha: 1), for: .normal)
        showDoneButton.titleLabel?.textAlignment = .center
        
        showDoneButton.addTarget(self, action: #selector(showDoneButtonTapped), for: .touchUpInside)
        
        return showDoneButton
    }()
    private lazy var newButton: UIButton = {
        let newButton = UIButton()
        newButton.setTitle("Новое", for: .normal)
        newButton.setTitleColor(#colorLiteral(red: 0.6274510622, green: 0.6274510026, blue: 0.6274510026, alpha: 1), for: .normal)
        newButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        newButton.contentHorizontalAlignment = .left
        return newButton
    }()
    private lazy var listToDoTable: UITableView = {
        let listToDoTable = UITableView()
        
        listToDoTable.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        listToDoTable.tableFooterView = newButton
        listToDoTable.tableFooterView?.frame = CGRect(x: 0, y: 0, width: listToDoTable.frame.width, height: 56)
        
        listToDoTable.isScrollEnabled = false
        listToDoTable.backgroundColor = .white
        listToDoTable.layer.cornerRadius = 16
        return listToDoTable
    }()
    
    @objc func didTapButton() {
            let vc = ToDoViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    private func setupViewsConstraints() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -78),
            contentView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 32)
        ])
    }
    
    private func setupDoneViewConstraints() {
        contentDoneView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentDoneView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentDoneView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    private func updateTableHeight() {
        let deadlineCount = list.todoItems.filter { $0.deadline != nil && $0.isDone == false }.count
        var count = list.todoItems.count - deadlineCount
        if hideIsDone{
            count -= list.todoItems.filter { $0.isDone }.count
        }
        let height = CGFloat(deadlineCount * 66 + (count + 1) * 56)
        listToDoTableHeightConstraint?.constant = height
        view.layoutIfNeeded()
    }
    
    @objc func showDoneButtonTapped() {
        hideIsDone = !hideIsDone
        if hideIsDone {
            showHideButton.setTitle("Показать", for: .normal)
        } else {
            showHideButton.setTitle("Скрыть", for: .normal)
        }
    }
    
   
}


