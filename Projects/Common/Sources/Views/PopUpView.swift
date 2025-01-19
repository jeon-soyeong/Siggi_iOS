//
//  PopUpView.swift
//  Common
//
//  Created by 전소영 on 2025/01/06.
//

import SwiftUI

public struct PopUpView: View {
    private var imageName: String?
    private var message: String
    private var leftButtonAction: (() -> Void)?
    private var rightButtonAction: (() -> Void)?
    private var leftButtonImageName: String?
    private var rightButtonImageName: String?
    private var width: CGFloat?
    private var height: CGFloat?

    public init(
        imageName: String? = nil,
        message: String,
        leftButtonAction: (() -> Void)? = nil,
        rightButtonAction: (() -> Void)? = nil,
        leftButtonImageName: String? = nil,
        rightButtonImageName: String? = nil,
        width: CGFloat? = 330,
        height: CGFloat? = 380
    ) {
        self.imageName = imageName
        self.message = message
        self.leftButtonAction = leftButtonAction
        self.rightButtonAction = rightButtonAction
        self.leftButtonImageName = leftButtonImageName
        self.rightButtonImageName = rightButtonImageName
        self.width = width
        self.height = height
    }

    public var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)

            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .stroke(Color(.lightGray), lineWidth: 2)
                .shadow(radius: 10)
                .frame(width: width, height: height)

            VStack {
                if let imageName = imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130, height: 130)
                        .padding()
                }

                Text(message)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()

                HStack {
                    if let leftAction = leftButtonAction,
                       let leftImageName = leftButtonImageName {
                        Button(action: {
                            leftAction()
                        }, label: {
                            Image(leftImageName)
                                .resizable()
                                .frame(width: 130, height: 45)
                        })
                    }

                    if let rightAction = rightButtonAction,
                       let rightImageName = rightButtonImageName {
                        Button(action: {
                            rightAction()
                        }, label: {
                            Image(rightImageName)
                                .resizable()
                                .frame(width: 130, height: 45)
                        })
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    PopUpView(imageName: "", message: "")
}
