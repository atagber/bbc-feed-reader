import Foundation
import AEXML

extension NewsPost: Parsable {
  internal static func parse(_ data: Data) -> Parsed<[NewsPost]> {
    let document = try? AEXMLDocument(xml: data)
    let parsedXmlElements = document?.root["channel"]["item"].all
    
    guard let xmlElements = parsedXmlElements else {
      return .failure(BBCError(code: .parsingFailed))
    }
    
    let newsPosts: [NewsPost] = xmlElements.flatMap { xmlElement in
      guard let title = xmlElement["title"].value,
        let sourceURLString = xmlElement["link"].value,
        let imageURLString = xmlElement["media:thumbnail"].attributes["url"],
        let identifier = xmlElement["guid"].value,
        let date = Date.parseApiDate(from: xmlElement["pubDate"].value),
        let summary = xmlElement["description"].value else {
          return nil
      }
      return NewsPost(newsCategory: NewsCategory.topStories, // by default
                      identifier: identifier,
                      isFavorite: false,
                      isChanged: false,
                      isRemoved: false,
                      isCustom: false,
                      publicationDate: date,
                      imageURLString: imageURLString,
                      sourceURLString: sourceURLString,
                      summary: summary,
                      title: title)
    }
    return .success(newsPosts)
  }
}
