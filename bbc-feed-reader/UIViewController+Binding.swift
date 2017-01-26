import UIKit
import ObjectiveC

private func swizzle(_ vc: UIViewController.Type) {
  let originalSelector = #selector(vc.viewDidLoad)
  let swizzledSelector = #selector(vc.bfr_viewDidLoad)
  
  let originalMethod = class_getInstanceMethod(vc, originalSelector)!
  let swizzledMethod = class_getInstanceMethod(vc, swizzledSelector)!
  
  let didAddViewDidLoadMethod = class_addMethod(vc,
                                                originalSelector,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod))
  
  if didAddViewDidLoadMethod {
    class_replaceMethod(vc,
                        swizzledSelector,
                        method_getImplementation(originalMethod),
                        method_getTypeEncoding(originalMethod))
  } else {
    method_exchangeImplementations(originalMethod, swizzledMethod)
  }
}

extension UIViewController {
  open override class func initialize() {
    
    // make sure this isn't a subclass
    guard self === UIViewController.self else { return }
    
    swizzle(self)
  }

  internal func bfr_viewDidLoad() {
    self.bfr_viewDidLoad()
    
    self.bindViewModel()
  }
  
  open func bindViewModel() {
  }
  
}
