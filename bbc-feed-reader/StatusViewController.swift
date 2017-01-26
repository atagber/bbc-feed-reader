import UIKit
import ReactiveCocoa
import ReactiveSwift

class StatusViewController: UIViewController {
  fileprivate let viewModel: StatusViewModelType = StatusViewModel()
  @IBOutlet weak var statusImageView: UIImageView!
  @IBOutlet weak var statusMessageLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.viewModel.inputs.viewDidLoad()
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    
    self.statusImageView.reactive.image <~ self.viewModel.outputs.statusImage
    self.statusMessageLabel.reactive.text <~ self.viewModel.outputs.statusMessage
    self.view.reactive.isHidden <~ self.viewModel.outputs.statusViewHidden
  }
}

extension StatusViewController {
  func configureWith(status: Status) {
    self.viewModel.inputs.configureWith(status: status)
  }
}
