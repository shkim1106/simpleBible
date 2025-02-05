//
//  KakaoViewModel.swift
//  simpleBible
//
//  Created by shkim on 2/5/25.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class KakaoAuthVM: ObservableObject {
    
    @Published var isLoggedIn: Bool = false
    @Published var nickName: String = "이름을 불러올 수 없습니다."
    
    @MainActor
    func kakaoLogout() {
        Task {
            if await handleKakaoLogout() {
                isLoggedIn = false
            }
        }
    }
    
    @MainActor
    func kakaoLogin() {
        Task {
            if (UserApi.isKakaoTalkLoginAvailable()) {
                isLoggedIn = await handleKakaoAppLogin()
            } else {
                isLoggedIn = await handleKakaoWebLogin()
            }
        }
    }
    
    @MainActor
    func getProfileNickName() {
        Task {
            nickName = await handleKakaoProfileNickname()
        }
    }
    
    @MainActor
    func handleKakaoProfileNickname() async -> String {
        await withCheckedContinuation { continuation in
            UserApi.shared.me { (user, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: "이름을 불러오지 못했습니다.")
                } else {
                    print("me() success.")
                    let nickName = user?.kakaoAccount?.profile?.nickname ?? "이름을 불러오지 못했습니다."
                    print(nickName)
                    continuation.resume(returning: nickName)
                }
            }
        }
    }
    
    
    
    // 카카오 로그인 함수
    @MainActor
    func handleKakaoAppLogin() async -> Bool {
        await withCheckedContinuation { continuation in
            // 카카오톡이 설치 되어 있을때
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    // 성공 시 동작 구현
                    _ = oauthToken
                    continuation.resume(returning: true)
                    self.getProfileNickName()
                }
            }
        }
        
    }  // handleKakaoAppLogin()
    
    // 카카오 웹뷰 로그인 함수
    @MainActor
    func handleKakaoWebLogin() async -> Bool {
        await withCheckedContinuation { continuation in
            // 웹 뷰로 로그인
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    
                    // 성공 시 동작 구현
                    _ = oauthToken
                    self.getProfileNickName()
                }
            }
        }
    }  // HandleKakaoWebLogin()
    
    
    
    // 카카오 로그아웃 함수
    @MainActor
    func handleKakaoLogout() async -> Bool {
        
        await withCheckedContinuation { continuation in
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("logout() success.")
                    continuation.resume(returning: true)
                    self.getProfileNickName()
                }
            }
        }
        
        
    } // handleKakaoLogout()
}

