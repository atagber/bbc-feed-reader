import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result

public protocol NewsCategoriesViewModelInputs {

  func configureWith(categories: [NewsCategory])

  /// it is called from outside of view
  func select(category: NewsCategory)

  func categoryCellTapped(index: Int)

  func viewDidLoad()
}

public protocol NewsCategoriesViewModelOutputs {

  var notifyDelegateOfSelectedCategory: Signal<NewsCategory, NoError> { get }

  var updateCategoriesList: Signal<[NewsCategory], NoError> { get }

  var selectedCategory: Signal<NewsCategory, NoError> { get }
}

public protocol NewsCategoriesViewModelType {

  var inputs: NewsCategoriesViewModelInputs { get }
  var outputs: NewsCategoriesViewModelOutputs { get }
}

public class NewsCategoriesViewModel: NewsCategoriesViewModelType, NewsCategoriesViewModelInputs,
  NewsCategoriesViewModelOutputs {

  init() {

    // wait for viewDidLoad
    self.updateCategoriesList = Signal.combineLatest(self.viewDidLoadProperty.signal, self.categoriesProperty.signal)
      .map { _, categories in
        categories
      }

    let categoriesProperty = self.categoriesProperty
    let categoryWasTapped = self.categoryCellTappedIndexProperty.signal.skipNil().map {
      categoriesProperty.value[$0]
    }

    self.selectedCategory = Signal.merge([categoryWasTapped,
                                          self.selectCategoryProperty.signal.skipNil()])

    self.notifyDelegateOfSelectedCategory = categoryWasTapped //self.selectedCategory
  }

  // MARK: NewsCategoriesViewModelInputs

  fileprivate let categoriesProperty = MutableProperty<[NewsCategory]>([])
  public func configureWith(categories: [NewsCategory]) {
    self.categoriesProperty.value = categories
  }
  fileprivate let selectCategoryProperty = MutableProperty<NewsCategory?>(nil)
  public func select(category: NewsCategory) {
    self.selectCategoryProperty.value = category
  }
  fileprivate let categoryCellTappedIndexProperty = MutableProperty<Int?>(nil)
  public func categoryCellTapped(index: Int) {
    self.categoryCellTappedIndexProperty.value = index
  }
  fileprivate let viewDidLoadProperty = MutableProperty()
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  // MARK: NewsCategoriesViewModelOutputs

  public let notifyDelegateOfSelectedCategory: Signal<NewsCategory, NoError>
  public let updateCategoriesList: Signal<[NewsCategory], NoError>
  public let selectedCategory: Signal<NewsCategory, NoError>

  // MARK: NewsCategoriesViewModelType

  public var inputs: NewsCategoriesViewModelInputs {
    return self
  }
  public var outputs: NewsCategoriesViewModelOutputs {
    return self
  }
}
