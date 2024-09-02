//
//  NavigationBar.swift
//  Common
//
//  Created by 전소영 on 2024/08/27.
//

import SwiftUI

public struct NavigationBar: View {
    private let title: String?
    private let backButtonAction: () -> Void
    private var rightButtonAction: (() -> Void)?
    
    public init(
        title: String,
        backButtonAction: @escaping () -> Void = {},
        rightButtonAction: (() -> Void)? = nil
    ) {
        self.backButtonAction = backButtonAction
        self.rightButtonAction = rightButtonAction
        self.title = title
    }
    
    public var body: some View {
        Image("backward")
        
        HStack(spacing: 8) {
            Button(action: {
                backButtonAction()
            }, label: {
                Image(.backward)
                    .resizable()
                    .frame(width: 20, height: 20)
            })
            
            if let title {
                Text(title)
                    .font(.title3)
            }
            
            Spacer()
            
            if let rightAction = rightButtonAction {
                Button(
                    action: {
                        rightAction()
                    },
                    label: {
                        Image(.close)
                            .resizable()
                            .frame(width: 28, height: 28)
                    }
                )
            }
        }
        .frame(height: 40)
        .padding(.horizontal, 14)
    }
}

#Preview {
    NavigationBar(title: "testTitle")
}
