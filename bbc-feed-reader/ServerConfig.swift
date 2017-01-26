import Foundation

public struct ServerConfig {
  public let apiBaseUrl: URL

  public static let production: ServerConfig = ServerConfig(
    apiBaseUrl: URL(string: Secrets.productionServerBaseURL.rawValue)!
  )

  public static let staging: ServerConfig = ServerConfig(
    apiBaseUrl: URL(string: Secrets.stagingServerBaseURL.rawValue)!
  )
}
