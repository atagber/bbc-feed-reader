import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result


protocol FavoritesNewsViewModelInputs {

  func viewDidLoad()
}

protocol FavoritesNewsViewModelOutputs {

  var newsPosts: Signal<[NewsPost], NoError> { get }

  var currentStatus: Signal<Status, NoError> { get }
}

protocol FavoritesNewsViewModelType {
  var inputs: FavoritesNewsViewModelInputs { get }
  var outputs: FavoritesNewsViewModelOutputs { get }
}

class FavoritesNewsViewModel: FavoritesNewsViewModelType, FavoritesNewsViewModelInputs,
  FavoritesNewsViewModelOutputs {

  init() {
    self.newsPosts = Signal.combineLatest(AppEnvironment.current.storageService.newsPosts, self.viewDidLoadProperty.signal)
      .map { newsPosts, _ in
        newsPosts.filter {
          !$0.isRemoved && $0.isFavorite
        }
      }

    self.currentStatus = self.newsPosts.map {
      $0.count == 0 ? Status.empty : Status.none
    }
  }

  // MARK: FavoritesNewsViewModelInputs
  fileprivate let viewDidLoadProperty = MutableProperty()
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  // MARK: FavoritesNewsViewModelOutputs

  public let newsPosts: Signal<[NewsPost], NoError>

  public let currentStatus: Signal<Status, NoError>

  // MARK: FavoritesNewsViewModelType

  public var inputs: FavoritesNewsViewModelInputs {
    return self
  }
  public var outputs: FavoritesNewsViewModelOutputs {
    return self
  }
}
