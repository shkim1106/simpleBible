//
//  Bible.swift
//  simpleBible
//
//  Created by shkim on 2/2/25.
//
import Foundation
import SwiftUI

/// 일기를 나타내는 모델 구조체
struct DiaryEntry: Identifiable, Equatable {
    let id: String           // 각 일기를 구별할 수 있는 고유 ID (Firestore document ID)
    let scripture: String    // 묵상한 말씀
    let date: Date           // 일기 작성 날짜
    let content: String      // 일기 내용
    let prayerTitle: String  // 기도 제목
}
