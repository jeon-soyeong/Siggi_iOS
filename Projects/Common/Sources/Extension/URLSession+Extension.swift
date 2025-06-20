//
//  URLSession+Extension.swift
//  Siggi
//
//  Created by 전소영 on 2024/09/09.
//

import Foundation

extension URLSession: URLSessionProtocol {
    public func getData(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request)
    }
}
