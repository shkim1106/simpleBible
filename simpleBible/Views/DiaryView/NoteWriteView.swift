//
//  NoteWriteView.swift
//  simpleBible
//
//  Created by shkim on 3/7/25.
//

import SwiftUI

struct NoteWriteView: View {
    @State private var title: String = ""
    @State private var content: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // 노트 제목(TextField)
                TextField("제목을 입력하세요", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // 노트 본문(TextEditor) - iOS 14+
                TextEditor(text: $content)
                    .frame(minHeight: 200) // 본문 영역 높이 지정
                    .padding(.horizontal)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                
                // 저장 버튼
                Button(action: {
                    // 실제 저장 로직(예: CoreData, API, UserDefaults 등)
                    print("노트 저장: \(title)\n\(content)")
                }) {
                    Text("저장")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.blue.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding(.vertical)
            .navigationTitle("새 노트 작성")
        }
    }
}
