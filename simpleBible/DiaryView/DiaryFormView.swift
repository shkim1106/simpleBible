//
//  DiaryEntryFormView.swift
//  simpleBible
//
//  Created by shkim on 2/11/25.
//

import SwiftUI

// 일기 저장 경로
// diaries/{userId}/entries/{entryId}
// 메인 보관함/유저별ID/모아놓은 상자

struct DiaryFormView: View {
    @EnvironmentObject var firebaseVM: FirebaseVM  // ViewModel 인스턴스를 사용
    @State private var scripture: String = ""
    @State private var content: String = ""
    @State private var prayerTitle: String = ""
    
    @Binding var selectedTab: Int

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                
                TextField("📖 묵상한 말씀", text: $scripture)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("🙏 기도 제목", text: $prayerTitle)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextEditor(text: $content)
                    .frame(height: 150)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)

                Spacer()

                Button(action: {
                    firebaseVM.saveDiaryEntry(scripture: scripture, content: content, prayerTitle: prayerTitle)
                    scripture = ""
                    content = ""
                    prayerTitle = ""
                }) {
                    Text("저장하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 10)
            }
            .padding()
            .navigationTitle("일기 작성하기")
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}
