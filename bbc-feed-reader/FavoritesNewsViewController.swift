import UIKit

class FavoritesNewsViewController: UIViewController {
  fileprivate let viewModel: FavoritesNewsViewModelType = FavoritesNewsViewModel()
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

    self.viewModel.inputs.viewDidLoad()
  }

  override func bindViewModel() {
    super.bindViewModel()

    self.viewModel.outputs.currentStatus.forUI().observeValues(self.statusViewController.configureWith(status:))
    self.viewModel.outputs.newsPosts.forUI().observeValues(self.newsPostsListViewController.configureWith(newsPosts:))
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
