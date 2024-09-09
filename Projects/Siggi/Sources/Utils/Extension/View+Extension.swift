//
//  View+Extension.swift
//  Siggi
//
//  Created by 전소영 on 2024/06/11.
//  Copyright © 2024 Siggi. All rights reserved.
//

import SwiftUI

public extension View {
    func serviceDIContainer() -> some View {
        modifier(DIContainerModifier())
    }
}
