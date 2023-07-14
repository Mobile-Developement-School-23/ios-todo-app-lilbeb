
import UIKit


protocol TaskDetailViewDelegate: AnyObject {
  func switchTapped(_ sender: UISwitch)
  func segmentControlTapped(_ sender: UISegmentedControl)
  func deleteButtonTapped()
  func toggleSaveButton(_ textView: UITextView)
  func dateSelection(_ date: DateComponents?)
  func fetchTaskText(_ textView: UITextView)
}

protocol ToDoViewControllerDelegate: AnyObject {
  func deleteItem(_ id: String)
  func saveItem(_ item: TodoItem, _ flag: Bool)
}

protocol TaskTextViewDelegate: AnyObject {
  func textViewDidChangeText(_ textView: UITextView)
  func fetchTaskDescription(_ textView: UITextView)
}

protocol TaskSettingsDelegate: AnyObject {
  func switchTapped(_ sender: UISwitch)
  func segmentControlTapped(_ sender: UISegmentedControl)
  func dateSelection(_ date: DateComponents?)
}
