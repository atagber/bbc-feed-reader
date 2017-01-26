import UIKit

class FavoritesNewsViewController: UIViewController {
  fileprivate weak var newsPostsListViewController: NewsPostsListViewController!
  fileprivate weak var statusViewController: StatusViewController!
  
  static func instantiate() -> FavoritesNewsViewController {
    let viewController = Storyboards.NewsList.instantiate(FavoritesNewsViewController.self)
    
    viewController.title = Strings.favorites.localized

    viewController.tabBarItem = UITabBarItem(title: Strings.favorites.localized,
                                             image: Images.favoriteIcon.image,
                                             selectedImage: Images.favoriteSelectedIcon.image)
    
    return viewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  override func bindViewModel() {
    super.bindViewModel()

  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else {
      return
    }
    
    switch identifier {
    case NewsPostsListViewController.storyboardIdentifier:
      self.newsPostsListViewController = segue.destination as! NewsPostsListViewController
      break
    case StatusViewController.storyboardIdentifier:
      self.statusViewController = segue.destination as! StatusViewController
    default:
      break
    }
  }
}
