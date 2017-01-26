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
}
