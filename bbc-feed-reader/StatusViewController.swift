import UIKit
import ReactiveCocoa
import ReactiveSwift

class StatusViewController: UIViewController {
  @IBOutlet weak var statusImageView: UIImageView!
  @IBOutlet weak var statusMessageLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  override func bindViewModel() {
    super.bindViewModel()

  }
}

extension StatusViewController {
  func configureWith(status: Status) {
    // TODO: implement this method
  }
}
