//
//  BibleView.swift
//  simpleBible
//
//  Created by shkim on 2/1/25.
//
import SwiftUI



struct BibleView: View {
    @Binding var selectedTab: Int
    
    @StateObject private var viewModel = BibleViewModel()
    
    @State private var selectedBook = bibleBooks[0]
    @State private var selectedChap = 1
    
    @State private var title = "성경"
    @State private var presentChap = 0
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Picker(selection: $selectedBook, label: Text("Books")) {
                        ForEach(bibleBooks) { book in
                            Text(book.kor).tag(book)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 200, height: 100)
                    .onChange(of: selectedBook, {
                        selectedChap = 1
                    })
                    Picker(selection: $selectedChap, label: Text("Chap")) {
                        ForEach(1...selectedBook.chapters, id: \.self) { chap in
                            Text("\(chap)장").tag(chap)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 100, height: 100)
                    Button("이동") {
                        viewModel.fetchVerses(bookAbbr: selectedBook.code, startChap: selectedChap, startVerse: 1, endChap:  selectedChap, endVerse: 100)
                        title = selectedBook.kor
                        presentChap = selectedChap
                    }
                    .buttonStyle(.bordered)
                }
                List(viewModel.verses) { verse in
                    Text(verse.content)
                        .padding(.vertical, 4)
                }
                .navigationTitle(title + " " + String(presentChap) + "장")
                .onAppear {
                    viewModel.fetchVerses(bookAbbr: "gen", startChap: 1, startVerse: 1, endChap: 1, endVerse: 100)
                    selectedBook = bibleBooks[0]
                    selectedChap = 1
                }
            }
        }
    }
}

//#Preview {
//    BibleView()
//}
