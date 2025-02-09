//
//  APIError.swift
//  Common
//
//  Created by 전소영 on 2024/09/09.
//

import Foundation

public enum APIError: Error {
    case failedData
    case failedDecode
    case failedRequest

    public var description: String {
        switch self {
        case .failedRequest:
            return "데이터 요청 실패입니다."
        case .failedData:
            return "데이터 처리 실패입니다."
        case .failedDecode:
            return "디코딩에 실패했습니다."
        }
    }
}
