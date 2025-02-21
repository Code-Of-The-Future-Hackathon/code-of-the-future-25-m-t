//
//  CustomError.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import Foundation

enum CustomError: Error {
    case backend(BackendError)
    case unrecognized(String)
}

enum BackendError: String {
    case other = "Unknown error occurred"
    
    var errorMessage: String {
        switch self {
        case .other:
            return "Unknown error occurred"
        }
    }
}

extension Error {
    func customErrorMessage(_ defaultMessage: String) -> String {
        var requestErrorMessage: String = defaultMessage
        if let customError = self as? CustomError {
            switch customError {
            case let .backend(backendError):
                requestErrorMessage = backendError.errorMessage
            case .unrecognized:
                break
            }
        } else if let afError = self.asAFError,
                  case let .requestRetryFailed(retryError, _) = afError {
            var customError: CustomError?
            if let failError = retryError as? CustomError {
                customError = failError
            } else if let backendError = retryError.asAFError,
                      case let .requestRetryFailed(underlyingError, _) = backendError,
                      let offlineError = underlyingError as? CustomError {
                customError = offlineError
            }
            guard let customError = customError else { return requestErrorMessage}
            switch customError {
            case let .backend(backendError):
                requestErrorMessage = backendError.errorMessage
            case .unrecognized:
                requestErrorMessage = defaultMessage
            }
        }
        return requestErrorMessage
    }
}
