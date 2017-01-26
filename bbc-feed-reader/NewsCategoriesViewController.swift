import UIKit

protocol NewsCategoriesViewControllerDelegate: class {
  func newsCategories(viewController: NewsCategoriesViewController, selectedCategory: NewsCategory)
}

class NewsCategoriesViewController: UICollectionViewController {
  public weak var delegate: NewsCategoriesViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  override func bindViewModel() {
    super.bindViewModel()

  }
  
  // MARK: UICollectionViewDelegate
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // TODO: implement this method
  }
}

