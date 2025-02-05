//
//  SearchView.swift
//  simpleBible
//
//  Created by shkim on 2/2/25.
//

import SwiftUI

struct WelcomePage: View {
    @Binding var selectedTab: Int
    
    @StateObject private var viewModel = BibleViewModel()
    
    let meditationNote: String =
    """
    하나님을 우리의 목자로 고백할 때,
    우리는 풍성함과 평안함을 누릴 수 있습니다.
    """
    @State private var showBibleView = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 상단 날짜 & 타이틀
                VStack(alignment: .leading, spacing: 5) {
                    Text(todayDateString())
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("오늘의 말씀")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // 오늘의 말씀 카드
                VStack(alignment: .leading, spacing: 10) {
                    if let randomVerse = viewModel.randomVerse {
                        Text("\(randomVerse.book) \(randomVerse.chapter)장 \(randomVerse.verse)절")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text(randomVerse.content.substring(after: "\(randomVerse.chapter):\(randomVerse.verse) "))
                            .font(.body)
                        
                        Divider()
                        
                        Text(meditationNote)
                            .font(.callout)
                            .foregroundColor(.secondary)
                    } else {
                        VStack(alignment: .center) {
                            Text("불러오는 중...")
                                .padding()
                            Button("", systemImage: "arrow.clockwise") {
                                viewModel.getRandomBibleVerse()
                            }
                            .foregroundColor(Color.black)
                        }
                        
                    }
                }
                .padding()
                .background(Color(UIColor.systemGroupedBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                .padding(.horizontal)
                
                // 버튼들: 예) 추가 기능으로 이동
                HStack(spacing: 20) {
                    Button(action: {
                        // 예) 묵상 기록 페이지로 이동할 액션
                        selectedTab = 2
                    }) {
                        Text("묵상 기록하기")
                            .fontWeight(.medium)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        selectedTab = 1
                    }) {
                        Text("성경 읽기")
                            .fontWeight(.medium)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("말씀 묵상")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                viewModel.getRandomBibleVerse()
            })
            
        }
        
        
    }
    
    /// 오늘 날짜를 "2025년 2월 2일" 형태로 반환하는 간단한 함수 (예시)
    func todayDateString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: Date())
    }
    
}

