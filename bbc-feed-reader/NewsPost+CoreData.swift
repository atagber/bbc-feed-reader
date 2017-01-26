import Foundation

internal extension NewsPost {
  internal static func build(from managedObject: NewsPostMO) -> NewsPost? {
    guard let identifier = managedObject.identifier,
      let title = managedObject.title,
      let summary = managedObject.summary,
      let publicationDate = managedObject.publicationDate?.date,
      let newsCategory = NewsCategory(rawValue: Int(managedObject.categoryId)),
      let imageURLString = managedObject.imageURL,
      let sourceURLString = managedObject.sourceURL
      else {
        return nil
    }
    let isFavorite = managedObject.isFavorite
    let isChanged = managedObject.isChanged
    let isRemoved = managedObject.isRemoved
    let isCustom = managedObject.isCustom
    
    return NewsPost(newsCategory: newsCategory,
                    identifier: identifier,
                    isFavorite: isFavorite,
                    isChanged: isChanged,
                    isRemoved: isRemoved,
                    isCustom: isCustom,
                    publicationDate: publicationDate,
                    imageURLString: imageURLString,
                    sourceURLString: sourceURLString,
                    summary: summary,
                    title: title)
  }
  
  internal func sync(managedObject: NewsPostMO) {
    managedObject.title = self.title
    managedObject.categoryId = Int16(self.newsCategory.rawValue)
    managedObject.summary = self.summary
    managedObject.isChanged = self.isChanged
    managedObject.isRemoved = self.isRemoved
    managedObject.isCustom = self.isCustom
    managedObject.isFavorite = self.isFavorite
    managedObject.imageURL = self.imageURLString
    managedObject.sourceURL = self.sourceURLString
    managedObject.identifier = self.identifier
    managedObject.publicationDate = self.publicationDate.nsDate
  }
}
