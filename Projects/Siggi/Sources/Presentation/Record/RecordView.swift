//
//  RecordView.swift
//  Siggi
//
//  Created by 전소영 on 2024/07/02.
//

import SwiftUI
import Common

public struct RecordView: View {
    @Bindable var recordRouter: Router
    
    public var body: some View {
        NavigationStack(path: $recordRouter.route) {
            Text("RecordView!")
            
            Button(action: {
                recordRouter.pushView(screen: RecordScreen.recordDetail(recordText: "recordTest"))
            }, label: {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .foregroundStyle(.gray)
            })
            
            .navigationDestination(for: RecordScreen.self) { screen in
                switch screen {
                    case .recordDetail(let recordText):
                    RecordDetailView(recordText: "test~!")
                }
            }
        }
    }
}

#Preview {
    RecordView(recordRouter: Router())
}

//test
struct RecordDetailView: View {
    @Environment(Router.self) private var recordRouter: Router
    var recordText: String = ""
    
    var body: some View {
        Text("RecordDetailView!")
        Text(recordText)
    }
}
