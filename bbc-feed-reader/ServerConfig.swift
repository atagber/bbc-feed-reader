import Foundation

public struct ServerConfig {
  public let apiBaseUrl: URL

  public static let production: ServerConfig = ServerConfig(
    // TODO: move link to secrets
    apiBaseUrl: URL(string: "http://feeds.bbci.co.uk/")!
  )

  public static let staging: ServerConfig = ServerConfig(
    // TODO: use staging base url
    // TODO: move link to secrets
    apiBaseUrl: URL(string: "http://feeds.bbci.co.uk/")!
  )
}
