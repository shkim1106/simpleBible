//
//  MainView.swift
//  simpleBible
//
//  Created by shkim on 2/2/25.
//
import SwiftUI
import Firebase

struct MainView: View {
    @EnvironmentObject var firebaseVM: FirebaseVM  // ViewModel 인스턴스를 사용
    @EnvironmentObject var viewModel: BibleVM

    @StateObject var kakaoAuthVM: KakaoAuthVM = KakaoAuthVM()


    @State private var selectedTab: Int = 0
    @State private var showNewEntryForm: Bool = false
    @State private var isContentReady: Bool = false

    
    var body: some View {
        ZStack {
            if isContentReady {
                TabView(selection: $selectedTab) {
                    WelcomePage(selectedTab: $selectedTab, showNewEntryForm: $showNewEntryForm)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        .tag(0)
                    
                    DiaryListView(selectedTab: $selectedTab, showNewEntryForm: $showNewEntryForm)
                        .tabItem {
                            Label("Record", systemImage: "square.and.pencil")
                        }
                        .tag(2)
                    
                    BibleView(selectedTab: $selectedTab, showNewEntryForm: $showNewEntryForm)
                        .tabItem {
                            Label("Bible", systemImage: "book")
                        }
                        .tag(1)
                    
//                    DiaryFormView(selectedTab: $selectedTab)
//                        .tabItem {
//                            Label("Meditation", systemImage: "square.and.pencil")
//                        }
//                        .tag(2)

//                    LoginView(selectedTab: $selectedTab)
//                        .tabItem {
//                            Label("Login", systemImage: "person.crop.circle")
//                        }
//                        .tag(4)
                }
//                .transition(.opacity.animation(.easeInOut(duration: 0.5)))  // TabView 트랜지션
            }
            
            if !isContentReady {
                mySplashScreenView
                    .transition(.opacity.animation(.easeInOut(duration: 0.5)))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    isContentReady = true
                }
            }
        }
    }
}

// Splash View
extension MainView {
    var mySplashScreenView: some View {
        ZStack {
            // Mesh Gradient 배경 (Hex 색상 사용)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#FFD700"),  // 금색 (Golden Yellow)
                    Color(hex: "#4682B4"),  // Deep Sky Blue
                    Color(hex: "#F5DEB3"),  // Wheat (Warm Beige)
                    Color(hex: "#556B2F")   // Dark Olive Green
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack {
                // 중앙 텍스트
                Text("QT Today")
                    .font(.custom("Maplestory OTF Light", size: 20))
                    .foregroundStyle(.linearGradient(colors: [
                        Color(hex: "#000000"),  // Gold for text highlight
                        Color(hex: "#556B2F")   // Dark orange
                    ], startPoint: .leading, endPoint: .trailing))
                    .italic()
            }
            .onAppear {
                kakaoAuthVM.autoLogin()
//                viewModel.getRandomBibleVerse()
            }
            
            
                
        }
    }
}


extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#") // "#" 무시

        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}
