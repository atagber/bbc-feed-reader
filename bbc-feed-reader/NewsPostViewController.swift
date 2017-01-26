import UIKit
import ReactiveCocoa
import ReactiveSwift
import SDWebImage

protocol NewsPostViewControllerDelegate {
  func newsPostViewControllerIsGoingBack(_ controller: NewsPostViewController)
}

class NewsPostViewController: UIViewController {

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
    return viewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  override func bindViewModel() {
    super.bindViewModel()

  }

  @objc fileprivate func favoriteButtonPressed() {
    
  }
  
  @objc fileprivate func editButtonPressed() {
    
  }
  
  @objc fileprivate func saveButtonPressed() {
    
  }
  
  @objc fileprivate func deleteButtonPressed() {

  }
}
