//
//  ContentView.swift
//  simpleBible
//
//  Created by shkim on 2/3/25.
//

import SwiftUI

struct ContentView: View {
    @Binding var selectedTab: Int
    
    
    @StateObject private var bibleViewModel = BibleViewModel()
    
    var body: some View {
        VStack {
            if let randomVerse = bibleViewModel.randomVerse {
                VStack {
                    Text("\(randomVerse.book) \(randomVerse.chapter):\(randomVerse.verse)")
                        .font(.headline)
                        .padding(.bottom, 5)
                    Text(randomVerse.content)
                        .font(.body)
                        .padding()
                }
            } else {
                Text("랜덤 성경 구절을 불러오는 중...")
                    .padding()
            }
            
            Button(action: fetchRandomVerse) {
                Text("랜덤 성경 구절 가져오기")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear(perform: fetchRandomVerse)
    }
    
    private func fetchRandomVerse() {
//        bibleViewModel.getRandomBibleVerse()
    }
}

