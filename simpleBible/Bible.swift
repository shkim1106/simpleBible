//
//  Bible.swift
//  simpleBible
//
//  Created by shkim on 2/2/25.
//
import Foundation
import SwiftUI

struct Book: Identifiable, Hashable {
    let id = UUID()
    var kor: String      // 한글 이름
    var eng: String      // 영문 이름(공백 포함)
    var code: String     // 영문 이름에서 생성된 고유 코드
    var chapters: Int    // 해당 책의 총 장 수
}

let bibleBooks: [Book] = [
    // ----------------------------
    // 구약(Old Testament) 39권
    // ----------------------------
    Book(kor: "창세기",       eng: "Genesis",         code: "Gen",  chapters: 50),
    Book(kor: "출애굽기",     eng: "Exodus",          code: "Exo",  chapters: 40),
    Book(kor: "레위기",       eng: "Leviticus",       code: "Lev",  chapters: 27),
    Book(kor: "민수기",       eng: "Numbers",         code: "Num",  chapters: 36),
    Book(kor: "신명기",       eng: "Deuteronomy",     code: "Deu",  chapters: 34),
    Book(kor: "여호수아",     eng: "Joshua",          code: "Jos",  chapters: 24),
    Book(kor: "사사기",       eng: "Judges",          code: "Judg", chapters: 21),  // Judges vs Jude 충돌
    Book(kor: "룻기",         eng: "Ruth",            code: "Rut",  chapters: 4),
    Book(kor: "사무엘상",     eng: "1 Samuel",        code: "1Sa",  chapters: 31),
    Book(kor: "사무엘하",     eng: "2 Samuel",        code: "2Sa",  chapters: 24),
    Book(kor: "열왕기상",     eng: "1 Kings",         code: "1Ki",  chapters: 22),
    Book(kor: "열왕기하",     eng: "2 Kings",         code: "2Ki",  chapters: 25),
    Book(kor: "역대상",       eng: "1 Chronicles",    code: "1Ch",  chapters: 29),
    Book(kor: "역대하",       eng: "2 Chronicles",    code: "2Ch",  chapters: 36),
    Book(kor: "에스라",       eng: "Ezra",            code: "Ezr",  chapters: 10),
    Book(kor: "느헤미야",     eng: "Nehemiah",        code: "Neh",  chapters: 13),
    Book(kor: "에스더",       eng: "Esther",          code: "Est",  chapters: 10),
    Book(kor: "욥기",         eng: "Job",             code: "Job",  chapters: 42),
    Book(kor: "시편",         eng: "Psalms",          code: "Psa",  chapters: 150),
    Book(kor: "잠언",         eng: "Proverbs",        code: "Pro",  chapters: 31),
    Book(kor: "전도서",       eng: "Ecclesiastes",    code: "Ecc",  chapters: 12),
    Book(kor: "아가",         eng: "Song of Solomon", code: "Son",  chapters: 8),
    Book(kor: "이사야",       eng: "Isaiah",          code: "Isa",  chapters: 66),
    Book(kor: "예레미야",     eng: "Jeremiah",        code: "Jer",  chapters: 52),
    Book(kor: "예레미야 애가", eng: "Lamentations",    code: "Lam",  chapters: 5),
    Book(kor: "에스겔",       eng: "Ezekiel",         code: "Eze",  chapters: 48),
    Book(kor: "다니엘",       eng: "Daniel",          code: "Dan",  chapters: 12),
    Book(kor: "호세아",       eng: "Hosea",           code: "Hos",  chapters: 14),
    Book(kor: "요엘",         eng: "Joel",            code: "Joe",  chapters: 3),
    Book(kor: "아모스",       eng: "Amos",            code: "Amo",  chapters: 9),
    Book(kor: "오바댜",       eng: "Obadiah",         code: "Oba",  chapters: 1),
    Book(kor: "요나",         eng: "Jonah",           code: "Jon",  chapters: 4),
    Book(kor: "미가",         eng: "Micah",           code: "Mic",  chapters: 7),
    Book(kor: "나훔",         eng: "Nahum",           code: "Nah",  chapters: 3),
    Book(kor: "하박국",       eng: "Habakkuk",        code: "Hab",  chapters: 3),
    Book(kor: "스바냐",       eng: "Zephaniah",       code: "Zep",  chapters: 3),
    Book(kor: "학개",         eng: "Haggai",          code: "Hag",  chapters: 2),
    Book(kor: "스가랴",       eng: "Zechariah",       code: "Zec",  chapters: 14),
    Book(kor: "말라기",       eng: "Malachi",         code: "Mal",  chapters: 4),
    
    // ----------------------------
    // 신약(New Testament) 27권
    // ----------------------------
    Book(kor: "마태복음",   eng: "Matthew",         code: "Mat",   chapters: 28),
    Book(kor: "마가복음",   eng: "Mark",            code: "Mar",   chapters: 16),
    Book(kor: "누가복음",   eng: "Luke",            code: "Luk",   chapters: 24),
    Book(kor: "요한복음",   eng: "John",            code: "Joh",   chapters: 21),
    Book(kor: "사도행전",   eng: "Acts",            code: "Act",   chapters: 28),
    Book(kor: "로마서",     eng: "Romans",          code: "Rom",   chapters: 16),
    Book(kor: "고린도전서", eng: "1 Corinthians",   code: "1Co",   chapters: 16),
    Book(kor: "고린도후서", eng: "2 Corinthians",   code: "2Co",   chapters: 13),
    Book(kor: "갈라디아서", eng: "Galatians",       code: "Gal",   chapters: 6),
    Book(kor: "에베소서",   eng: "Ephesians",       code: "Eph",   chapters: 6),
    Book(kor: "빌립보서",   eng: "Philippians",     code: "Phili", chapters: 4),  // Philippians vs Philemon 충돌
    Book(kor: "골로새서",   eng: "Colossians",      code: "Col",   chapters: 4),
    Book(kor: "데살로니가전서", eng: "1 Thessalonians", code: "1Th",   chapters: 5),
    Book(kor: "데살로니가후서", eng: "2 Thessalonians", code: "2Th",   chapters: 3),
    Book(kor: "디모데전서", eng: "1 Timothy",       code: "1Ti",   chapters: 6),
    Book(kor: "디모데후서", eng: "2 Timothy",       code: "2Ti",   chapters: 4),
    Book(kor: "디도서",     eng: "Titus",           code: "Tit",   chapters: 3),
    Book(kor: "빌레몬서",   eng: "Philemon",        code: "Phile", chapters: 1),
    Book(kor: "히브리서",   eng: "Hebrews",         code: "Heb",   chapters: 13),
    Book(kor: "야고보서",   eng: "James",           code: "Jam",   chapters: 5),
    Book(kor: "베드로전서", eng: "1 Peter",         code: "1Pe",   chapters: 5),
    Book(kor: "베드로후서", eng: "2 Peter",         code: "2Pe",   chapters: 3),
    Book(kor: "요한일서",   eng: "1 John",          code: "1Jo",   chapters: 5),
    Book(kor: "요한이서",   eng: "2 John",          code: "2Jo",   chapters: 1),
    Book(kor: "요한삼서",   eng: "3 John",          code: "3Jo",   chapters: 1),
    Book(kor: "유다서",     eng: "Jude",            code: "Jude",  chapters: 1),  // Judges vs Jude 충돌
    Book(kor: "요한계시록", eng: "Revelation",      code: "Rev",   chapters: 22)
]
