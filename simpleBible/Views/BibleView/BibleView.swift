//
//  BibleView.swift
//  simpleBible
//
//  Created by shkim on 2/1/25.
//

import SwiftUI

struct BibleView: View {
    @Binding var selectedTab: Int
    @Binding var showNewEntryForm: Bool
    
    @EnvironmentObject var viewModel: BibleVM
    @EnvironmentObject var firebaseVM: FirebaseVM  // ViewModel 인스턴스를 사용

    @State private var selectedBook = bibleBooks[0]
    @State private var selectedChap = 1
    
    @State private var title = "성경"
    @State private var presentChap = 0
    
    // 임시로 피커에서 선택한 값 관리
    @State private var pendingBook = bibleBooks[0]
    @State private var pendingChap = 1
    
    // 복사 상태를 관리하는 변수
    @State private var showCopyMessage = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 5) {
                Text(todayDateString())
                    .font(.footnote)
                    .foregroundColor(.gray)
                HStack(alignment: .center) {
                    HStack {
                        Text(pendingBook.kor)  // 선택한 성경 책 이름
                            .foregroundColor(pendingBook == selectedBook && pendingChap == selectedChap ? .black : .gray)
                        
                        Text("\(pendingChap)장")
                            .foregroundColor(pendingBook == selectedBook && pendingChap == selectedChap ? .black : .gray)
                            .contentTransition(.numericText())
                        
                    }
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .animation(.easeInOut(duration: 0.5), value: pendingChap)
                    .animation(.easeInOut(duration: 0.5), value: pendingBook)
                    
                    Rectangle()
                        .frame(width: 45, height: 45)
                        .foregroundStyle(.background)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.top)
            
            
            VStack() {
                // 성경 구절 리스트
                List($viewModel.verses) { $verse in
                    let verseTitle = "\(verse.book.kor) \(verse.chapter)장 \(verse.verse)절"
                    let verseContent = verse.content.substring(after: "\(verse.book):\(verse.verse) ")
                    
                    Text(verse.content)
                        .padding(.vertical, 4)
                        .swipeActions(edge: .leading) {
                            // 묵상 기록하기 버튼
                            Button("", systemImage: "square.and.pencil") {
                                viewModel.selectedVerse = verseTitle
                                print("\(viewModel.selectedVerse) 로 묵상을 기록합니다.")
                                
                                withAnimation {
                                    selectedTab = 2

                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    showNewEntryForm.toggle()
                                }
                            }
                            .tint(.yellow)
                        }
                        .swipeActions(edge: .trailing) {
                            // 공유하기 버튼
                            Button("", systemImage: "square.and.arrow.up") {
                                UIPasteboard.general.string = "\(verseContent) - \(verseTitle)"
                                
                                // 복사 완료 메시지 표시
                                withAnimation {
                                    verse.isCopied = true
                                }
                                
                                // 일정 시간 후 메시지 숨기기
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        verse.isCopied = false
                                    }
                                }
                                
                            }
                            .tint(.blue)
                        }
                    // 복사 완료 메시지
                    if verse.isCopied {
                        Text("복사 완료!")
                            .font(.footnote)
                            .foregroundColor(.green)
                            .padding(.top, 2)
                            .transition(.opacity)
                    }
                }
                .overlay (
                    // 성경 선택 섹션
                    HStack {
                        Picker(selection: $pendingBook, label: Text("Books")) {
                            ForEach(bibleBooks, id: \.self) { book in
                                Text(book.kor).tag(book)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 150, height: 100)
                        
                        Picker(selection: $pendingChap, label: Text("Chap")) {
                            ForEach(1...pendingBook.chapters, id: \.self) { chap in
                                Text("\(chap)장").tag(chap)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 100, height: 100)
                        
                        
                        Button("이동") {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                selectedBook = pendingBook
                                selectedChap = pendingChap
                                viewModel.fetchVerses(
                                    book: selectedBook,
                                    startChap: selectedChap,
                                    startVerse: 1,
                                    endChap: selectedChap,
                                    endVerse: 100
                                )
                                title = selectedBook.kor
                                presentChap = selectedChap
                            }
                        }
                        .buttonStyle(.bordered)
                        .foregroundStyle(.black)
                        .padding()
                        
                    }
                        .background(Color(UIColor.systemGroupedBackground))
                        .cornerRadius(12, corners: [.topLeft, .topRight])
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                        .padding(.horizontal)
                    , alignment: .bottom)
                
                
            }
            .onAppear {
//                firebaseVM.getReadingList()
//                selectedBook = firebaseVM.reading["book"] as! Book
//                selectedChap = firebaseVM.reading["chapter"] as! Int
//                pendingBook = selectedBook
//                pendingChap = selectedChap
//                
                viewModel.fetchVerses(book: selectedBook, startChap: selectedChap, startVerse: 1, endChap: selectedChap, endVerse: 100)
            }
            .onDisappear {
//                firebaseVM.saveReading(selectedBook: selectedBook, selectedChapter: selectedChap)
//                selectedBook = firebaseVM.reading["book"] as! Book
//                selectedChap = firebaseVM.reading["chapter"] as! Int
//                pendingBook = selectedBook
//                pendingChap = selectedChap
//                viewModel.fetchVerses(book: selectedBook, startChap: selectedChap, startVerse: 1, endChap: selectedChap, endVerse: 100)
            }
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


// 구절 선택 블럭
struct RoundedCorners: Shape {
    var radius: CGFloat = 25.0
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorners(radius: radius, corners: corners))
    }
}
