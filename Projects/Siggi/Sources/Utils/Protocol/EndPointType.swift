//
//  EndPointType.swift
//  Siggi
//
//  Created by 전소영 on 2024/09/09.
//

import Foundation

public enum HTTPMethod: String {
    case get
    case post
    case put
    case delete

    public var description: String {
        switch self {
        case .get:
            return "get"
        case .post:
            return "post"
        case .put:
            return "put"
        case .delete:
            return "delete"
        }
    }
}

public protocol EndPointType {
    var httpMethod: HTTPMethod { get }
    var baseURL: String { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var query: [URLQueryItem]? { get }
}
