import Foundation

public struct AppEnvironment {

  fileprivate static var environments: [Environment] = [Environment()]
  
  public static var current: Environment! {
    return environments.last
  }
}
