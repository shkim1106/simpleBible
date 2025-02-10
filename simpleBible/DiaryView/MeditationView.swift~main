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
        NavigationView {
            ScrollView {
                SectionCard {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // 묵상 제목
                        VStack(alignment: .leading, spacing: 8) {
                            Text("묵상 제목")
                                .font(.headline)
                                .foregroundColor(.primary)
                            CustomTextField(placeholder: "제목을 입력하세요", text: $title)
                        }

                        // 오늘의 말씀
                        VStack(alignment: .leading, spacing: 8) {
                            Text("오늘의 말씀")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            if let randomVerse = viewModel.randomVerse {
                                Text("\(randomVerse.book) \(randomVerse.chapter)장 \(randomVerse.verse)절\n\(randomVerse.content)")
                                    .font(.body)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(.white)
                                    .cornerRadius(8)
                            } else {
                                Text("말씀을 불러오는 중입니다...")
                                    .foregroundColor(.gray)
                            }
                        }

                        // 묵상 내용
                        VStack(alignment: .leading, spacing: 8) {
                            Text("묵상 내용")
                                .font(.headline)
                                .foregroundColor(.primary)
                            CustomTextEditor(text: $meditationContent, placeholder: "묵상 내용을 입력하세요...")
                        }

                        // 기도 제목
                        VStack(alignment: .leading, spacing: 8) {
                            Text("기도 제목")
                                .font(.headline)
                                .foregroundColor(.primary)
                            CustomTextEditor(text: $prayerRequests, placeholder: "기도 제목을 입력하세요...")
                        }

                        // 저장 버튼
                        Button(action: saveMeditation) {
                            Text("저장하기")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .font(.headline)
                        }
                    }
                    .padding()
                }
                .padding()
            }
            .navigationTitle("묵상 기록")
            .onAppear(perform: viewModel.getRandomBibleVerse)
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
    }

    private func saveMeditation() {
        print("묵상 기록 저장: {\(title)}, {\(meditationContent)}, {\(prayerRequests)}")
    }
}

// 텍스트 필드: 깔끔하고 미니멀한 디자인
struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )
    }
}

// 텍스트 편집기: 깔끔하고 동적 높이 지원
struct CustomTextEditor: View {
    @Binding var text: String
    var placeholder: String
    @State private var dynamicHeight: CGFloat = 40
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            TextEditor(text: $text)
                .background(.clear)
                .padding(.horizontal, 4)
                .cornerRadius(8)
                .frame(height: dynamicHeight + 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .onChange(of: text) {
                    recalculateHeight()
                }
            
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(8)
            }
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

// 단일 섹션 카드
struct SectionCard<Content: View>: View {
    var content: () -> Content
    
    var body: some View {
        VStack {
            content()
        }
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
        .padding(.horizontal)
    }
}
