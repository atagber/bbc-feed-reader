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

  public func fetchNewsPosts(forCategory category: NewsCategory) -> SignalProducer<[NewsPost], BBCError> {
    let producer: SignalProducer<[NewsPost], BBCError> = self.request(Route.routeFor(category: category))
    return producer.map { newsPosts in
      return newsPosts.map { newsPost in
        newsPost.changed(newsCategory: category)
      }
    }
  }

  /// This params will be passed with every request to API (e.g. auth token)
  private var defaultParams: [String: String] {
    return [:]
  }

  /// This headers will be passed with every request to API (e.g. language, client version)
  private var defaultHeaders: [String: String] {
    return [:]
  }

  private func preparedRequest(_ route: Route) -> URLRequest {
    let properties = route.requestProperties

    let url = self.serverConfig.apiBaseUrl.appendingPathComponent(properties.path)
    let request = preparedRequest(url: url, method: properties.method, params: properties.params)

    return request
  }

  private func preparedRequest(url: URL, method: Method = .GET, params: [String: Any] = [:]) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request = self.preparedRequest(request: request, params: params)
    return request
  }

  private func preparedRequest(request originalRequest: URLRequest,
                               params originalParams: [String: Any] = [:]) -> URLRequest {
    var request = originalRequest

    guard let URL = request.url else {
      return originalRequest
    }

    var components = URLComponents(url: URL, resolvingAgainstBaseURL: false)!
    var params = components.queryItems ?? []
    params.append(contentsOf: self.defaultParams.map {
      URLQueryItem(name: $0, value: $1)
    })
    params.append(contentsOf: originalParams.map {
      URLQueryItem(name: $0, value: String(describing: $1))
    })
    components.queryItems = params

    request.url = components.url

    var headers = request.allHTTPHeaderFields ?? [:]
    self.defaultHeaders.forEach {
      headers[$0] = $1
    }
    request.allHTTPHeaderFields = headers

    return request
  }

  private func request<M:Parsable>(_ route: Route) -> SignalProducer<[M], BBCError> where M == M.ParsedType {

    let request = preparedRequest(route)

    let dataProducer = self.session.reactive.data(with: request)
      .mapError { _ in
        BBCError(code: .internetConnectionFailed)
      }
      .flatMap(FlattenStrategy.merge) { (result: (data: Data, response: URLResponse))
          -> SignalProducer<Data, BBCError> in
        let httpResponse = result.response as! HTTPURLResponse
        let code = httpResponse.statusCode

        NSLog("\(request.httpMethod ?? "") [\(request.url?.absoluteString ?? "")] -->  Response with code = \(code)")

        switch code {
        case _ where (200 ..< 300).contains(code):
          return SignalProducer(value: result.data)
        case _ where (300 ..< 400).contains(code):
          return SignalProducer(error: BBCError(code: .redirection))
        case _ where (400 ..< 500).contains(code):
          return SignalProducer(error: BBCError(code: .clientError))
        case _ where (500 ..< 600).contains(code):
          return SignalProducer(error: BBCError(code: .serverError))
        default:
          return SignalProducer(error: BBCError(code: .unknownError))
        }
      }

    return dataProducer.flatMap(.merge, transform: self.parse)
  }

  private func parse<M:Parsable>(data: Data) -> SignalProducer<[M], BBCError> where M == M.ParsedType {
    return SignalProducer<Data, NoError>(value: data).map { data in
        M.parse(data)
      }
      .flatMap(.merge) { (parsed: Parsed<[M]>) -> SignalProducer<[M], BBCError> in
        switch parsed {
        case let .success(value):
          return SignalProducer(value: value)
        case .failure:
          return SignalProducer(error: BBCError(code: .parsingFailed))
        }
      }
  }
}
