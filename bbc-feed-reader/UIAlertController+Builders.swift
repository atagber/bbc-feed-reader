import UIKit

extension UIAlertController {
  static func alertControllerWith(title: String,
                                  message: String?,
                                  destructiveButtonTitle: String,
                                  destructiveHandler: ((UIAlertAction) -> Void)?) -> UIAlertController {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: Strings.cancel.localized, style: .cancel, handler: nil)
    let destructiveAction = UIAlertAction(title: destructiveButtonTitle, style: .destructive, handler: destructiveHandler)

    alertController.addAction(cancelAction)
    alertController.addAction(destructiveAction)
    
    return alertController
  }
}
