

import UIKit

class TaskTextView: UITextView {
    
    weak var taskDelegate: TaskTextViewDelegate?

    init() {
        super.init(frame: .zero, textContainer: nil)
        backgroundColor = Colors.backSecondary
        layer.cornerRadius = 16
        font = UIFont.body
        textColor = Colors.labelTertiary
        text = "Что надо сделать?"
        textContainerInset = UIEdgeInsets(
            top: 17,
            left: 16,
            bottom: 17,
            right: 16
        )
        isScrollEnabled = false
        delegate = self
        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
extension TaskTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !textView.text.isEmpty && textView.text == "Что надо сделать?" {
            textView.text = nil
            textView.textColor = Colors.labelPrimary
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        taskDelegate?.textViewDidChangeText(textView)
        taskDelegate?.fetchTaskDescription(textView)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Что надо сделать?"
            textView.textColor = Colors.labelTertiary
        }
    }
}
