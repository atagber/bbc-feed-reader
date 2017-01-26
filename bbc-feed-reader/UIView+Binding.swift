import UIKit

extension UIView {
  open override func awakeFromNib() {
    super.awakeFromNib()
    self.bindViewModel()
  }
  
  open func bindViewModel() {
  }
}
