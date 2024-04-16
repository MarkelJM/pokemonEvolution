//
//  BaseApiClientV3.swift
//  pokeAPIclousreV2
//
//  Created by Markel Juaristi Mendarozketa   on 19/2/24.
//

import UIKit
import Alamofire
import Combine


class BaseAPIClientV3 {

    private var isReachable: Bool = true
    private var sesionManager: Alamofire.Session!

    private var baseURL: URL {

        if let url = URL(string: "https://pokeapi.co/api/v2/") {
            return url
        } else {
            return URL(string: "")!
        }
    }

    init() {

        // Control para el SSL pinning
//        let serverTrustPolicies: [String: ServerTrustEvaluating] = [
//            "api.myjson.com": PinnedCertificatesTrustEvaluator(),
//            ]
//
//        self.sesionManager = Session(
//            serverTrustManager: ServerTrustManager(evaluators: serverTrustPolicies)
//        )

        self.sesionManager = Session()
        startListenerReachability()
    }


    // MARK: - Public method

    func handler(error: Error?) -> BaseErrorV3? {

        if !self.isReachable { return BaseErrorV3.noInternetConnection }
        var baseError: BaseErrorV3?

        if error != nil {
            baseError = BaseErrorV3.generic
        }

        return baseError
    }
    
    func handleResponse<A: Codable>(success: @escaping (A) -> Void, failure: @escaping (BaseErrorV3) -> Void, dataResponse: AFDataResponse<A>) {
        
        if let baseError = self.handler(error: dataResponse.error)  {
            failure(baseError)
            
        } else if let responseObject: A = dataResponse.value {
            success(responseObject)
            
        } else {
            failure(.generic)
        }
    }

    func request(_ relativePath: String?,
                 method: HTTPMethod = .get,headers: [String: String] = [:],
                 parameters: Parameters? = nil, encoding: ParameterEncoding = JSONEncoding.default) -> DataRequest {

        let urlAbsolute = baseURL.appendingPathComponent(relativePath!)
        return sesionManager.request(urlAbsolute, method: method, parameters: parameters, encoding: encoding, headers: HTTPHeaders(headers)).cURLDescription { p in
             print(p)
        }
    }
    
    func requestPublisher<T: Decodable>(relativePath: String?,
                                        method: HTTPMethod = .get,
                                        parameters: Parameters? = nil,
                                        urlEncoding: ParameterEncoding = JSONEncoding.default,
                                        type: T.Type = T.self,
                                        base: URL? = URL(string: "https://pokeapi.co/api/v2/"),
                                        customHeaders: HTTPHeaders? = nil) -> AnyPublisher<T, BaseErrorV3> {
        
        guard let url = base, let path = relativePath else {
            return Fail(error: BaseErrorV3.generic).eraseToAnyPublisher()
        }
        
        guard let urlAbsolute = url.appendingPathComponent(path).absoluteString.removingPercentEncoding else {
            return Fail(error: BaseErrorV3.generic).eraseToAnyPublisher()
        }

        return sesionManager.request(urlAbsolute, method: method, parameters: parameters, encoding: urlEncoding, headers: nil)
            .validate()
#if DEBUG
            .cURLDescription(on: .main, calling: { p in print(p) })
#endif
            .publishDecodable(type: T.self, emptyResponseCodes: [204])
            .tryMap({ response in
               // print(String(decoding: response.data!, as: UTF8.self))
                switch response.result {
                case let .success(result):
                    return result
                case let .failure(error):
                    // print(String(decoding: response.data!, as: UTF8.self))
                    return error as! T
                }
            })
            .mapError({ [weak self] error in
                guard let self = self else { return .generic }
                return self.handler(error: error) ?? .generic
            })
            .eraseToAnyPublisher()
    }

    // MARK: - Private Method

    private func startListenerReachability() {

        let net = NetworkReachabilityManager()
        net?.startListening(onUpdatePerforming: {  status in
            if net?.isReachable ?? false {
                self.isReachable = true

            } else {
                self.isReachable = false
            }
        })
    }

}
