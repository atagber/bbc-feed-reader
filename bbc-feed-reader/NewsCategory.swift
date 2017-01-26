import Foundation

public enum NewsCategory: Int {
  case topStories
  case world
  case unitedKingdom
  case business
  case politics
  case health
  case educationAndFamily
  case scienceAndEnvironment
  case technology
  case entertainmentAndArts
  
  public var name: String {
    switch self {
    case .topStories:
      return "Top Stories" // TODO: localize
    case .world:
      return "World" // TODO: localize
    case .unitedKingdom:
      return "United Kingdom" // TODO: localize
    case .business:
      return "Business" // TODO: localize
    case .politics:
      return "Politics" // TODO: localize
    case .health:
      return "Health" // TODO: localize
    case .educationAndFamily:
      return "Education and family" // TODO: localize
    case .scienceAndEnvironment:
      return "Science and environment" // TODO: localize
    case .technology:
      return "Technology" // TODO: localize
    case .entertainmentAndArts:
      return "Entertainment and arts" // TODO: localize
    }
  }
}
