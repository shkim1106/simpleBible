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

    
    
    var body: some View {
        NavigationView {
            List(firebaseVM.diaryEntries) { entry in
                VStack(alignment: .leading, spacing: 5) {
                    Text("📖 말씀: \(entry.scripture)")
                        .font(.headline)
                    Text("📝 내용: \(entry.content)")
                        .font(.body)
                    Text("🙏 기도 제목: \(entry.prayerTitle)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(entry.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 5)
            }
            .navigationTitle("나의 일기")
            .onAppear {
                firebaseVM.fetchDiaryEntries()
            }
        }
    }
}
