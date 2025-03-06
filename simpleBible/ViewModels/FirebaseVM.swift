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
    
    var reading = [
        "book": bibleBooks[0],
        "chapter": 1
    ] as [String : Any]
    
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
    
    
    
    // 마지막으로 읽은 성경 저장
    func saveReading(selectedBook: Book, selectedChapter: Int) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("로그인된 유저 없음")
            return
        }

        let db = Firestore.firestore()
//        Book(kor: "창세기",       eng: "Genesis",         code: "Gen",  chapters: 50)
        let selectedReading = [
            "kor": selectedBook.kor,
            "eng": selectedBook.eng,
            "code": selectedBook.code,
            "chapters": selectedBook.chapters,
            "chapter": selectedChapter
        ] as [String : Any]
        
        db.collection("readingList").document(userId).setData(["readingList": selectedReading], merge: true) { error in
            if let error = error {
                print("성경 저장 실패: \(error)")
            } else {
                print("성경 저장 성공: \(selectedBook.kor) \(selectedChapter)장")
            }
        }
    }
    
    // 마지막으로 읽은 성경 불러오기
    func getReadingList() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("로그인된 유저 없음")
            return
        }

        let db = Firestore.firestore()
        db.collection("readingList").document(userId).getDocument { snapshot, error in
            if let error = error {
                print("성경 정보 가져오기 실패: \(error)")
            }

            // 해당 문서가 존재하는지, 'readingList' 필드가 있는지 확인
            guard let data = snapshot?.data(),
                  let readingList = data["readingList"] as? [String: Any],
                  let kor = readingList["kor"] as? String,
                  let eng = readingList["eng"] as? String,
                  let code = readingList["code"] as? String,
                  let chapters = readingList["chapters"] as? Int,
                  let chapter = readingList["chapter"] as? Int else {
                print("readingList가 비어있거나 필드 형식이 맞지 않습니다.")
                return
            }
            //        Book(kor: "창세기",       eng: "Genesis",         code: "Gen",  chapters: 50)
            // book, chapter 반환
            print("성경 정보 가져오기 성공: \(kor) \(chapter)장")
            let book = Book(kor: kor, eng: eng, code: code, chapters: chapters)
            self.reading["book"] = book
            self.reading["chapter"] = chapter
        }
    }
    
    
    
    
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
