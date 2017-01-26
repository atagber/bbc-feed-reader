import Foundation

extension String {
  static func isEmptyAfterTrimming(_ string: String?) -> Bool {
    guard let string = String.trim(string) else {
      return true
    }
    return string.isEmpty
  }

  static func trim(_ string: String?) -> String? {
    guard let string = string else {
      return nil
    }
    return string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
  }
}
