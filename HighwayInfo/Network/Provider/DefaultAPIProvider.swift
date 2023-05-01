//
//  DefaultAPIProvider.swift
//  HighwayInfo
//
//  Created by 권나영 on 2023/03/07.
//

import Foundation
import RxSwift

enum DecodeType {
    case accident, cctv, serviceArea, gasStation, gasPrice, json
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
                        observer.onError(NetworkingError.parsingError)
                        return
                    }
                    observer.onNext(decoded)
                    observer.onCompleted()
                    
                case .cctv:
                    let parser = CCTVParser(data: data)
                    guard let decoded = parser.parseXML() as? T.Response else {
                        observer.onError(NetworkingError.parsingError)
                        return
                    }
                    observer.onNext(decoded)
                    observer.onCompleted()
                    
                case .serviceArea:
                    let parser = ServiceAreaParser(data: data)
                    guard let decoded = parser.parseXML() as? T.Response else {
                        observer.onError(NetworkingError.parsingError)
                        return
                    }
                    observer.onNext(decoded)
                    observer.onCompleted()
                    
                case .gasStation:
                    let parser = GasStationParser(data: data)
                    guard let decoded = parser.parseXML() as? T.Response else {
                        observer.onError(NetworkingError.parsingError)
                        return
                    }
                    observer.onNext(decoded)
                    observer.onCompleted()
                    
                case .gasPrice:
                    let parser = GasPriceParser(data: data)
                    guard let decoded = parser.parseXML() as? T.Response else {
                        observer.onError(NetworkingError.parsingError)
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
    
    func performPostDataTask<T: APIRequest>(_ data: Encodable, with requestType: T) -> Observable<T.Response> {
        guard let url = requestType.url,
              let httpBody = self.createPostPayload(from: data) else {
            return Observable.error(NetworkingError.invalidRequest)
        }
        return Observable.create { observer in
            let request = self.createRequestPost(of: url,
                                                 with: ["Content-Type": "application/json",
                                                        "appKey": "XdvNDcFXsW9TcheSg1zN7YiDmu1bN6o9N3Mvxooj"],
                                                 httpMethod: .post,
                                                 with: httpBody)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
                guard let decoded = try? JSONDecoder().decode(T.Response.self, from: data) else {
                    observer.onError(NetworkingError.parsingError)
                    return
                }
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

private extension DefaultAPIProvider {
    func createPostPayload(from requestBody: Encodable) -> Data? {
        return try? JSONEncoder().encode(requestBody)
    }
    
    func createRequestPost(of url: URL,
                           with headers: [String: String]?,
                           httpMethod: HTTPMethod,
                           with body: Data? = nil
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        headers?.forEach({ header in
            request.addValue(header.value, forHTTPHeaderField: header.key)
        })
        if let body = body {
            request.httpBody = body
        }
        return request
    }
}
