import UIKit

extension UIViewController {
  public static var storyboardIdentifier: String {
    return String(describing: self)
  }
}
