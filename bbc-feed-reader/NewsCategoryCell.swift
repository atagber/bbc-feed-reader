import UIKit
import ReactiveCocoa
import ReactiveSwift

class NewsCategoryCell: UICollectionViewCell {
  fileprivate let viewModel: NewsCategoryCellViewModelType = NewsCategoryCellViewModel()

  // it needs to determine cell width
  static let categoryNameFont = UIFont(name: "HelveticaNeue", size: 17.0)!
  static let defaultHeight = 44.0

  @IBOutlet weak var newsCategoryNameLabel: UILabel!
  @IBOutlet weak var selectionIndicatorView: UIView!

  override func awakeFromNib() {
    super.awakeFromNib()

    self.newsCategoryNameLabel.font = NewsCategoryCell.categoryNameFont
  }

  override func bindViewModel() {
    super.bindViewModel()

    self.newsCategoryNameLabel.reactive.text <~ self.viewModel.outputs.nameLabelText
    self.selectionIndicatorView.reactive.isHidden <~ self.viewModel.outputs.selectionIndicatorHidden
  }

  func configureWith(category: NewsCategory, isSelected: Bool) {
    self.viewModel.inputs.configureWith(newsCategory: category, isSelected: isSelected)
  }
}
