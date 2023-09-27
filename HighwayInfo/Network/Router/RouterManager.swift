//
//  RouterManager.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/07/24.
//

import Alamofire
import RxSwift
import Foundation

// 집에 있는 라우터를 생각해보면, 하나의 네트워크 선이 라우터를 통해 여러 컴퓨터에 연결할 수도 있고, 와이파이도 만들어준다.
// 이처럼 앱에서도 수많은 API 요청이 발생하는데, Request Router를 통해 모든 요청을 생성할 수 있고, 이를 통해 하나의 파일에서 일관적으로 관리할 수 있다.
// 여기저기 흩어져 있는 서버통신 관련 파일들을 하나로 볼 수 있다면 좋겠다는 생각이 들었다.


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
                            let error = RouterManagerError(code: .isNotSuccessful, response: response)
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
            return alamofireSession.request(
                "\(router.baseURL)\(router.path)",
                method: router.method,
                headers: HTTPHeaders(headers: router.headers),
                interceptor: interceptor
            )
            
        case .requestJSONEncodable(let parameters):
            return alamofireSession.request(
                "\(router.baseURL)\(router.path)",
                method: router.method,
                parameters: parameters,
                encoder: .json,
                headers: HTTPHeaders(headers: router.headers),
                interceptor: interceptor
            )
            
        case .requestParameters(parameters: let parameters):
            return alamofireSession.request(
                "\(router.baseURL)\(router.path)",
                method: router.method,
                parameters: parameters,
                headers: HTTPHeaders(headers: router.headers),
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
