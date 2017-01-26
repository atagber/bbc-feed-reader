import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result

public protocol BBCNewsViewModelInputs {

  func viewDidLoad()

  func tapped(category: NewsCategory)

  func tapped(newsPost: NewsPost)

  func addButtonTapped()
}

public protocol BBCNewsViewModelOutputs {

  var newsPosts: Signal<[NewsPost], NoError> { get }

  var category: Signal<NewsCategory, NoError> { get }

  var categories: Signal<[NewsCategory], NoError> { get }

  var currentStatus: Signal<Status, NoError> { get }

  var showNewsPost: Signal<NewsPost, NoError> { get }
}

public protocol BBCNewsViewModelType {
  var inputs: BBCNewsViewModelInputs { get }
  var outputs: BBCNewsViewModelOutputs { get }
}

public class BBCNewsViewModel: BBCNewsViewModelType, BBCNewsViewModelInputs, BBCNewsViewModelOutputs {

  init() {
    let defaultCategory = NewsCategory.topStories
    let categories: [NewsCategory] = NewsCategory.allCategories

    let currentCategory = self.currentCategory

    self.category = self.currentCategory.signal.skipNil().skipRepeats(==)
    self.categories = self.viewDidLoadProperty.signal.map {
      categories
    }

    self.tappedNewsCategoryProperty.signal.skipNil().observeValues {
        currentCategory.value = $0
      }
    self.viewDidLoadProperty.signal.observeValues {
      currentCategory.value = defaultCategory
    }

    // fetching

    let needToFetchNewsPosts = self.category

    let fetchResult: Signal<Status, NoError> = needToFetchNewsPosts
      .flatMap(.merge) {
        AppEnvironment.current.storageService.fetchNewsPosts(forCategory: $0)
      }
      .map { (result: (success: Bool, error: BBCError?)) -> Status in
        if (result.success) {
          return Status.none
        } else {
          return Status.error(error: result.error!)
        }
      }

    // sync news posts

    let databaseNewsPosts = AppEnvironment.current.storageService.newsPosts
      .map({ $0.filter({ newsPost in newsPost.newsCategory == currentCategory.value! && newsPost.isRemoved == false }) })
    let clearListOnFetching: Signal<[NewsPost], NoError> = needToFetchNewsPosts.map { _ in
      []
    }

    self.newsPosts = Signal.merge(databaseNewsPosts, clearListOnFetching)
      .map { newsPosts in
        newsPosts.sorted(by: { $0.0.publicationDate > $0.1.publicationDate })
      }

    let newsPostsAreFetching: Signal<Status, NoError> = needToFetchNewsPosts.map { _ in
      Status.fetching
    }

    let newsPostsListIsEmpty: Signal<Status, NoError> = self.newsPosts.map {
      $0.count == 0 ? Status.empty : Status.none
    }

    self.currentStatus = Signal.merge([fetchResult, newsPostsListIsEmpty, newsPostsAreFetching])

    // show news post

    self.showNewsPost = self.addButtonTappedProperty.signal.map {
      NewsPost(customForCategory: currentCategory.value!)
    }
  }

  fileprivate let currentCategory = MutableProperty<NewsCategory?>(nil)

  // MARK: BBCNewsViewModelInputs

  fileprivate let viewDidLoadProperty = MutableProperty()
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }
  fileprivate let tappedNewsCategoryProperty = MutableProperty<NewsCategory?>(nil)
  public func tapped(category: NewsCategory) {
    self.tappedNewsCategoryProperty.value = category
  }
  fileprivate let tappedNewsPostProperty = MutableProperty<NewsPost?>(nil)
  public func tapped(newsPost: NewsPost) {
    self.tappedNewsPostProperty.value = newsPost
  }
  fileprivate let addButtonTappedProperty = MutableProperty()
  public func addButtonTapped() {
    self.addButtonTappedProperty.value = ()
  }

  // MARK: BBCNewsViewModelOutputs

  public let newsPosts: Signal<[NewsPost], NoError>

  public let category: Signal<NewsCategory, NoError>

  public let categories: Signal<[NewsCategory], NoError>

  public let currentStatus: Signal<Status, NoError>

  public let showNewsPost: Signal<NewsPost, NoError>

  // MARK: BBCNewsViewModelType

  public var inputs: BBCNewsViewModelInputs {
    return self
  }
  public var outputs: BBCNewsViewModelOutputs {
    return self
  }
}
