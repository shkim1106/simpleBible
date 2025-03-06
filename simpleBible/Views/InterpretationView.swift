//
//  InterpretationView.swift
//  simpleBible
//
//  Created by shkim on 2/13/25.
//

import SwiftUI
import FirebaseFirestore

struct InterpretationView: View {
    let verse: Verse
    @State private var interpretation: String? = nil
    @State private var isLoading = false
    @State private var isFetchingNewResponse = false
    private let db = Firestore.firestore()
    
    var body: some View {
        let verseTitle = "\(verse.book.kor) \(verse.chapter)장 \(verse.verse)절"
//        let verseContent = verse.content.substring(after: "\(verse.chapter):\(verse.verse) ")
        NavigationView {
            VStack {
                HStack {
                    Text("**\(verseTitle)**")
                        .font(.title.bold())
                        .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        fetchInterpretation(useCache: false)
                    }) {
                        Image(systemName: "arrow.clockwise")  // 리프레쉬 버튼
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                            .padding()
                    }
                    
                }
                .padding(.horizontal)
                
                

                if isLoading {
                    ProgressView("해석을 가져오는 중...")
                } else if let interpretation = interpretation {
                    ScrollView {
                        Text(interpretation)
                            .font(.custom("New York", size: 18)) // Serif 스타일 폰트 적용
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(6) // 줄 간격 조정
                            .padding(.horizontal)
                    }
                    .scrollIndicators(.hidden)
                    .padding(.horizontal)
                    .ignoresSafeArea(.all)
                } else {
                    Text("아직 해석이 없습니다.")
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .onAppear {
                fetchInterpretation(useCache: true) // 처음에는 캐시된 데이터 확인
            }
            .background(Color(UIColor.brown.withAlphaComponent(0.15)))
        }
        .ignoresSafeArea(edges: .bottom)
        
    }

    /// Firebase에서 데이터를 가져오거나 API 호출
    func fetchInterpretation(useCache: Bool) {
        if useCache {
            isLoading = true
            db.collection("bible_interpretations").document("\(verse.book.kor)\(verse.chapter):\(verse.verse)").getDocument { document, error in
                if let document = document, document.exists, let data = document.data(), let savedInterpretation = data["interpretation"] as? String {
                    self.interpretation = savedInterpretation
                    print("저장된 해설을 불러옵니다.")
                    self.isLoading = false
                } else {
                    print("새로운 해설을 불러옵니다.")
                    requestInterpretationFromAPI()
                }
            }
        } else {
            print("새로운 해설을 불러옵니다.")
            requestInterpretationFromAPI()
        }
    }

    /// OpenAI API를 호출하여 해석을 가져오고 Firebase에 저장
    func requestInterpretationFromAPI() {
        isLoading = true
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "SIMPLE_BIBLE_OPENAI_API_KEY") as? String ?? ""
        let endpoint = "https://api.openai.com/v1/chat/completions"

        let requestData: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                ["role": "system", "content": "너는 성경을 해석하는 AI야. 각 내용에 대해 설명해줘."],
                ["role": "user", "content": "성경 구절: \(verse.book.kor)\(verse.chapter)장 \(verse.verse)절 \n\n1. 말씀이 있는 성경에 대한 배경\n2. 구절의 의미\n3. 현실의 적용점"]
            ],
            "temperature": 0.3
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestData) else { return }

        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                guard let data = data, error == nil else {
                    if let error = error {
                        print("응답 처리 실패: \(error)")
                    }
                    interpretation = "에러가 발생했습니다."
                    return
                }
                if let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = jsonData["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {

                    self.interpretation = content
                    saveInterpretationToFirebase(interpretation: content)
                } else {
                    if let error = error {
                        print("응답 처리 실패: \(error)")
                    }
                    interpretation = "응답을 처리하는 중 문제가 발생했습니다."
                }
            }
        }.resume()
    }

    /// Firebase Firestore에 해석 저장
    func saveInterpretationToFirebase(interpretation: String) {
        db.collection("bible_interpretations").document("\(verse.book.kor)\(verse.chapter):\(verse.verse)").setData(["interpretation": interpretation]) { error in
            if let error = error {
                print("Firebase 저장 실패: \(error)")
            } else {
                print("Firebase 저장 성공")
            }
        }
    }
}
