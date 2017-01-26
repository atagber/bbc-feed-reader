import Foundation

extension Date {
  func dateToStringForNewsPost() -> String {
    let calendar = Calendar.current
    if calendar.isDateInYesterday(self) {
      return Strings.yesterday.localized
    } else if calendar.isDateInToday(self) {
      return Strings.today.localized
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMMM yyyy"
    return formatter.string(from: self)
  }

  func timeToStringForNewsPost() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: self)
  }

  static func parseApiDate(from string: String?) -> Date? {
    guard let string = string else {
      return nil
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
    formatter.locale = Locale(identifier: "en_US")

    return formatter.date(from: string)
  }
}

extension NSDate {
  var date: Date {
    return Date(timeIntervalSince1970: self.timeIntervalSince1970)
  }
}

extension Date {
  var nsDate: NSDate {
    return NSDate(timeIntervalSince1970: self.timeIntervalSince1970)
  }
}
