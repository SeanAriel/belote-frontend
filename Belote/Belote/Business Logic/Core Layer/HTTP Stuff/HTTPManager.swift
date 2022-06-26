//
//  HTTPManager.swift
//  Belote
//
//  Created by Sitora Guliamova on 26.05.2022.
//

import Foundation

enum HTTPManagerError: Error {
    case otherError(Error)
    case parseError
    case badURL
}

protocol HTTPManagerProtocol {
    func fetch<QueryObject: Encodable, RequestObject: Encodable, Response: Decodable>(
        request: HTTPRequest<QueryObject, RequestObject>,
        responseType: Response.Type,
        completion: @escaping (Result<Response, Error>) -> Void
    )
}

final class HTTPManager: HTTPManagerProtocol {
    func fetch<QueryObject: Encodable, RequestObject: Encodable, Response: Decodable>(
        request: HTTPRequest<QueryObject, RequestObject>,
        responseType: Response.Type,
        completion: @escaping (Result<Response, Error>) -> Void
    ) {
        func onSuccess(_ response: Response) { completion(.success(response)) }
        func onError(_ error: HTTPManagerError) { completion(.failure(error)) }

        guard let url = URL(string: request.url)?
                .ajustedWithQuery(request.queryObject?.queryDictionary ?? [:])
        else { return onError(.badURL) }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.stringValue
        urlRequest.httpBody = request.body.flatMap { try? JSONEncoder().encode($0) }

        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let error = error { return onError(.otherError(error)) }
            guard let data = data,
                  let resultObject = try? JSONDecoder().decode(responseType, from: data)
            else { return onError(.parseError) }

            return onSuccess(resultObject)
        }.resume()
    }
}

extension HTTPRequest.Method {
    fileprivate var stringValue: String {
        switch self {
        case .get: return "GET"
        case .put: return "PUT"
        case .post: return "POST"
        }
    }
}

extension URL {
    fileprivate func ajustedWithQuery(_ query: [String: String?]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        let ajustedQuery = queryItems + query.map { URLQueryItem(name: $0.key, value: $0.value) }
        components?.queryItems = ajustedQuery

        return components?.url
    }
}

extension Encodable {
    // Далеко не самое лучшее решение, конечно правильно будет использовать отдельный query-encoder для этого
    // Но время никак не позволяет =(
    // Пока что это решение нормально работает со строками и числами
    fileprivate var queryDictionary: [String: String?]? {
        guard let data = try? JSONEncoder().encode(self),
              let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
              let dict = jsonObject as? [String: Any] else { return nil }

        return dict.mapValues { "\($0)" }
    }
}
