import UIKit
import ReactiveCocoa
import Result
import ReactiveSwift

class RootTabBarViewController: UITabBarController {
  let viewModel: RootViewModelType = RootViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.bindViewModel()

    self.viewModel.inputs.viewDidLoad();
  }
  
  func bindViewModel() {
    self.viewModel.outputs.setViewControllers.observe(on: UIScheduler())
      .observeValues { [weak self] in self?.viewControllers = $0 }
  }
}
