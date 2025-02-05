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
        return isLoggedIn ? "로그인 성공" : "로그아웃 완료"
    }
    
    var body: some View {
        VStack {
            Text(logInStatusInfo(kakaoAuthVM.isLoggedIn))
                .padding()
            Text(kakaoAuthVM.nickName)
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

