//
//  DefaultAPIProvider.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/07.
//

import Foundation
import RxSwift

final class DefaultAPIProvider: APIProvider {
    let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func performDataTask<T: APIRequest>(with requestType: T) -> Observable<T.Response> {
        return Observable.create { observer in
            guard let request = requestType.urlRequest else {
                observer.onError(NetworkingError.invalidRequest)
                return Disposables.create()
            }
            let task = self.session.dataTask(with: request) { data, response, error in
                if error != nil {
                    observer.onError(NetworkingError.serverError)
                    return
                }
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    observer.onError(NetworkingError.invalidResponse)
                    return
                }
                guard let data = data else {
                    observer.onError(NetworkingError.invalidData)
                    return
                }
                // XML
                let parser = XmlParser(data: data)
                guard let decoded = parser.parseXML() as? T.Response else {
                    // [AccidentDTO] 로 형변환 안됨
                    observer.onError(NetworkingError.convertToReponseError)
                    return
                }
                
//                guard let convertedData = jsonString.data(using: .utf8) else {
//                    observer.onError(NetworkingError.convertToDataError)
//                    return
//                }
//
//                guard let decoded = try? JSONDecoder().decode(T.Response.self, from: convertedData) else {
//                    observer.onError(NetworkingError.parsingError)
//                    return
//                }
                
                // 후에 다른 api추가할때 xml이랑 json 구분해서 다시로직짜기
                // Json
//                guard let decoded = try? JSONDecoder().decode(T.Response.self, from: data) else {
//                    observer.onError(NetworkingError.parsingError)
//                    return
//                }
                observer.onNext(decoded)
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
