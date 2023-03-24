//
//  DefaultAPIProvider.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/07.
//

import Foundation
import RxSwift

enum DecodeType {
    case accident, cctv, json
}

final class DefaultAPIProvider: APIProvider {
    let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func performDataTask<T: APIRequest>(with requestType: T, decodeType: DecodeType = .json) -> Observable<T.Response> {
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
                
                switch decodeType {
                case .accident:
                    let parser = AccidentParser(data: data)
                    guard let decoded = parser.parseXML() as? T.Response else {
                        observer.onError(NetworkingError.convertToReponseError)
                        return
                    }
                    observer.onNext(decoded)
                    observer.onCompleted()
                    
                case .cctv:
                    let parser = CCTVParser(data: data)
                    guard let decoded = parser.parseXML() as? T.Response else {
                        observer.onError(NetworkingError.convertToReponseError)
                        return
                    }
                    observer.onNext(decoded)
                    observer.onCompleted()
                    
                case .json:
                    guard let decoded = try? JSONDecoder().decode(T.Response.self, from: data) else {
                        observer.onError(NetworkingError.parsingError)
                        return
                    }
                    observer.onNext(decoded)
                    observer.onCompleted()
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
