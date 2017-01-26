import UIKit

enum Images: String {

  case defaultPlaceholder = "default-placeholder"
  case bbcLogoTabBarIcon = "tabbar-bbc-icon"
  case favoriteIcon = "star-icon"
  case favoriteSelectedIcon = "star-selected-icon"
  case warningIcon = "warning-icon"
  case waitIcon = "wait-icon"
  case sadFaceIcon = "sad-face-icon"
  case customNewsImageURL = "http://www.bbc.co.uk/news/special/2015/newsspec_10857/bbc_news_logo.png"

  var image: UIImage {
    return UIImage(named: self.rawValue)!
  }
}
