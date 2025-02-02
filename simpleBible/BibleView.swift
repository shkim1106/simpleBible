//
//  BibleView.swift
//  simpleBible
//
//  Created by shkim on 2/1/25.
//
import SwiftUI



struct BibleView: View {
    @StateObject private var viewModel = BibleViewModel()
    @State private var selectedBook = "gen"
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $selectedBook, label: Text("Books")) {
                    Text("창세기").tag("gen")
                    Text("출애굽기").tag("exo")
                }
                List(viewModel.verses) { verse in
                    Text(verse.text)
                        .padding(.vertical, 4)
                }
                .navigationTitle("성경 구절")
                .onAppear {
                                // 창세기(gen) 1장 1~10절 API 호출
                                viewModel.fetchVerses(bookAbbr: "gen", startChap: 1, startVerse: 1, endChap: 1, endVerse: 10)
                            }
                .onChange(of: selectedBook) {
                    // 창세기(gen) 1장 1~10절 API 호출
                    viewModel.fetchVerses(bookAbbr: selectedBook, startChap: 1, startVerse: 1, endChap: 1, endVerse: 100)
                }
            }
        }
    }
}

#Preview {
    BibleView()
}
