//
//  DiaryListView.swift
//  simpleBible
//
//  Created by shkim on 2/11/25.
//

import SwiftUI

struct DiaryListView: View {
    @EnvironmentObject var firebaseVM: FirebaseVM  // ViewModel 인스턴스를 사용
    
    @Binding var selectedTab: Int
    @Binding var showNewEntryForm: Bool
    
    let maxContentLength: Int = 50
    
    
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
                            selectedTab = 2
                        }
                        .tint(.yellow)
                    }
                }
            }
            .transition(.slide)
            .navigationTitle("나의 묵상")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showNewEntryForm, onDismiss: {
                firebaseVM.fetchDiaryEntries()
            }) {
                DiaryFormView(selectedTab: $selectedTab)
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
