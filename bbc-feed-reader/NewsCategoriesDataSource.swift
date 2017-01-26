import UIKit

class NewsCategoriesDataSource: NSObject, UICollectionViewDataSource {
  fileprivate var categories = [NewsCategory]()
  fileprivate var selectedNewsCategory: NewsCategory?

  public func changeSelectedValue(_ value: NewsCategory) {
    self.selectedNewsCategory = value
  }

  public func load(values: [NewsCategory]) {
    self.categories = values
  }

  public func value(atIndexPath indexPath: IndexPath) -> NewsCategory {
    return categories[indexPath.row]
  }

  // MARK: UICollectionViewDataSource

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return categories.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCategoryCell.defaultReusableId,
                                                  for: indexPath) as! NewsCategoryCell

    let value = self.value(atIndexPath: indexPath)
    let isSelected = value == selectedNewsCategory

    cell.configureWith(category: value, isSelected: isSelected)

    return cell
  }
}
