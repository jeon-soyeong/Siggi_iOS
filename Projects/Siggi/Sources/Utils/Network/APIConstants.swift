//
//  APIConstants.swift
//  Common
//
//  Created by 전소영 on 2024/09/09.
//

import Foundation

public struct APIConstants {
    static let baseURL = "https://dapi.kakao.com"

    static var restAPIKey: String {
        guard let filePath = Bundle.main.path(forResource: "Key", ofType: "plist") else {
            return ""
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "restAPIKey") as? String else {
            return ""
        }
        return value
    }
}
