import UIKit
import ReactiveSwift
import SDWebImage

class NewsPostCell: UITableViewCell {
  fileprivate let viewModel: NewsPostCellViewModelType = NewsPostCellViewModel()
  
  @IBOutlet fileprivate weak var contentContainerView: UIView!
  @IBOutlet fileprivate weak var newsPostImageView: UIImageView!
  @IBOutlet fileprivate weak var newsPostTitleLabel: UILabel!
  @IBOutlet fileprivate weak var newsPostSummaryLabel: UILabel!
  @IBOutlet fileprivate weak var newsPostPublicationDateLabel: UILabel!
  @IBOutlet fileprivate weak var newsPostPublicationTimeLabel: UILabel!
  @IBOutlet fileprivate weak var newsPostFavoriteImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()

    self.contentContainerView.layer.shadowOffset = CGSize.zero
    self.contentContainerView.layer.shadowRadius = 3
    self.contentContainerView.layer.shadowOpacity = 0.5
  }
  
  internal override func bindViewModel() {
    super.bindViewModel()
    
    self.newsPostTitleLabel.reactive.text <~ self.viewModel.outputs.titleLabelText
    self.newsPostSummaryLabel.reactive.text <~ self.viewModel.outputs.summaryLabelText
    self.newsPostPublicationDateLabel.reactive.text <~ self.viewModel.outputs.dateLabelText
    self.newsPostPublicationTimeLabel.reactive.text <~ self.viewModel.outputs.timeLabelText
    self.newsPostFavoriteImageView.reactive.isHidden <~ self.viewModel.outputs.favoriteIconHidden
    self.newsPostImageView.bind(signal: self.viewModel.outputs.imageURL, placeholder: Images.defaultPlaceholder.image)
  }
  
  internal func configureWith(value: NewsPost) {
    self.viewModel.inputs.configureWith(newsPost: value)
  }
}
