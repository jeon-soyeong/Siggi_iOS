//
//  SearchAPI.swift
//  Siggi
//
//  Created by 전소영 on 2024/09/19.
//

import Foundation
import Common

enum SearchAPI: EndPointType {
    case searchPlace(query: String, page: Int, size: Int)

    var httpMethod: HTTPMethod {
        switch self {
        case .searchPlace:
            return .get
        }
    }

    var baseURL: String {
        return APIConstants.baseURL
    }

    var path: String {
        switch self {
        case .searchPlace:
            return "/v2/local/search/keyword"
        }
    }

    var query: [URLQueryItem]? {
        switch self {
        case .searchPlace(let query, let page, let size):
            return [URLQueryItem(name: "query", value: "\(query)"),
                    URLQueryItem(name: "category_group_code", value: "FD6"),
                    URLQueryItem(name: "page", value: "\(page)"),
                    URLQueryItem(name: "size", value: "\(size)")]
        }
    }

    var headers: [String: String]? {
        switch self {
        case .searchPlace:
            return ["Authorization": "KakaoAK \(APIConstants.restAPIKey)"]
        }
    }
}
