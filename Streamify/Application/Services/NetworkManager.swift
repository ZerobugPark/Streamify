//
//  NetworkManager.swift
//  TestStreamify
//
//  Created by 조다은 on 3/21/25.
//

import Foundation
import RxSwift

enum APIError: Error {
    case invalidURL
    case network
    case decodingError
    case noData
    case unauthorized
    case forbidden
    case notFound
    case rateLimited
    case serverError
    case unknown

    init(httpCode: Int) {
        switch httpCode {
        case 401:
            self = .unauthorized
        case 403:
            self = .forbidden
        case 404:
            self = .notFound
        case 429:
            self = .rateLimited
        case 500...599:
            self = .serverError
        default:
            self = .unknown
        }
    }
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}

    func request<T: Decodable>(api: TMDBRequest, type: T.Type) -> Single<Result<T, APIError>> {
        return Single.create { single in
            guard let request = api.asURLRequest() else {
                single(.success(.failure(.invalidURL)))
                return Disposables.create()
            }

            let task = URLSession.shared.dataTask(with: request) { data, response, error in

                if let error = error {
                    print("Network Error: \(error.localizedDescription)")
                    single(.success(.failure(.network)))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    single(.success(.failure(.unknown)))
                    return
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    let status = httpResponse.statusCode
                    single(.success(.failure(APIError(httpCode: status))))
                    return
                }

                guard let data = data else {
                    single(.success(.failure(.noData)))
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    single(.success(.success(decoded)))
                } catch {
                    print("Decoding Error: \(error)")
                    single(.success(.failure(.decodingError)))
                }
            }

            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}
