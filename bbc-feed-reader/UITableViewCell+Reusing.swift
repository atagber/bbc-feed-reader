import UIKit

extension UITableViewCell {
  open class var defaultReusableId: String {
    return String(describing: self)
  }
}
