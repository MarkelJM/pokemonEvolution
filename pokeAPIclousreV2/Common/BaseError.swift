//
//  BaseError.swift
//  pokeAPIclousreV2
//
//  Created by Markel Juaristi Mendarozketa   on 12/2/24.
//

import Foundation


enum BaseError: Error {
    case noInternetConnection
    case notFound
    case unauthorized
    case serverError
    case decodingError
    case unknown
    case customError(String)

    var description: String {
        switch self {
        case .noInternetConnection:
            return "No internet connection."
        case .notFound:
            return "The requested item was not found."
        case .unauthorized:
            return "Unauthorized access."
        case .serverError:
            return "Server encountered an error."
        case .decodingError:
            return "Failed to decode the response."
        case .unknown:
            return "An unknown error occurred."
        case .customError(let message):
            return message
        }
    }
}
