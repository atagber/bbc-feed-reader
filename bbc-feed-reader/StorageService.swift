import Foundation
import MagicalRecord
import ReactiveCocoa
import ReactiveSwift
import Result

public class StorageService {
  private let newsPostsProperty = MutableProperty<[NewsPost]>([])
  
  public let newsPosts: Signal<[NewsPost], NoError>
  
  init() {
    self.newsPosts = newsPostsProperty.signal
    self.syncAllProperties()
  }
  
  private func syncAllProperties() {
    self.syncNewsPostsProperty()
  }
  
  private func syncNewsPostsProperty() {
    let managedObjects = NewsPostMO.mr_findAll() as? [NewsPostMO] ?? []
    self.newsPostsProperty.value = managedObjects.flatMap(NewsPost.build(from:))
  }
  
  public func fetchNewsPosts(forCategory category: NewsCategory) -> SignalProducer<(success: Bool, error: BBCError?), NoError> {
    return AppEnvironment.current.apiService.fetchNewsPosts(forCategory: category).materialize()
      .filter { $0.value != nil || $0.error != nil }.map { [weak self] event in
        if let error = event.error {
          return (false, error)
        }
        if let value = event.value {
          self?.syncNewsPostsWithDatabase(with: value)
        }
        return (true, nil)
    }
  }
  
  public func save(newsPost: NewsPost) {
    self.syncNewsPostsWithDatabase(with: [newsPost])
  }
  
  private func syncNewsPostsWithDatabase(with newsPosts: [NewsPost]) {
    MagicalRecord.save({ context in
      for newsPost in newsPosts {
        if let managedObject = NewsPostMO.mr_findFirst(with: NSPredicate(format: "identifier = %@", newsPost.identifier), in: context) {
          if newsPost.isChanged || !managedObject.isChanged {
            newsPost.sync(managedObject: managedObject)
          }
        } else if let managedObject = NewsPostMO.mr_createEntity(in: context) {
          newsPost.sync(managedObject: managedObject)
        }
      }
    }) {[weak self] (_, _) in
      self?.syncNewsPostsProperty()
    }
  }
}
