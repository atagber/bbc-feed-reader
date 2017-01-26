import UIKit

extension UICollectionViewCell {
  open class var defaultReusableId: String {
    return String(describing: self)
  }
}
