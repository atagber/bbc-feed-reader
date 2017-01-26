import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result

public enum Status {
  case error(error: BBCError)
  case empty
  case fetching
  case none
  
  var image: UIImage? {
    switch self {
    case .empty:
      return Images.sadFaceIcon.image
    case .fetching:
      return Images.waitIcon.image
    case .error:
      return Images.warningIcon.image
    case .none:
      return nil
    }
  }
  
  var message: String? {
    switch self {
    case .empty:
      return Strings.there_are_no_items_to_show.localized
    case .fetching:
      return Strings.downloading_please_wait.localized
    case .error:
      return Strings.an_error_occurred_please_try_again_later.localized
    case .none:
      return nil
    }
  }
}

protocol StatusViewModelInputs {
  func configureWith(status: Status)
  func viewDidLoad()
}

protocol StatusViewModelOutputs {
  var statusImage: Signal<UIImage?, NoError> { get }
  var statusMessage: Signal<String?, NoError> { get }
  var statusViewHidden: Signal<Bool, NoError> { get }
}

protocol StatusViewModelType {
  var inputs: StatusViewModelInputs { get }
  var outputs: StatusViewModelOutputs { get }
}

class StatusViewModel: StatusViewModelType, StatusViewModelInputs, StatusViewModelOutputs {
  
  init() {
    let status = Signal.combineLatest(self.configureWithStatusProperty.signal, self.viewDidLoadProperty.signal).map { status, _ in status }.skipNil()
    
    self.statusImage = status.map { $0.image }
    self.statusMessage = status.map { $0.message }
    self.statusViewHidden = status.map {
      switch $0 {
      case .none: return true
      default: return false
      }
    }
  }
  
  // MARK: StatusViewModelInputs
  
  fileprivate let configureWithStatusProperty = MutableProperty<Status?>(.none)
  public func configureWith(status: Status) {
    self.configureWithStatusProperty.value = status
  }
  fileprivate let viewDidLoadProperty = MutableProperty()
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }
  
  // MARK: StatusViewModelOutputs
  
  public let statusImage: Signal<UIImage?, NoError>
  public let statusMessage: Signal<String?, NoError>
  public let statusViewHidden: Signal<Bool, NoError>
  
  // MARK: StatusViewModelType
  
  public var inputs: StatusViewModelInputs { return self }
  public var outputs: StatusViewModelOutputs { return self }
}
