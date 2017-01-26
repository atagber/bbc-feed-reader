import UIKit
import ReactiveCocoa
import ReactiveSwift
import SDWebImage

protocol NewsPostViewControllerDelegate {
  func newsPostViewControllerIsGoingBack(_ controller: NewsPostViewController)
}

class NewsPostViewController: UIViewController {
  fileprivate let viewModel:NewsPostViewModelType = NewsPostViewModel()
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var newsPostTitleTextView: UITextView!
  @IBOutlet weak var newsPostSummaryTextView: UITextView!
  @IBOutlet weak var newsPostDateLabel: UILabel!
  @IBOutlet weak var newsPostTimeLabel: UILabel!
  @IBOutlet weak var newsPostImageView: UIImageView!
  
  var delegate: NewsPostViewControllerDelegate?
  
  lazy var favoriteBarButton: UIBarButtonItem = UIBarButtonItem(image: Images.favoriteIcon.image,
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(favoriteButtonPressed))
  lazy var editBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self,
                                                            action: #selector(editButtonPressed))
  lazy var saveBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(saveButtonPressed))
  lazy var deleteBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash,
                                                              target: self,
                                                              action: #selector(deleteButtonPressed))
  
  internal static func instantiate(newsPost: NewsPost) -> NewsPostViewController {
    let viewController = Storyboards.NewsPost.instantiate(NewsPostViewController.self)
    viewController.viewModel.inputs.configureWith(newsPost: newsPost)
    return viewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.viewModel.inputs.viewDidLoad()
  }
  
  override func bindViewModel() {
    super.bindViewModel()
    
    self.newsPostTitleTextView.reactive.text <~ self.viewModel.outputs.titleTextViewText
    self.newsPostSummaryTextView.reactive.text <~ self.viewModel.outputs.summaryTextViewText
    self.newsPostDateLabel.reactive.text <~ self.viewModel.outputs.dateLabelText
    self.newsPostTimeLabel.reactive.text <~ self.viewModel.outputs.timeLabelText
    self.newsPostImageView.bind(signal: self.viewModel.outputs.imageURL, placeholder: Images.defaultPlaceholder.image)
    self.saveBarButton.reactive.isEnabled <~ self.viewModel.outputs.saveButtonAvailable
    
    self.viewModel.outputs.switchToState.forUI().observeValues(self.switchTo(state:))
    self.viewModel.outputs.favoriteButtonState.forUI().observeValues(self.changeFavoriteButtonState(isChecked:))
    
    self.newsPostTitleTextView.reactive.continuousTextValues.forUI()
      .observeValues { [weak self] in self?.viewModel.inputs.titleTextViewChanged($0 ?? "") }
    self.newsPostSummaryTextView.reactive.continuousTextValues.forUI()
      .observeValues { [weak self] in self?.viewModel.inputs.summaryTextViewChanged($0 ?? "") }
    
    self.viewModel.outputs.notifyDelegateOfGoingBack.forUI().observeValues { [weak weakSelf = self] in
      guard let weakSelf = weakSelf else {
        return
      }
      weakSelf.delegate?.newsPostViewControllerIsGoingBack(weakSelf)
    }
  }
  
  fileprivate func switchTo(state: NewsPostState) {
    switch state {
    case .editing:
      self.newsPostTitleTextView.isEditable = true
      self.newsPostSummaryTextView.isEditable = true
      self.newsPostTitleTextView.becomeFirstResponder()
      self.navigationItem.rightBarButtonItems = [self.saveBarButton]
      break
    case .viewing:
      self.newsPostTitleTextView.isEditable = false
      self.newsPostSummaryTextView.isEditable = false
      self.navigationItem.rightBarButtonItems = [self.editBarButton, self.favoriteBarButton, self.deleteBarButton]
      break
    }
  }
  
  fileprivate func changeFavoriteButtonState(isChecked: Bool) {
    self.favoriteBarButton.image = isChecked ? Images.favoriteSelectedIcon.image : Images.favoriteIcon.image
  }
  
  @objc fileprivate func favoriteButtonPressed() {
    self.viewModel.inputs.favoriteButtonPressed()
  }
  
  @objc fileprivate func editButtonPressed() {
    self.viewModel.inputs.editButtonPressed()
  }
  
  @objc fileprivate func saveButtonPressed() {
    self.viewModel.inputs.saveButtonPressed()
  }
  
  @objc fileprivate func deleteButtonPressed() {
    let destructiveHandler: (Any) -> Void = {[weak self] _ in
      self?.viewModel.inputs.confirmDeletionPressed()
    }
    
    let alertController = UIAlertController
      .alertControllerWith(title: Strings.delete_post.localized,
                           message: Strings.are_you_sure_you_want_to_delete_this_post.localized,
                           destructiveButtonTitle: Strings.delete_post.localized,
                           destructiveHandler: destructiveHandler)
    
    self.present(alertController, animated: true, completion: nil)
  }
}
