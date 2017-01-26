import Foundation

enum Strings {
  case news
  case yesterday
  case today
  case favorites
  case top_stories
  case world
  case united_kingdom
  case business
  case politics
  case health
  case education_and_family
  case science_and_environment
  case technology
  case entertainment_and_arts
  case there_are_no_items_to_show
  case downloading_please_wait
  case an_error_occurred_please_try_again_later
  case are_you_sure_you_want_to_delete_this_post
  case delete_post
  case cancel
  
  // TODO: use LocalizedString
  var localized: String {
    switch self {
    case .news:
      return "News"
    case .yesterday:
      return "Yesterday"
    case .today:
      return "Today"
    case .favorites:
      return "Favorites"
    case .top_stories:
      return "Top Stories"
    case .world:
      return "World"
    case .united_kingdom:
      return "United Kingdom"
    case .business:
      return "Business"
    case .politics:
      return "Politics"
    case .health:
      return "Health"
    case .education_and_family:
      return "Education and family"
    case .science_and_environment:
      return "Science and environment"
    case .technology:
      return "Technology"
    case .entertainment_and_arts:
      return "Entertainment and arts"
    case .there_are_no_items_to_show:
      return "There are no items to show"
    case .downloading_please_wait:
      return "Downloading... Please wait"
    case .an_error_occurred_please_try_again_later:
      return "An error occurred. Please try again later"
    case .are_you_sure_you_want_to_delete_this_post:
      return "Are you sure you want to delete this post?"
    case .delete_post:
      return "Delete post"
    case .cancel:
      return "Cancel"
    }
  }
}
