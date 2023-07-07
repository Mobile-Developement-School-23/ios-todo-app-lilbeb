

import UIKit

class TableViewTaskList: UITableView {
    private enum Const {
        static let taskIdentifier: String = "TasksListItemView"
        static let newTaskIdentifier: String = "NewTaskView"
    }
    
    init() {
      super.init(frame: .zero, style: .insetGrouped)
      backgroundColor = .clear
      register(
        TableViewCell.self,
        forCellReuseIdentifier: Const.taskIdentifier
      )
      register(
        NewTaskTableViewCell.self,
        forCellReuseIdentifier: Const.newTaskIdentifier
      )
      rowHeight = UITableView.automaticDimension
      estimatedRowHeight = 56
      showsVerticalScrollIndicator = false
      translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
}
