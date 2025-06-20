//
//  URLSessionProtocol.swift
//  Siggi
//
//  Created by 전소영 on 2024/09/09.
//

import Foundation

public protocol URLSessionProtocol {
    func getData(for request: URLRequest) async throws -> (Data, URLResponse)
}
