import Foundation

public struct Environment {
  
  public let apiService: ApiService
  public let storageService: StorageService
  
  public init(apiService: ApiService = ApiService(), storageService: StorageService = StorageService()) {
    self.apiService = apiService
    self.storageService = storageService
  }
}
