//
//  UIImage+Extension.swift
//  Siggi
//
//  Created by 전소영 on 2024/10/29.
//

import UIKit
import CryptoKit

extension UIImage {
    public func hashValue() -> String? {
        guard let data = self.pngData() else { return nil }
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}
