import UIKit

class BBCNewsViewController: UIViewController {
  fileprivate let viewModel: BBCNewsViewModelType = BBCNewsViewModel()
  
  weak var categoriesViewController: NewsCategoriesViewController!
  weak var newsPostsViewController: NewsPostsListViewController!
  weak var statusViewController: StatusViewController!
  
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

    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                             target: self,
                                                             action: #selector(addButtonTapped))
    self.viewModel.inputs.viewDidLoad()
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    
    self.viewModel.outputs.category.forUI().observeValues(self.categoriesViewController.switchTo(category:))
    self.viewModel.outputs.categories.forUI().observeValues(self.categoriesViewController.configureWith(categories:))
    self.viewModel.outputs.newsPosts.forUI().observeValues(self.newsPostsViewController.configureWith(newsPosts:))
    self.viewModel.outputs.currentStatus.forUI().observeValues(self.statusViewController.configureWith(status:))
    self.viewModel.outputs.showNewsPost.forUI().observeValues(self.newsPostsViewController.goTo(newsPost:))
  }
  
  @objc private func addButtonTapped() {
    self.viewModel.inputs.addButtonTapped()
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
    case StatusViewController.storyboardIdentifier:
      self.statusViewController = segue.destination as! StatusViewController
      break
    default:
      break
    }
  }
}

extension BBCNewsViewController: NewsCategoriesViewControllerDelegate {
  func newsCategories(viewController: NewsCategoriesViewController, selectedCategory: NewsCategory) {
    self.viewModel.inputs.tapped(category: selectedCategory)
  }
}
