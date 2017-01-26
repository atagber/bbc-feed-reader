import Foundation

public struct NewsPost {
  public let newsCategory: NewsCategory
  public let identifier: String
  public let isFavorite: Bool
  public let isChanged: Bool
  public let isRemoved: Bool
  public let isCustom: Bool
  public let publicationDate: Date
  public let imageURLString: String
  public let sourceURLString: String
  public let summary: String
  public let title: String

  init(newsCategory: NewsCategory,
       identifier: String,
       isFavorite: Bool,
       isChanged: Bool,
       isRemoved: Bool,
       isCustom: Bool,
       publicationDate: Date,
       imageURLString: String,
       sourceURLString: String,
       summary: String,
       title: String) {
    self.newsCategory = newsCategory
    self.identifier = identifier
    self.isFavorite = isFavorite
    self.isCustom = isCustom
    self.isChanged = isChanged
    self.isRemoved = isRemoved
    self.title = title
    self.summary = summary
    self.publicationDate = publicationDate
    self.sourceURLString = sourceURLString
    self.imageURLString = imageURLString
  }
  
  init(customForCategory newsCategory: NewsCategory) {
    self.newsCategory = newsCategory
    self.identifier = UUID().uuidString
    self.isFavorite = false
    self.isCustom = true
    self.isChanged = false
    self.isRemoved = false
    self.title = ""
    self.summary = ""
    self.publicationDate = Date()
    self.sourceURLString = ""
    self.imageURLString = ""
  }
  
  func changed(newsCategory: NewsCategory? = nil,
               identifier: String? = nil,
               isFavorite: Bool? = nil,
               isChanged: Bool? = nil,
               isRemoved: Bool? = nil,
               isCustom: Bool? = nil,
               publicationDate: Date? = nil,
               imageURLString: String? = nil,
               sourceURLString: String? = nil,
               summary: String? = nil,
               title: String? = nil) -> NewsPost {
    return NewsPost(newsCategory: newsCategory ?? self.newsCategory,
                         identifier: identifier ?? self.identifier,
                         isFavorite: isFavorite ?? self.isFavorite,
                         isChanged: isChanged ?? self.isChanged,
                         isRemoved: isRemoved ?? self.isRemoved,
                         isCustom: isCustom ?? self.isCustom,
                         publicationDate: publicationDate ?? self.publicationDate,
                         imageURLString: imageURLString ?? self.imageURLString,
                         sourceURLString: sourceURLString ?? self.sourceURLString,
                         summary: summary ?? self.summary,
                         title: title ?? self.title)
  }
}
