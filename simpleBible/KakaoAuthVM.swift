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

struct Profile: Identifiable {
    let id: Int64
    var nickName: String
    var profileImageUrl: URL?
}


class KakaoAuthVM: ObservableObject {
    
    @Published var isLoggedIn: Bool = false
    @Published var userProfile = Profile(id: 0, nickName: "Please Login First", profileImageUrl: URL(string: "https://www.a.com"))
    
    
    @MainActor
    func autoLogin() {
        if AuthApi.hasToken() {
            UserApi.shared.accessTokenInfo { _, error in
                if let error = error {
                    print("토큰 확인 에러 \(error.localizedDescription)")
                    Task {
                        self.kakaoLogin()
                    }
                } else {
                    // 토큰 유효성 체크 성공 (필요 시 토큰 갱신됨)
                    print("토큰 확인 성공")
                    UserApi.shared.me { user, error in
                        if let error = error {
                            print("기존회원 로그인 에러 발생 \(error.localizedDescription)")
                        } else {
                            print("기존 회원 로그인 진행 ")
                            self.getProfile()
                            self.isLoggedIn = true
                        }
                    }
                }
            }
        }
    }
    
    
    // 외부용 메인 로그인 메서드
    @MainActor
    func kakaoLogin() {
        Task {
            if (UserApi.isKakaoTalkLoginAvailable()) {
                print("카카오톡 설치됨")
                isLoggedIn = await handleKakaoAppLogin()
            } else {
                print("카카오톡 미설치, 웹 로그인 진행")
                isLoggedIn = await handleKakaoWebLogin()
            }
        }
    }
    
    @MainActor
    func kakaoLogout() {
        Task {
            if await handleKakaoLogout() {
                isLoggedIn = false
            }
        }
    }
    
    
    @MainActor
    func getProfile() {
        Task {
            userProfile = await handleKakaoProfile()
        }
    }
    
    
    // 카카오 프로필 정보 가져오는 함수
    @MainActor
    func handleKakaoProfile() async -> Profile {
        await withCheckedContinuation { continuation in
            UserApi.shared.me { (user, error) in
                if let error = error {
                    print(error)
                    let emptyProfile = Profile(id: 0, nickName: "unknown", profileImageUrl: nil)
                    continuation.resume(returning: emptyProfile)
                } else {
                    print("프로필 가져오기 성공")
                    let id = user?.id ?? 0
                    let nickName = user?.kakaoAccount?.profile?.nickname ?? "unknown"
                    let loggedInProfile = Profile(id: id, nickName: nickName, profileImageUrl: user?.kakaoAccount?.profile?.profileImageUrl)
                    continuation.resume(returning: loggedInProfile)
                }
            }
        }
    } // handleKakoProfileNickname()
    
    
    
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
                    print("카카오톡 로그인 성공")
                    // 성공 시 동작 구현
                    _ = oauthToken
                    continuation.resume(returning: true)
                    self.getProfile()
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
                    print("카카오 계정 로그인 성공")
                    
                    // 성공 시 동작 구현
                    _ = oauthToken
                    self.getProfile()
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
                    print("로그아웃 성공")
                    continuation.resume(returning: true)
                    self.getProfile()
                }
            }
        }
        
        
    } // handleKakaoLogout()
}
