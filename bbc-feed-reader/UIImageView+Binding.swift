import UIKit
import SDWebImage
import ReactiveCocoa
import ReactiveSwift
import Result

extension UIImageView {
  public func bind(signal: Signal<URL?, NoError>, placeholder: UIImage? = nil) {
    signal.observeValues { url in
      if let url = url {
        self.sd_setImage(with: url, placeholderImage: placeholder)
      } else {
        self.image = placeholder
      }
    }
  }
}
