//
//  FirebaseVM.swift
//  simpleBible
//
//  Created by shkim on 2/11/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseAuth

import SwiftUI


/// ViewModel: Firebase 관련 로직을 담당하는 클래스
class FirebaseVM: ObservableObject {
    private let kakaoLoginManager = KakaoAuthVM()

    /// 현재 유저가 로그인되어 있는지 확인하는 함수
        func isUserLoggedIn() -> Bool {
            return Auth.auth().currentUser != nil
        }

    /// 카카오 로그인 후 Firebase Auth 처리 및 Firestore 초기 데이터 로드
        func performKakaoLogin() {
            kakaoLoginManager.handleFirebaseKakaoLogin { success in
                if success {
                    print("카카오 로그인 및 Firebase Auth 성공!")
                    self.fetchDiaryEntries()  // 로그인 후 데이터 로드
                } else {
                    print("로그인 실패")
                }
            }
        }
    
    
    
    // 사용자의 일기 리스트를 저장하는 Published 변수 (UI와 바인딩)
    @Published var diaryEntries: [DiaryEntry] = []
    
    // Firestore에 새로운 일기를 저장하는 함수
    func saveDiaryEntry(scripture: String, content: String, prayerTitle: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("로그인된 유저 없음")
            return
        }

        let db = Firestore.firestore()
        let diaryEntry = [
            "scripture": scripture,
            "date": Timestamp(date: Date()),  // 현재 날짜를 자동으로 저장
            "content": content,
            "prayerTitle": prayerTitle
        ] as [String : Any]

        db.collection("diaries").document(userId).collection("entries").addDocument(data: diaryEntry) { error in
            if let error = error {
                print("일기 저장 실패: \(error)")
            } else {
                print("일기 저장 성공!")
            }
        }
    }
    
    // Firestore에 묵상을 삭제하는 함수
    func deleteDiaryEntry(diaryEntry: DiaryEntry) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("로그인된 유저 없음")
            return
        }

        let db = Firestore.firestore()
        db.collection("diaries").document(userId).collection("entries").document(diaryEntry.id).delete() { error in
            if let error = error {
                print("일기 삭제 실패: \(error)")
            } else {
                print("일기 삭제 성공!")
                withAnimation {
                    self.diaryEntries.remove(at: self.diaryEntries.firstIndex(of: diaryEntry) ?? 0)
                    self.fetchDiaryEntries()
                }
            }
        }
    }

    // Firestore에서 유저가 쓴 모든 일기를 가져오는 함수
    func fetchDiaryEntries() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("로그인된 유저 없음")
            return
        }

        let db = Firestore.firestore()
        db.collection("diaries").document(userId).collection("entries")
            .order(by: "date", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("일기 불러오기 실패: \(error)")
                    self.diaryEntries = []  // 실패 시 빈 배열로 초기화
                } else {
                    print("일기 불러오기 성공")
                    self.diaryEntries = snapshot?.documents.compactMap { doc -> DiaryEntry? in
                        let data = doc.data()
                        guard
                            let scripture = data["scripture"] as? String,
                            let content = data["content"] as? String,
                            let prayerTitle = data["prayerTitle"] as? String,
                            let timestamp = data["date"] as? Timestamp
                        else {
                            return nil
                        }
                        return DiaryEntry(id: doc.documentID, scripture: scripture, date: timestamp.dateValue(), content: content, prayerTitle: prayerTitle)
                    } ?? []
                }
            }
    }
}
