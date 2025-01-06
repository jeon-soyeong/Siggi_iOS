//
//  PopUpView.swift
//  Common
//
//  Created by 전소영 on 2025/01/06.
//

import SwiftUI

public struct PopUpView: View {
    var imageName: String
    var message: String

    public init(
        imageName: String,
        message: String
    ) {
        self.imageName = imageName
        self.message = message
    }

    public var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)

            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .stroke(Color(.lightGray), lineWidth: 2)
                .shadow(radius: 10)
                .frame(width: 330, height: 380)

            VStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 130)
                    .padding()

                Text(message)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }
}

#Preview {
    PopUpView(imageName: "", message: "")
}
