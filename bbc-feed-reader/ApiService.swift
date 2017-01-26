import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result

public class ApiService {
  public let serverConfig: ServerConfig
  private let session: URLSession
  
  public init(serverConfig: ServerConfig = ServerConfig.production) {
    self.serverConfig = serverConfig
    
    let config = URLSessionConfiguration.default
    config.requestCachePolicy = .reloadIgnoringLocalCacheData
    self.session = URLSession(configuration: config)
  }
}
