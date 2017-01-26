import Foundation
import ReactiveSwift
import Result

internal protocol NewsPostCellViewModelInputs {
  
  func configureWith(newsPost: NewsPost)
}

internal protocol NewsPostCellViewModelOutputs {
  
  var titleLabelText: Signal<String?, NoError> { get }
  
  var summaryLabelText: Signal<String?, NoError> { get }
  
  var imageURL: Signal<URL?, NoError> { get }
  
  var dateLabelText: Signal<String?, NoError> { get }
  
  var timeLabelText: Signal<String?, NoError> { get }
  
  var favoriteIconHidden: Signal<Bool, NoError> { get }
}

internal protocol NewsPostCellViewModelType {
  
  var inputs: NewsPostCellViewModelInputs { get }
  var outputs: NewsPostCellViewModelOutputs { get }
}

internal class NewsPostCellViewModel: NewsPostCellViewModelType, NewsPostCellViewModelInputs, NewsPostCellViewModelOutputs {
  init() {
    let newsPost = self.newsPostProperty.signal.skipNil()
    
    self.titleLabelText = newsPost.map { $0.title }
    self.summaryLabelText = newsPost.map { $0.summary }
    self.imageURL = newsPost.map { URL(string: $0.imageURLString) }
    self.dateLabelText = newsPost.map { $0.publicationDate.dateToStringForNewsPost() }
    self.timeLabelText = newsPost.map { $0.publicationDate.timeToStringForNewsPost() }
    self.favoriteIconHidden = newsPost.map { !$0.isFavorite }
  }
  
  // MARK: NewsCellViewModelInputs
  
  fileprivate let newsPostProperty = MutableProperty<NewsPost?>(nil)
  internal func configureWith(newsPost: NewsPost) {
    self.newsPostProperty.value = newsPost
  }
  
  // MARK: NewsCellViewModelOutputs
  
  internal let titleLabelText: Signal<String?, NoError>
  internal let summaryLabelText: Signal<String?, NoError>
  internal let imageURL: Signal<URL?, NoError>
  internal let dateLabelText: Signal<String?, NoError>
  internal let timeLabelText: Signal<String?, NoError>
  internal let favoriteIconHidden: Signal<Bool, NoError>
  
  // MARK: NewsCellViewModelType
  
  internal var inputs: NewsPostCellViewModelInputs { return self }
  internal var outputs: NewsPostCellViewModelOutputs { return self }
}
