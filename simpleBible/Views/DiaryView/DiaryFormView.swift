//
//  DiaryEntryFormView.swift
//  simpleBible
//
//  Created by shkim on 2/11/25.
//

import SwiftUI
import Firebase

// 일기 저장 경로
// diaries/{userId}/entries/{entryId}
// 메인 보관함/유저별ID/모아놓은 상자

struct DiaryFormView: View {
    @EnvironmentObject var firebaseVM: FirebaseVM
    @Environment(\.dismiss) private var dismiss

    // 외부에서 전달받을 값
    @State var scripture: String
    @State var content: String
    @State var prayerTitle: String
    @State var docId: String
    @State var date: Timestamp
    
    @Binding var selectedTab: Int

    // 만약 기본값이 필요한 경우 이렇게 init에서 초기값 세팅 가능
    init(selectedTab: Binding<Int>,
         scripture: String = "",
         content: String = "",
         prayerTitle: String = "",
         docId: String = "",
         date: Timestamp = Timestamp(date: Date())) {
        self._selectedTab = selectedTab
        self._scripture = State(initialValue: scripture)
        self._content = State(initialValue: content)
        self._prayerTitle = State(initialValue: prayerTitle)
        self._docId = State(initialValue: docId)
        self._date = State(initialValue: date)
        
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(todayDateString(date: date.dateValue()))
                        .font(.footnote)
                        .foregroundColor(.gray)
                    HStack(alignment: .center) {
                        Text((content.isEmpty && prayerTitle.isEmpty) ? "묵상 기록하기" : "묵상 수정하기")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 40)
                
                TextField("📖 묵상한 말씀", text: $scripture)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("🙏 기도 제목", text: $prayerTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextEditor(text: $content)
                    .frame(minHeight: 150)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                    .scrollIndicators(.hidden)

                Button(action: {
                    // 저장
                    firebaseVM.saveDiaryEntry(docId: docId, date: date, scripture: scripture,
                                              content: content,
                                              prayerTitle: prayerTitle)
                    // 완료 후 초기화
                    docId = ""
                    scripture = ""
                    content = ""
                    prayerTitle = ""
                    dismiss()
                }) {
                    Text("기록하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.bottom)

            }
            .padding(.horizontal)
//            .navigationTitle("묵상 기록하기")
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        
    }
    
    /// 오늘 날짜를 "2025년 2월 2일" 형태로 반환하는 간단한 함수 (예시)
    func todayDateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: date)
    }
}
