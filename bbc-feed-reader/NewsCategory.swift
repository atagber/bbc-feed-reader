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
      return Strings.top_stories.localized
    case .world:
      return Strings.world.localized
    case .unitedKingdom:
      return Strings.united_kingdom.localized
    case .business:
      return Strings.business.localized
    case .politics:
      return Strings.politics.localized
    case .health:
      return Strings.health.localized
    case .educationAndFamily:
      return Strings.education_and_family.localized
    case .scienceAndEnvironment:
      return Strings.science_and_environment.localized
    case .technology:
      return Strings.technology.localized
    case .entertainmentAndArts:
      return Strings.entertainment_and_arts.localized
    }
  }

  public static let allCategories: [NewsCategory] =
    [.topStories, .world, .unitedKingdom, .business, .politics, .health,
     .educationAndFamily, .scienceAndEnvironment, .technology, .entertainmentAndArts]
}
