import Foundation

public struct BBCError {
  let code: BBCErrorCode
  
  public enum BBCErrorCode: String {
    case parsingFailed
    case databaseSavingFailed
    case internetConnectionFailed
    case redirection
    case clientError
    case serverError
    case unknownError
  }
}

extension BBCError: Swift.Error {
}
