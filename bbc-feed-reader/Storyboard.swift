import UIKit

public enum Storyboards: String {
  case Main
  
  public func instantiate<VC: UIViewController>(_ viewController: VC.Type,
    inBundle bundle: Bundle? = nil) -> VC {
    let storyboardIdentifier = VC.storyboardIdentifier
    guard let viewController = UIStoryboard(name: self.rawValue, bundle: bundle)
      .instantiateViewController(withIdentifier: storyboardIdentifier) as? VC
      else {
        fatalError("Could not find the ViewController with name: \(VC.storyboardIdentifier) in Storyboard with name: \(self.rawValue)")
    }
    
    return viewController
  }
}
