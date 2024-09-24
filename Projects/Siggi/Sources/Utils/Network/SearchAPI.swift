//
//  SearchAPI.swift
//  Siggi
//
//  Created by 전소영 on 2024/09/19.
//

import Foundation

public enum SearchAPI: EndPointType {
    case searchPlace(query: String, page: Int, size: Int)

    public var httpMethod: HTTPMethod {
        switch self {
        case .searchPlace:
            return .get
        }
    }

    public var baseURL: String {
        return APIConstants.baseURL
    }

    public var path: String {
        switch self {
        case .searchPlace:
            return "/v2/local/search/keyword"
        }
    }

    public var query: [URLQueryItem]? {
        switch self {
        case .searchPlace(let query, let page, let size):
            return [URLQueryItem(name: "query", value: "\(query)"),
                    URLQueryItem(name: "category_group_code", value: "FD6"),
                    URLQueryItem(name: "page", value: "\(page)"),
                    URLQueryItem(name: "size", value: "\(size)")]
        }
    }

    public var headers: [String: String]? {
        switch self {
        case .searchPlace:
            return ["Authorization": "KakaoAK \(APIConstants.restAPIKey)"]
        }
    }
}
