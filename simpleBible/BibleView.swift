//
//  BibleView.swift
//  simpleBible
//
//  Created by shkim on 2/1/25.
//

import SwiftUI

struct BibleView: View {
    @Binding var selectedTab: Int
    
    @StateObject private var viewModel = BibleViewModel()
    
    @State private var selectedBook = bibleBooks[0]
    @State private var selectedChap = 1
    
    @State private var title = "성경"
    @State private var presentChap = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
//                // 상단 날짜와 제목
//                VStack(alignment: .leading, spacing: 5) {
//                    Text("Bible")
//                        .font(.footnote)
//                        .foregroundColor(.gray)
//                    Text("성경 읽기")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                }
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.horizontal)

                // 성경 선택 섹션
                VStack(alignment: .leading) {
                    HStack {
                        Picker(selection: $selectedBook, label: Text("Books")) {
                            ForEach(bibleBooks) { book in
                                Text(book.kor).tag(book)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 150, height: 80)
                        .onChange(of: selectedBook) {
                            selectedChap = 1
                        }
                        
                        Picker(selection: $selectedChap, label: Text("Chap")) {
                            ForEach(1...selectedBook.chapters, id: \.self) { chap in
                                Text("\(chap)장").tag(chap)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 100, height: 80)
                        
                        Button("이동") {
                            viewModel.fetchVerses(bookAbbr: selectedBook.code, startChap: selectedChap, startVerse: 1, endChap: selectedChap, endVerse: 100)
                            title = selectedBook.kor
                            presentChap = selectedChap
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding()
                .background(Color(UIColor.systemGroupedBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                .padding(.horizontal)
                
                // 성경 구절 리스트
                List(viewModel.verses) { verse in
                    Text(verse.content)
                        .padding(.vertical, 4)
                }
                .navigationTitle(presentChap != 0 ? "\(title) \(presentChap)장" : "성경 읽기")

            }
            .navigationBarTitle("성경 읽기")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchVerses(bookAbbr: "gen", startChap: 1, startVerse: 1, endChap: 1, endVerse: 100)
                selectedBook = bibleBooks[0]
                selectedChap = 1
            }
        }
    }
    
}
