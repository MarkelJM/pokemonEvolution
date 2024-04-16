//
//  BaseErrorV3.swift
//  pokeAPIclousreV2
//
//  Created by Markel Juaristi Mendarozketa   on 19/2/24.
//

import Foundation

enum BaseErrorV3: Error {
    case generic
    case noInternetConnection
    
    func description() -> String {
        
        var description: String = ""
        
        switch self {
        case .generic: description = "Error generico"
        case .noInternetConnection: description = "NO hay conexion"
        }
        
        return description
    }
}
