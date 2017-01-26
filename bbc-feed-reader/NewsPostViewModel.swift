import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result

public enum NewsPostState {
  case editing
  case viewing
}

public protocol NewsPostViewModelInputs {

  func configureWith(newsPost: NewsPost)

  func viewDidLoad()

  func favoriteButtonPressed()

  func editButtonPressed()

  func saveButtonPressed()

  func confirmDeletionPressed()

  func titleTextViewChanged(_ title: String)

  func summaryTextViewChanged(_ summary: String)
}

public protocol NewsPostViewModelOutputs {

  var titleTextViewText: Signal<String?, NoError> { get }

  var summaryTextViewText: Signal<String?, NoError> { get }

  var imageURL: Signal<URL?, NoError> { get }

  var dateLabelText: Signal<String?, NoError> { get }

  var timeLabelText: Signal<String?, NoError> { get }

  var favoriteButtonState: Signal<Bool, NoError> { get }

  var switchToState: Signal<NewsPostState, NoError> { get }

  var saveButtonAvailable: Signal<Bool, NoError> { get }

  var notifyDelegateOfGoingBack: Signal<Void, NoError> { get }
}

public protocol NewsPostViewModelType {
  var inputs: NewsPostViewModelInputs { get }
  var outputs: NewsPostViewModelOutputs { get }
}

public class NewsPostViewModel: NewsPostViewModelType, NewsPostViewModelInputs, NewsPostViewModelOutputs {
  init() {
    // wait for viewDidLoad
    let titleProperty = self.titleTextViewChangedProperty
    let summaryProperty = self.summaryTextViewChangedProperty

    let newsPost = Signal.combineLatest(self.viewDidLoadProperty.signal, self.newsPostProperty.signal)
      .map { _, newsPost in
        newsPost
      }.skipNil()

    // initial state

    self.titleTextViewText = newsPost.map {
      $0.title
    }
    self.summaryTextViewText = newsPost.map {
      $0.summary
    }
    self.imageURL = newsPost.map {
      URL(string: $0.imageURLString)
    }
    self.dateLabelText = newsPost.map {
      $0.publicationDate.dateToStringForNewsPost()
    }
    self.timeLabelText = newsPost.map {
      $0.publicationDate.timeToStringForNewsPost()
    }
    self.favoriteButtonState = newsPost.map {
      $0.isFavorite
    }
    newsPost.observeValues {
      titleProperty.value = $0.title
      summaryProperty.value = $0.summary
    }
    // favorite button state

    let newsPostProperty = self.newsPostProperty
    self.favoriteButtonPressedProperty.signal.observeValues { _ in
      let currentNewsPost = newsPostProperty.value!
      newsPostProperty.value = currentNewsPost.changed(isFavorite: !currentNewsPost.isFavorite)
      AppEnvironment.current.storageService.save(newsPost: newsPostProperty.value!)
    }

    // deletion

    self.notifyDelegateOfGoingBack = self.confirmDeletionPressedProperty.signal.map {
      let value = newsPostProperty.value!
      let changed = value.changed(isChanged: true, isRemoved: true)
      AppEnvironment.current.storageService.save(newsPost: changed)
    }

    // validation

    self.saveButtonAvailable = Signal.combineLatest(titleProperty.signal, summaryProperty.signal)
      .map {
        !String.isEmptyAfterTrimming($0.0) && !String.isEmptyAfterTrimming($0.1)
      }

    // change state

    self.switchToState = Signal.merge([self.editButtonPressedProperty.signal.map {
      NewsPostState.editing
    },
                                       self.saveButtonPressedProperty.signal.map {
                                         NewsPostState.viewing
                                       },
                                       newsPost.map {
                                         $0.isCustom && !$0.isChanged ? NewsPostState.editing : NewsPostState.viewing
                                       }])

    // save news post

    self.saveButtonPressedProperty.signal.observeValues {
      let value = newsPostProperty.value!
      let title = String.trim(titleProperty.value)
      let summary = String.trim(summaryProperty.value)

      let changed = value.changed(isChanged: true, publicationDate: Date(), summary: summary, title: title)
      AppEnvironment.current.storageService.save(newsPost: changed)
      newsPostProperty.value = changed
    }
  }

  // MARK: NewsPostViewModelInputs

  fileprivate let newsPostProperty = MutableProperty<NewsPost?>(nil)
  public func configureWith(newsPost: NewsPost) {
    self.newsPostProperty.value = newsPost
  }
  fileprivate let viewDidLoadProperty = MutableProperty()
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }
  fileprivate let favoriteButtonPressedProperty = MutableProperty()
  public func favoriteButtonPressed() {
    self.favoriteButtonPressedProperty.value = ()
  }
  fileprivate let editButtonPressedProperty = MutableProperty()
  public func editButtonPressed() {
    self.editButtonPressedProperty.value = ()
  }
  fileprivate let confirmDeletionPressedProperty = MutableProperty()
  public func confirmDeletionPressed() {
    self.confirmDeletionPressedProperty.value = ()
  }
  fileprivate let saveButtonPressedProperty = MutableProperty()
  public func saveButtonPressed() {
    self.saveButtonPressedProperty.value = ()
  }
  fileprivate let titleTextViewChangedProperty = MutableProperty<String?>(nil)
  public func titleTextViewChanged(_ title: String) {
    self.titleTextViewChangedProperty.value = title
  }
  fileprivate let summaryTextViewChangedProperty = MutableProperty<String?>(nil)
  public func summaryTextViewChanged(_ summary: String) {
    self.summaryTextViewChangedProperty.value = summary
  }

  // MARK: NewsPostViewModelOutputs

  public let titleTextViewText: Signal<String?, NoError>
  public let summaryTextViewText: Signal<String?, NoError>
  public let imageURL: Signal<URL?, NoError>
  public let dateLabelText: Signal<String?, NoError>
  public let timeLabelText: Signal<String?, NoError>
  public let favoriteButtonState: Signal<Bool, NoError>
  public let switchToState: Signal<NewsPostState, NoError>
  public let saveButtonAvailable: Signal<Bool, NoError>
  public let notifyDelegateOfGoingBack: Signal<Void, NoError>

  // MARK: NewsPostViewModel

  public var inputs: NewsPostViewModelInputs {
    return self
  }
  public var outputs: NewsPostViewModelOutputs {
    return self
  }
}
