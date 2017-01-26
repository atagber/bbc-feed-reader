import Foundation
import ReactiveSwift
import Result

public protocol NewsPostsListViewModelInputs {

  func viewDidLoad()

  func tapped(newsPost: NewsPost?)
  
  func configureWith(newsPosts: [NewsPost])
}

public protocol NewsPostsListViewModelOutputs {
  
  var newsPosts: Signal<[NewsPost], NoError> { get }

  var goToNewsPost: Signal<NewsPost, NoError> { get }
}

public protocol NewsPostsListViewModelType {
  
  var inputs: NewsPostsListViewModelInputs { get }
  var outputs: NewsPostsListViewModelOutputs { get }
}

public class NewsPostsListViewModel: NewsPostsListViewModelType, NewsPostsListViewModelInputs, NewsPostsListViewModelOutputs {

  init() {
    self.newsPosts = Signal.combineLatest(self.configureWithNewsPostsProperty.signal, self.viewDidLoadProperty.signal)
      .map { newsPosts, _ in newsPosts }
    
    self.goToNewsPost = self.tappedNewsPostProperty.signal.skipNil()
  }

  // MARK: NewsPostsViewModelInputs
  
  fileprivate let viewDidLoadProperty = MutableProperty()
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }
  fileprivate let tappedNewsPostProperty = MutableProperty<NewsPost?>(nil)
  public func tapped(newsPost: NewsPost?) {
    self.tappedNewsPostProperty.value = newsPost
  }
  fileprivate let configureWithNewsPostsProperty = MutableProperty<[NewsPost]>([])
  public func configureWith(newsPosts: [NewsPost]) {
    self.configureWithNewsPostsProperty.value = newsPosts
  }
  
  // MARK: NewsPostsViewModelOutputs
  
  public let newsPosts: Signal<[NewsPost], NoError>
  public let goToNewsPost: Signal<NewsPost, NoError>
  
  // MARK: NewsPostsViewModelType
  
  public var inputs: NewsPostsListViewModelInputs { return self }
  public var outputs: NewsPostsListViewModelOutputs { return self }
}
