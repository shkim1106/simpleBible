//
//  MainView.swift
//  simpleBible
//
//  Created by shkim on 2/2/25.
//
import SwiftUI

struct MainView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            WelcomePage(selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            BibleView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Bible", systemImage: "book")
                }
                .tag(1)
            MeditationView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Meditation", systemImage: "book.pages")
                }
                .tag(2)
            ContentView(selectedTab: $selectedTab)
                .tabItem {
                    Label("TestView", systemImage: "exclamationmark.triangle.fill")
                }
                .tag(10)
            
        }
    }
}
