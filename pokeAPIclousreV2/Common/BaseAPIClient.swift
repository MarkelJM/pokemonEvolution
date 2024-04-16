//
//  BaseAPIClient.swift
//  pokeAPIclousreV2
//
//  Created by Markel Juaristi Mendarozketa   on 12/2/24.
//



import Foundation
import Alamofire

class BaseAPIClient {
    let sessionManager = Alamofire.Session()
    
    
    
    func request(_ url: URL, method: HTTPMethod = .get, parameters: Parameters? = nil, completion: @escaping (Result<Data, Error>) -> Void) {
        sessionManager.request(url, method: method, parameters: parameters, encoding: URLEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


