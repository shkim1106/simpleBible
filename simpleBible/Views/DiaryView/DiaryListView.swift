//
//  DiaryListView.swift
//  simpleBible
//
//  Created by shkim on 2/11/25.
//

import SwiftUI
import Firebase

struct DiaryListView: View {
    @EnvironmentObject var firebaseVM: FirebaseVM  // ViewModel 인스턴스를 사용
    @EnvironmentObject var viewModel: BibleVM

    @Binding var selectedTab: Int
    @Binding var showNewEntryForm: Bool
    
    let maxContentLength: Int = 50
    
    // 새로 추가: 수정 시 넘길 값을 담을 임시 변수를 만든다.
    @State private var editingScripture: String = ""
    @State private var editingContent: String = ""
    @State private var editingPrayerTitle: String = ""
    @State private var editingDocId: String = ""
    @State private var editingDate: Timestamp = Timestamp(date: Date())
    
    
    @State private var showEffect: Double = 1.0
    
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(todayDateString())
                        .font(.footnote)
                        .foregroundColor(.gray)
                    HStack(alignment: .center) {
                        Text("나의 묵상")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            
                        
                        Spacer()
                        
                        HStack (alignment: .center) {
                            Button(action: {
                                viewModel.selectedVerse = ""
                                editingContent = ""
                                editingPrayerTitle = ""
                                editingDocId = ""
                                editingDate = Timestamp(date: Date())
                                showNewEntryForm.toggle()
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                //                                    .aspectRatio(contentMode: .fill)
                                    .scaledToFit()
                                    .scaleEffect(0.8)
                                    .frame(width: 45, height: 45)
                                    .clipShape(Circle())
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top)
                
                
                List(firebaseVM.diaryEntries) { entry in
                    VStack(alignment: .leading, spacing: 5) {
                        Text("📖 말씀: \(entry.scripture)")
                            .font(.headline)
                        Text("📝 내용: \(truncated(entry.content, to: maxContentLength))")
                            .font(.body)
                        Text("🙏 기도 제목: \(entry.prayerTitle)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(entry.date, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .opacity(entry.content == editingContent ? showEffect : 1)
                    .transition(.slide)
                    .padding(.vertical, 5)
                    .swipeActions(edge: .trailing) {
                        // 묵상 삭제 로직 - Firebase
                        Button("", systemImage: "trash") {
                            firebaseVM.deleteDiaryEntry(diaryEntry: entry)
                        }
                        .tint(.red)
                    }
                    .swipeActions(edge: .leading) {
                        // 묵상 수정 로직 - DiaryEditView(), Firebase
                        Button("", systemImage: "square.and.pencil") {
                            // 1) 편집할 내용을 State에 저장
                            viewModel.selectedVerse = entry.scripture
                            editingContent = entry.content
                            editingPrayerTitle = entry.prayerTitle
                            editingDocId = entry.id
                            editingDate = Timestamp(date: entry.date)
                            
                            // 2) sheet 열기
                            showNewEntryForm.toggle()
                        }
                        .tint(.yellow)
                    }
                    .onTapGesture {
                        // 1) 편집할 내용을 State에 저장
                        viewModel.selectedVerse = entry.scripture
                        editingContent = entry.content
                        editingPrayerTitle = entry.prayerTitle
                        editingDocId = entry.id
                        editingDate = Timestamp(date: entry.date)
                        
                        // 2) sheet 열기
                        showNewEntryForm.toggle()
                    }
                    
                }
                .ignoresSafeArea(.container, edges: .top)
            }
            .transition(.slide)
//            .navigationTitle("나의 묵상")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showNewEntryForm, onDismiss: {
                firebaseVM.fetchDiaryEntries()
                print(viewModel.selectedVerse)
                viewModel.selectedVerse = ""
                editingContent = ""
                editingPrayerTitle = ""
                editingDocId = ""
                editingDate = Timestamp(date: Date())
                // 시트가 닫히면 데이터를 다시 가져오기 전후로 깜빡임
                                withAnimation(.easeIn(duration: 0.3)) {
                                    showEffect = 0.0
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    
                                    // 다시 1.0으로 회복하며 깜빡임
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        showEffect = 1.0
                                    }
                                }
            }) {
                // 3) sheet 안에 전달
                DiaryFormView(
                    selectedTab: $selectedTab,
                    scripture: viewModel.selectedVerse,
                    content: editingContent,
                    prayerTitle: editingPrayerTitle,
                    docId: editingDocId,
                    date: editingDate
                )
            }
            .onAppear {
                firebaseVM.fetchDiaryEntries()
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
    
    // 글자 수를 제한해서 표시하는 간단한 함수
    func truncated(_ text: String, to maxLength: Int) -> String {
        if text.count <= maxLength {
            return text
        } else {
            let prefixText = text.prefix(maxLength)
            return prefixText + "..."
        }
    }
}
