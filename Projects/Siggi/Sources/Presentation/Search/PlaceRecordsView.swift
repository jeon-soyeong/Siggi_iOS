//
//  PlaceRecordsView.swift
//  Siggi
//
//  Created by 전소영 on 2025/01/08.
//

import SwiftUI

struct PlaceRecordsView: View {
    @Binding var record: [PlaceRecord]?

    var body: some View {
        VStack {
            ScrollView {
                if let record = record {
                    ForEach(record.indices, id: \.self) { index in
                        Text(record[index].name)
                            .font(.largeTitle)
                        //                     추가적인 레코드 정보 표시
                        Button("닫기") {

                        }
                    }
                }
            }
        }
        .padding()
    }
}
