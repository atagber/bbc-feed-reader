import UIKit
import ReactiveCocoa
import Result
import ReactiveSwift

class RootTabBarViewController: UITabBarController {
  let viewModel: RootViewModelType = RootViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.viewModel.inputs.viewDidLoad();
  }
  
  override func bindViewModel() {
    self.viewModel.outputs.setViewControllers.observe(on: UIScheduler())
      .observeValues { [weak self] in self?.viewControllers = $0 }
  }
}
