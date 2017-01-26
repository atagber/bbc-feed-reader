import UIKit

protocol NewsCategoriesViewControllerDelegate: class {
  func newsCategories(viewController: NewsCategoriesViewController, selectedCategory: NewsCategory)
}

class NewsCategoriesViewController: UICollectionViewController {
  fileprivate let viewModel: NewsCategoriesViewModelType = NewsCategoriesViewModel()
  fileprivate let dataSource = NewsCategoriesDataSource()
  
  public weak var delegate: NewsCategoriesViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.collectionView!.dataSource = self.dataSource
    
    self.viewModel.inputs.viewDidLoad()
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    
    self.viewModel.outputs.updateCategoriesList.forUI().observeValues {[weak self] categories in
      self?.dataSource.load(values: categories)
      self?.collectionView!.reloadData()
    }
    
    self.viewModel.outputs.selectedCategory.forUI().observeValues {[weak self] category in
      self?.dataSource.changeSelectedValue(category)
      self?.collectionView!.reloadData()
    }
    
    self.viewModel.outputs.notifyDelegateOfSelectedCategory.forUI().observeValues {[weak weakSelf = self] categories in
      guard let weakSelf = weakSelf else {
        return
      }
      weakSelf.delegate?.newsCategories(viewController: weakSelf, selectedCategory: categories)
    }
  }
  
  // MARK: UICollectionViewDelegate
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.viewModel.inputs.categoryCellTapped(index: indexPath.row)
  }
}

extension NewsCategoriesViewController {
  public func configureWith(categories: [NewsCategory]) {
    self.viewModel.inputs.configureWith(categories: categories)
  }
  
  public func switchTo(category: NewsCategory) {
    self.viewModel.inputs.select(category: category)
  }
}

extension NewsCategoriesViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let text: NSString = self.dataSource.value(atIndexPath: indexPath).name as NSString
    let font = NewsCategoryCell.categoryNameFont
    let textWidth = text.size(attributes: [NSFontAttributeName: font]).width + 10
    return CGSize(width: textWidth, height: CGFloat(NewsCategoryCell.defaultHeight))
  }
}
