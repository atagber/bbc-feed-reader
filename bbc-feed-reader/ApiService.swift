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
  
  /// This params will be passed with every request to API (e.g. auth token)
  private var defaultParams: [String:String] {
    return [:]
  }
  
  /// This headers will be passed with every request to API (e.g. language, client version)
  private var defaultHeaders: [String:String] {
    return [:]
  }
  
  private func preparedRequest(_ route: Route) -> URLRequest {
    let properties = route.requestProperties
    
    let url = self.serverConfig.apiBaseUrl.appendingPathComponent(properties.path)
    let request = preparedRequest(url: url, method: properties.method, params: properties.params)
    
    return request
  }
  
  private func preparedRequest(url: URL, method: Method = .GET, params: [String:Any] = [:]) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request = self.preparedRequest(request: request, params: params)
    return request
  }
  
  private func preparedRequest(request originalRequest: URLRequest, params originalParams: [String:Any] = [:]) -> URLRequest {
    var request = originalRequest
    
    guard let URL = request.url else {
      return originalRequest
    }
    
    var components = URLComponents(url: URL, resolvingAgainstBaseURL: false)!
    var params = components.queryItems ?? []
    params.append(contentsOf: self.defaultParams.map {URLQueryItem(name:$0, value:$1)})
    params.append(contentsOf: originalParams.map {URLQueryItem(name:$0, value:String(describing: $1))})
    components.queryItems = params
    
    request.url = components.url
    
    var headers = request.allHTTPHeaderFields ?? [:]
    self.defaultHeaders.forEach { headers[$0] = $1 }
    request.allHTTPHeaderFields = headers
    
    return request
  }
}
