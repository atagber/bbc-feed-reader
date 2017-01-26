import Foundation
import ReactiveSwift
import Result

internal protocol RootViewModelInputs {

  func viewDidLoad()
}

internal protocol RootViewModelOutputs {

  var setViewControllers: Signal<[UIViewController], NoError> { get }
}

internal protocol RootViewModelType {
  var inputs: RootViewModelInputs { get }
  var outputs: RootViewModelOutputs { get }
}

internal final class RootViewModel: RootViewModelType, RootViewModelInputs, RootViewModelOutputs {
  init() {
    let defaultViewControllers: Signal<[UIViewController], NoError> = self.viewDidLoadProperty.signal.map { _ in
      [
        BBCNewsViewController.instantiate() as UIViewController,
      ]
    }
    
    self.setViewControllers = defaultViewControllers.map { $0.map(UINavigationController.init(rootViewController:)) }
  }

  // MARK: RootViewModelInputs

  fileprivate var viewDidLoadProperty = MutableProperty()
  internal func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }
  
  // MARK: RootViewModelOutputs
  
  internal let setViewControllers: Signal<[UIViewController], NoError>
  
  // MARK: RootViewModelType
  
  internal var inputs: RootViewModelInputs { return self }
  internal var outputs: RootViewModelOutputs { return self }
}
