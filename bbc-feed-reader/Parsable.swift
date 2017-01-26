import Foundation

internal protocol Parsable {
  associatedtype ParsedType = Self
  
  static func parse(_ data: Data) -> Parsed<[Self]>
}

public enum Parsed<T> {
  case success(T)
  case failure(BBCError)
}

public extension Parsed {
  var value: T? {
    switch self {
    case let .success(value): return value
    case .failure: return .none
    }
  }
  
  var error: BBCError? {
    switch self {
    case .success: return .none
    case let .failure(error): return error
    }
  }
}
