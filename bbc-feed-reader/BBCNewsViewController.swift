import UIKit

class BBCNewsViewController: UIViewController {
  weak var categoriesViewController: NewsCategoriesViewController!
  weak var newsPostsViewController: NewsPostsListViewController!
  
  static func instantiate() -> BBCNewsViewController {
    let viewController = Storyboards.NewsList.instantiate(BBCNewsViewController.self)
    viewController.title = Strings.news.localized
    viewController.tabBarItem = UITabBarItem(title: Strings.news.localized,
                                             image: Images.bbcLogoTabBarIcon.image,
                                             selectedImage: Images.bbcLogoTabBarIcon.image)
    return viewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                             target: self,
                                                             action: #selector(addButtonTapped))
  }
  
  @objc private func addButtonTapped() {
    // TODO: implement this method
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else {
      return
    }
    
    switch identifier {
    case NewsCategoriesViewController.storyboardIdentifier:
      self.categoriesViewController = segue.destination as! NewsCategoriesViewController
      self.categoriesViewController.delegate = self
      break
    case NewsPostsListViewController.storyboardIdentifier:
      self.newsPostsViewController = segue.destination as! NewsPostsListViewController
      break
    default:
      break
    }
  }
}

extension BBCNewsViewController: NewsCategoriesViewControllerDelegate {
  func newsCategories(viewController: NewsCategoriesViewController, selectedCategory: NewsCategory) {
    // TODO: implement this method
  }
}
