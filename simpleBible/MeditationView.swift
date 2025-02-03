//
//  MeditationView.swift
//  simpleBible
//
//  Created by shkim on 2/3/25.
//

import SwiftUI

struct MeditationView: View {
    @Binding var selectedTab: Int
    
    @State private var title: String = ""
    @State private var meditationContent: String = ""
    @State private var prayerRequests: String = ""
    @StateObject private var viewModel = BibleViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ScrollView {
                // 제목 입력
                VStack(alignment: .leading) {
                    Text("묵상 제목")
                        .font(.headline)
                    RoundedTextField(placeholder: "제목을 입력하세요", text: $title)
//                    TextField("제목을 입력하세요", text: $title)
//                        .padding()
//                        .background(Color(.systemGray6))
//                        .cornerRadius(8)

                }
                
                // 날짜 표시
                VStack(alignment: .leading) {
                    Text("\(currentDateFormatted())")
                        .padding(.vertical, 5)
                        .foregroundColor(.gray)
                }
                
                // 오늘의 말씀
                VStack(alignment: .leading) {
                    if let randomVerse = viewModel.randomVerse {
                        Text("오늘의 말씀")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        RoundedReadOnlyBox(text: "\(randomVerse.book) \(randomVerse.chapter)장 \(randomVerse.verse)절 \n" + randomVerse.content.substring(after: "\(randomVerse.chapter):\(randomVerse.verse) "))
//                        Text("\(randomVerse.book) \(randomVerse.chapter)장 \(randomVerse.verse)절 \n" + randomVerse.content.substring(after: "\(randomVerse.chapter):\(randomVerse.verse) "))
//                            .padding()
//                            .background(Color(.systemGray6))
//                            .cornerRadius(8)
//                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                }
                
                // 묵상 내용 입력
                VStack(alignment: .leading) {
                    Text("묵상 내용")
                        .font(.headline)
                    AutoGrowingTextEditor(text: $meditationContent, placeholder: "묵상 내용을 입력하세요...")
//                    TextEditor(text: $meditationContent)
//                        .font(.system(size: 14))
//                        .frame(height: 130)
//                        .padding()
//                        .background(Color(.systemGray6))
//                        .cornerRadius(8)
                }
                
                // 기도 제목 입력
                VStack(alignment: .leading) {
                    Text("기도 제목")
                        .font(.headline)
                    AutoGrowingTextEditor(text: $prayerRequests, placeholder: "기도 제목을 입력하세요...")
//                    TextEditor(text: $prayerRequests)
//                        .font(.system(size: 14))
//                        .frame(height: 70)
//                        .padding()
//                        .background(Color(.systemGray6))
//                        .cornerRadius(8)
                }
                
                // 저장 버튼
                Button(action: saveMeditation) {
                    Text("저장하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.headline)
                }
                .padding(.top, 20)
            }
            .padding(.horizontal)
        }
        .navigationTitle("묵상 기록")
        .onAppear(perform: viewModel.getRandomBibleVerse)
        .onTapGesture {
            UIApplication.shared.endEditing()  // 화면을 탭하면 키보드 숨기기
        }
    }
    
    // 현재 날짜를 포맷하는 함수
    private func currentDateFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ko_KR")  // 한국 날짜 형식
        return formatter.string(from: Date())
    }
    
    // 묵상 내용을 저장하는 로직 (예제: 콘솔 출력)
    private func saveMeditation() {
        // 실제 저장 로직 (Core Data, 서버 업로드 등)을 여기에 추가
    }
}



// 입력칸 높이 자동 조정
struct AutoGrowingTextEditor: View {
    @Binding var text: String
    var placeholder: String
    @State private var dynamicHeight: CGFloat = 40
    
    var body: some View {
        VStack (alignment: .leading) {
            TextEditor(text: $text)
                .padding(10)
                .frame(height: max(dynamicHeight, 100))  // 최소 높이 설정
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)  // 테두리 설정
                )
                .cornerRadius(10)
//                .overlay(
//                    Group {
//                        if text.isEmpty {
//                            Text(placeholder) 
//                                .foregroundColor(.gray)
//                                .padding(15)
//                                .frame(maxWidth: .infinity, alignment: .topLeading)
//                        }
//                    }
//                )
                .onChange(of: text, {
                    recalculateHeight()
                })
        }
    }
    
    private func recalculateHeight() {
        let textView = UITextView()
        textView.text = text
        textView.font = UIFont.systemFont(ofSize: 16)
        let size = textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 40, height: CGFloat.infinity))
        dynamicHeight = size.height
    }
}


// Elements Design: Text Field
struct RoundedTextField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
    }
}

// Elements Design: Text
struct RoundedReadOnlyBox: View {
    var text: String

    var body: some View {
        Text(text)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
