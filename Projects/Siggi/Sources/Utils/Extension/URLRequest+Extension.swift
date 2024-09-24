//
//  URLRequest+Extension.swift
//  Siggi
//
//  Created by 전소영 on 2024/09/09.
//

import Foundation

extension URLRequest {
    init?(type: EndPointType) {
        var components = URLComponents(string: type.baseURL)
        components?.path = type.path
        components?.queryItems = type.query
        
        guard let url = components?.url else {
            return nil
        }
        
        self.init(url: url)
        
        self.httpMethod = type.httpMethod.description
        
        if let headers = type.headers {
            for (key, value) in headers {
                self.setValue(value, forHTTPHeaderField: key)
            }
        }
    }
}

