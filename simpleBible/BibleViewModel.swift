//
//  BibleViewModel.swift
//  simpleBible
//
//  Created by shkim on 2/1/25.
//

import SwiftUI

// 각 절(Verse)에 대한 간단한 모델
struct Verse: Identifiable {
    let id = UUID()
    let text: String
    let book: String
    let chapter: Int
}


class BibleViewModel: ObservableObject {
    @Published var verses: [Verse] = []
    
    // 예: 책(book) = "창세기", 요약 = "gen", 장 = 1, 절 범위 = 1~10
    // 이런 식으로 파라미터를 받아 동적으로 URL 을 구성할 수 있겠죠.
    func fetchVerses(bookAbbr: String, startChap: Int, startVerse: Int,
                     endChap: Int, endVerse: Int) {
        
        // kor-yyy/aa:bb-cc:dd
        // 예시: http://ibibles.net/quote.php?kor-gen/1:1-1:10
        let urlString = "https://ibibles.net/quote.php?kor-\(bookAbbr)/\(startChap):\(startVerse)-\(endChap):\(endVerse)"
        
        guard let url = URL(string: urlString) else {
            print("URL 생성 실패")
            return
        }
        
        // URLSession 을 통한 API 요청
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
            
            // HTML → 순수 텍스트로 변환
            let cleanedText = self.stripHTML(from: htmlString)
            
            // 한 줄이 하나의 절이라고 가정하고 잘라서 Verse 배열로 만든다
            var lines = cleanedText.components(separatedBy: CharacterSet.newlines).filter { !$0.isEmpty }
            // 만약 첫 줄에 "Bible Quote"가 있으면 제거
            if lines.first == "Bible Quote" {
                lines.removeFirst()
            }
            
            
            let versesArray = lines.map {
                Verse(text: $0.trimmingCharacters(in: .whitespacesAndNewlines), book: bookAbbr, chapter: startChap)
            }

            
            // 메인스레드에서 UI 업데이트
            DispatchQueue.main.async {
                self.verses = versesArray
            }
            
        }.resume()
    }
    
    // HTML 태그 제거를 위한 간단한 함수 (정규표현식)
    private func stripHTML(from html: String) -> String {
        // <[^>]+> 이런 패턴으로 태그를 찾고 모두 제거
        // &nbsp; 등 특수문자 치환도 필요하다면 추가로 처리해주면 됨
        let regexPattern = "<[^>]+>"
        
        guard let regex = try? NSRegularExpression(pattern: regexPattern, options: []) else {
            return html
        }
        
        let range = NSRange(location: 0, length: html.utf16.count)
        let modString = regex.stringByReplacingMatches(in: html, options: [], range: range, withTemplate: "")
        
        // 필요하다면 &nbsp; 등 HTML 엔티티를 추가로 치환
        // 예) &nbsp; -> 공백
        let finalString = modString
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .replacingOccurrences(of: "&amp;", with: "&")
        
        return finalString
    }
}
