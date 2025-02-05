//
//  ContentView.swift
//  simpleBible
//
//  Created by shkim on 2/3/25.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser


struct ContentView: View {
    @Binding var selectedTab: Int
    
    @StateObject var kakaoAuthVM: KakaoAuthVM = KakaoAuthVM()
    @State private var profileName: String = "로그인 이름"
    
    let logInStatusInfo: (Bool) -> String = { isLoggedIn in
        return isLoggedIn ? "로그인 성공" : "로그인이 필요합니다"
    }
    
    var body: some View {
        VStack {
            Text(logInStatusInfo(kakaoAuthVM.isLoggedIn))
            Text(kakaoAuthVM.userProfile.nickName)
                .font(.title.bold())
                .padding()
            if let url = kakaoAuthVM.userProfile.profileImageUrl {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView() // Show loading indicator while the image is loading
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100) // Circle size
                                        .clipShape(Circle())
                                        .shadow(radius: 5) // Optional: Add shadow effect
                                case .failure:
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.gray)
                                }
                            }
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        }
            
            Button("카카오 로그인", action: {
                kakaoAuthVM.kakaoLogin()
            })
            .padding()
            Button("카카오 로그아웃", action: {
                kakaoAuthVM.kakaoLogout()
            })
            .padding()
        }
    }
}

