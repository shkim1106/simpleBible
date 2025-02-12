//
//  BibleViewModel.swift
//  simpleBible
//
//  Created by shkim on 2/1/25.
//

import SwiftUI

// 각 성경(Book)에 대한 간단한 모델
struct Book: Identifiable, Hashable {
    let id = UUID()
    var kor: String      // 한글 이름
    var eng: String      // 영문 이름(공백 포함)
    var code: String     // 영문 이름에서 생성된 고유 코드
    var chapters: Int    // 해당 책의 총 장 수
}

// 각 절(Verse)에 대한 간단한 모델
struct Verse: Identifiable {
    let id = UUID()
    let content: String    // 성경 구절 텍스트
    let book: Book    // 해당 구절의 성경
    let chapter: Int    // 해당 구절의 장
    let verse: Int
    var isCopied: Bool
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




import SwiftUI


class BibleVM: ObservableObject {
    @Published var verses: [Verse] = []  // 일반 구절 리스트
    @Published var randomVerse: Verse? = nil  // 랜덤 구절 저장

    /// 성경 구절을 비동기적으로 가져오는 함수
    func fetchVerses(book: Book, startChap: Int, startVerse: Int, endChap: Int, endVerse: Int) {
        let urlString = "https://ibibles.net/quote.php?kor-\(book.code)/\(startChap):\(startVerse)-\(endChap):\(endVerse)"
        
        guard let url = URL(string: urlString) else {
            print("URL 생성 실패")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("통신 에러: \(error)")
                return
            }
            
            guard let data = data,
                  let htmlString = String(data: data, encoding: .utf8) else {
                print("데이터 or 인코딩 에러")
                return
            }
            
            let cleanedText = self.stripHTML(from: htmlString)
            var lines = cleanedText.components(separatedBy: CharacterSet.newlines).filter { !$0.isEmpty }
            
            if lines.first == "Bible Quote" {
                lines.removeFirst()
            }
            
            let versesArray = lines.enumerated().map { index, content in
                Verse(content: content.trimmingCharacters(in: .whitespacesAndNewlines),
                      book: book,
                      chapter: startChap,
                      verse: index + 1,
                      isCopied: false)
            }
            
            DispatchQueue.main.async {
                self.verses = versesArray
            }
            
        }.resume()
    }

    /// 랜덤 성경 구절을 비동기적으로 가져오는 함수
    func getRandomBibleVerse() {
        let randomSelection = getRandomBibleChapter()
        
        fetchVerses(book: randomSelection.book, startChap: randomSelection.chapter, startVerse: 1, endChap: randomSelection.chapter, endVerse: 100)
        
        // 구절을 비동기적으로 가져온 후 랜덤 선택
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {  // 데이터 준비를 위해 약간의 딜레이
            guard !self.verses.isEmpty else {
                print("구절을 불러오지 못했습니다.")
                print("다시 시도합니다")
                self.getRandomBibleVerse()
                return
            }
            
            var generator = SeededGenerator(seed: seedFromCurrentDate())  // 오늘 날짜로 seed 설정
            if let randomVerse = self.verses.randomElement(using: &generator) {
                self.randomVerse = Verse(content: randomVerse.content,
                                         book: randomSelection.book,
                                         chapter: randomSelection.chapter,
                                         verse: randomVerse.verse,
                                         isCopied: false)
                print("오늘의 구절 불러오기 성공")
            }
        }
    }

    /// 랜덤 책과 장을 선택하는 함수
    private func getRandomBibleChapter() -> (book: Book, chapter: Int) {
        var generator = SeededGenerator(seed: seedFromCurrentDate())  // 오늘 날짜로 seed 설정
        let randomBook = bibleBooks.randomElement(using: &generator)!
        let randomChapter = Int.random(in: 1...randomBook.chapters, using: &generator)
        return (book: randomBook, chapter: randomChapter)
    }

    /// HTML 태그 제거
    private func stripHTML(from html: String) -> String {
        let regexPattern = "<[^>]+>"
        
        guard let regex = try? NSRegularExpression(pattern: regexPattern, options: []) else {
            return html
        }
        
        let range = NSRange(location: 0, length: html.utf16.count)
        let modString = regex.stringByReplacingMatches(in: html, options: [], range: range, withTemplate: "")
        
        return modString
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .replacingOccurrences(of: "&amp;", with: "&")
    }
}

// seed 생성기
struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        self.state = seed
    }

    mutating func next() -> UInt64 {
        // 간단한 XORShift 알고리즘 사용
        state ^= state >> 21
        state ^= state << 35
        state ^= state >> 4
        return state &* 2685821657736338717
    }
}

// 날짜 기반 seed 생성
func seedFromCurrentDate() -> UInt64 {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd"  // "20250203" 형식으로 변환
    let todayString = dateFormatter.string(from: Date())
    return UInt64(todayString) ?? UInt64.random(in: 0...UInt64.max)  // 변환 실패 시 랜덤 값 사용
}


extension String {
    /// 특정 구분자를 기준으로 문자열의 뒷부분만 반환
    func substring(after delimiter: String) -> String {
        guard let range = self.range(of: delimiter) else { return self }
        return String(self[range.upperBound...])
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

