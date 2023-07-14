
import UIKit


class MainViewController: UIViewController {
    
    var items = Items()
    var showItems: [TodoItem] = []
    
    var fileCache = FileCache()
    var completed = 0
    var detailsViewController = ToDoViewController()
    
    private lazy var tableView = makeTableView()
    private lazy var addButton = makeAddButton()
    private lazy var headerView = makeHeaderView()
    
    
    @objc func addButtonPressed() {
        let itemDetailsViewController = ToDoViewController()
        itemDetailsViewController.delegate = self
        itemDetailsViewController.isNewItem = true
        let itemDetailsNavigationController = UINavigationController(rootViewController: itemDetailsViewController)
        present(itemDetailsNavigationController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupShowingItems()
        initShowingItems()
        setupViews()
        
    }
 
   
    private func setupShowingItems() {
      items.item = fileCache.todoItems
      items.item.sort { $0.creationDate.timeIntervalSince1970 < $1.creationDate.timeIntervalSince1970 }
      showItems = hideButtonIsActive() ? items.item : items.item.filter { $0.isDone == false }
      updateCompletedItemsLabel()
      UIView.transition(with: tableView, duration: 0.2, options: .transitionCrossDissolve, animations: {
        self.tableView.reloadData()
      }, completion: nil)
    }
    
    private func initShowingItems() {
        showItems = items.item
//        showItems.append(TodoItem(text: "biba", importance: .notImportant, isDone: false, creationDate: .now))
        updateCompletedItemsLabel()
    }

    private func hideButtonIsActive() -> Bool {
      headerView.showHideButton.titleLabel?.text == "Скрыть"
    }

    private func updateCompletedItemsLabel() {
      completed = items.item.filter { $0.isDone == true }.count
      headerView.isDoneCountLabel.text = "Выполнено — \(completed)"
    }

    override func viewWillTransition(to _: CGSize, with _: UIViewControllerTransitionCoordinator) {
      tableView.reloadData()
    }
    
    private func setupViews() {
        title = "Мои дела"
        view.backgroundColor = Colors.backPrimary
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.layoutMargins = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 0)
        
        view.addSubview(tableView)
        view.addSubview(addButton)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
        ])
    }
    
    private func makeHeaderView() -> HeaderView {
        let headerView = HeaderView()
        headerView.delegate = self
        return headerView
    }
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 56
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(NewTask.self, forCellReuseIdentifier: NewTask.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }
    
    private func makeAddButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "plus.circle.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier,for: indexPath) as? TableViewCell
        else { return UITableViewCell() }
        cell.delegate = self
        if indexPath.row <= showItems.count - 1 {
            cell.configure(with: showItems[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsVC = ToDoViewController()
        detailsVC.delegate = self
        detailsVC.isNewItem = true
        
        if indexPath.row <= showItems.count - 1 {
            let selected = showItems[indexPath.row]
            detailsVC.selectedItem = selected
            detailsVC.isNewItem = false
            detailsVC.itemDetailsView.refreshView()
        }
        
        let detailsNavigationController = UINavigationController(rootViewController: detailsVC)
        present(detailsNavigationController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { headerView }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 56 }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 40 }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard indexPath.row <= items.item.count - 1 else {
            return nil
        }
        
        let action = UIContextualAction(
            style: .normal,
            title: nil,
            handler: { [weak self] _, _, _ in
                var item = self?.showItems[indexPath.row]
                item?.isDone.toggle()
                self?.saveItem(item!, false)
            }
        )
        action.image = UIImage(systemName: "checkmark.circle.fill")
        action.backgroundColor = Colors.colorGreen
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row <= items.item.count - 1 else {
            return nil
        }
        let deleteAction = UIContextualAction(
            style: .normal,
            title: nil,
            handler: { [weak self] _, _, _ in
                self?.deleteItem(self?.showItems[indexPath.row].taskId ?? "")
            }
        )
        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = Colors.colorRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension MainViewController: ToDoViewControllerDelegate {
    func deleteItem(_ id: String) {
        fileCache.removeTodoItem(id: id)
    }
    
    func saveItem(_ item: TodoItem, _ flag: Bool) {
        fileCache.addTodoItem(item: item)
    }
}

extension MainViewController: TableViewCellDelegate {
    func TableViewCellButton(_ taskCell: TableViewCell) {
        guard let indexPath = tableView.indexPath(for: taskCell) else { return }
        var selected = showItems[indexPath.row]
        selected.isDone.toggle()
        saveItem(selected, false)
    }
}


extension MainViewController: HeaderViewDelegate {
    func hideButtonPressed(_ sender: UIButton) {
        if hideButtonIsActive() {
            showItems = items.item.filter { $0.isDone == false }
            sender.setTitle("Показать", for: .normal)
        } else {
            showItems = items.item
            sender.setTitle("Скрыть", for: .normal)
        }
        UIView.transition(with: tableView, duration: 0.3, options: .transitionFlipFromRight, animations: {
            self.tableView.reloadData()
        }, completion: nil)
    }
}
