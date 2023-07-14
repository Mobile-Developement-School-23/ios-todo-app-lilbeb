
import UIKit

protocol HeaderViewDelegate: AnyObject {
  func hideButtonPressed(_ sender: UIButton)
}

protocol TableViewCellDelegate: AnyObject {
  func TableViewCellButton(_ taskCell: TableViewCell)
}
