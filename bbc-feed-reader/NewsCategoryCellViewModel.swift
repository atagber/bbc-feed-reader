import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result

public protocol NewsCategoryCellViewModelInputs {

  func configureWith(newsCategory: NewsCategory, isSelected: Bool)
}

public protocol NewsCategoryCellViewModelOutputs {

  var nameLabelText: Signal<String, NoError> { get }

  var selectionIndicatorHidden: Signal<Bool, NoError> { get }
}

public protocol NewsCategoryCellViewModelType {

  var inputs: NewsCategoryCellViewModelInputs { get }
  var outputs: NewsCategoryCellViewModelOutputs { get }
}

public class NewsCategoryCellViewModel: NewsCategoryCellViewModelType, NewsCategoryCellViewModelInputs,
  NewsCategoryCellViewModelOutputs {

  init() {
    self.nameLabelText = self.newsCategoryProperty.signal.skipNil().map {
      $0.name
    }
    self.selectionIndicatorHidden = self.isSelectedProperty.signal.skipNil().map {
      !$0
    }
  }

  // MARK: NewsCategoryCellViewModelInputs

  public let nameLabelText: Signal<String, NoError>
  public let selectionIndicatorHidden: Signal<Bool, NoError>

  // MARK: NewsCategoryCellViewModelOutputs

  fileprivate let newsCategoryProperty = MutableProperty<NewsCategory?>(nil)
  fileprivate let isSelectedProperty = MutableProperty<Bool?>(nil)
  public func configureWith(newsCategory: NewsCategory, isSelected: Bool) {
    self.newsCategoryProperty.value = newsCategory
    self.isSelectedProperty.value = isSelected
  }

  // MARK: NewsCategoryCellViewModelType

  public var inputs: NewsCategoryCellViewModelInputs {
    return self
  }
  public var outputs: NewsCategoryCellViewModelOutputs {
    return self
  }
}
