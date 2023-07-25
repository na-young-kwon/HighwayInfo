//
//  RouterManager.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/07/24.
//

import Alamofire
import RxSwift
import Foundation

struct RouterManager<T: Router> {
    private let alamofireSession: Session
    private let interceptor: Interceptor?
    
    init(alamofireSession: Session = .default, interceptor: Interceptor? = nil) {
        self.alamofireSession = alamofireSession
        self.interceptor = interceptor
    }
    
    func request(router: T) -> Single<Data> {
        return sendRequest(router: router)
    }
}

extension RouterManager {
    func sendRequest(router: T) -> Single<Data> {
        return Single.create(subscribe: { single in
            let dataRequest: DataRequest = makeDataRequest(router: router)
            
            dataRequest
                .responseData { response in
                    switch response.result {
                    case .success:
                        guard let statusCode = response.response?.statusCode else { return }
                        let isSuccessful = (200..<300).contains(statusCode)
                        
                        if isSuccessful {
                            guard let data = response.data else { return }
                            single(.success(data))
                        } else {
                            let error = RouterManagerError(code: .isNotSuccessful)
                            single(.failure(error))
                        }
                    case .failure(let underlyingError):
                        let error = RouterManagerError(
                            code: .failedRequest,
                            underlying: underlyingError,
                            response: response
                        )
                        single(.failure(error))
                    }
                }
            return Disposables.create()
        })
    }
    
    private func makeDataRequest(router: Router) -> DataRequest {
        switch router.task {
        case .requestPlain:
            return self.alamofireSession.request(
                "\(router.baseURL)\(router.path)",
                method: router.method,
                headers: HTTPHeaders(headers: router.headers),
                interceptor: interceptor
            )
            
        case .requestJSONEncodable(let parameters):
            return self.alamofireSession.request(
                "\(router.baseURL)\(router.path)",
                method: router.method,
                parameters: parameters,
                interceptor: interceptor
            )
            
        case .requestParameters(parameters: let parameters):
            return self.alamofireSession.request(
                "\(router.baseURL)\(router.path)",
                method: router.method,
                parameters: parameters,
                interceptor: interceptor
            )
        }
    }
}

extension HTTPHeaders {
    init?(headers: [String: String]?) {
        guard let headers = headers else {
            return nil
        }
        self.init(headers)
    }
}
