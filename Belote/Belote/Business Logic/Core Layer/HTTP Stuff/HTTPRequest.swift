//
//  HTTPRequest.swift
//  Belote
//
//  Created by Sitora Guliamova on 26.05.2022.
//

import Foundation

struct HTTPRequest<QueryObject, RequestBodyObject> {
    let method: Method
    let url: String
    let queryObject: QueryObject?
    let body: RequestBodyObject?

    private init(
        method: Method,
        url: String,
        queryObject: QueryObject?,
        body: RequestBodyObject?
    ) {
        self.method = method
        self.url = url
        self.queryObject = queryObject
        self.body = body
    }
}

// MARK: - Method

extension HTTPRequest {
    enum Method {
        case get
        case post
        case put
    }
}

// MARK: - Factory

extension HTTPRequest {
    static func makeWithEmptyBodyQuery(
        method: Method,
        url: String
    ) -> HTTPRequest<Empty, Empty> where QueryObject == Empty, RequestBodyObject == Empty {
        .init(method: method, url: url, queryObject: nil, body: nil)
    }

    static func makeWithEmptyBody(
        method: Method,
        url: String,
        queryObject: QueryObject?
    ) -> HTTPRequest<QueryObject, Empty> where RequestBodyObject == Empty {
        .init(method: method, url: url, queryObject: queryObject, body: nil)
    }
}
