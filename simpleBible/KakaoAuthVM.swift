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

import FirebaseAuth

struct Profile: Identifiable {
    let id: Int64
    var nickName: String
    var profileImageUrl: URL?
}


class KakaoAuthVM: ObservableObject {
    @EnvironmentObject var firebaseVM: FirebaseVM  // ViewModel 인스턴스를 사용
    
    @Published var isLoggedIn: Bool = false
    @Published var userProfile = Profile(id: 0, nickName: "Please Login First", profileImageUrl: URL(string: "https://www.example.com"))
    
    
    
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
                            print("토큰 갱신")
                            
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
                    self.handleFirebaseKakaoLogin { success in
                        if success {
                            print("카카오 로그인 및 Firebase Auth 성공!")
                        } else {
                            print("로그인 실패")
                        }
                    }
                }
            }
        }
    } // handleKakoProfileNickname()
    
    
    
    
    /// 카카오 로그인 후 Firebase Auth에 가입/로그인
        func handleFirebaseKakaoLogin(completion: @escaping (Bool) -> Void) {
            UserApi.shared.me { user, error in
                if let error = error {
                    print("카카오 로그인 에러: \(error.localizedDescription)")
                    completion(false)
                } else {
                    guard let email = user?.kakaoAccount?.email else {
                        print("카카오 이메일 정보가 없음")
                        completion(false)
                        return
                    }
                    let kakaoID = "\(user?.id ?? 0)"  // 카카오 고유 ID를 비밀번호로 사용
                    
                    // Firebase Auth에 가입하거나 로그인
                    self.registerOrSignInWithFirebase(email: email, password: kakaoID) { success in
                        completion(success)
                    }
                }
            }
        }
    /// Firebase Auth 가입 또는 로그인 처리
    private func registerOrSignInWithFirebase(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error as NSError?, error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                // 이메일이 이미 사용 중이라면 로그인 시도
                Auth.auth().signIn(withEmail: email, password: password) { _, error in
                    completion(error == nil)
                }
            } else {
                // 새 계정이 성공적으로 만들어졌다면
                completion(error == nil)
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
                    self.isLoggedIn = false
                    // Firebase 로그아웃 시도
                    do {
                        try Auth.auth().signOut()
                        print("Firebase 로그아웃 성공")
                    } catch let signOutError as NSError {
                        print("Firebase 로그아웃 실패: \(signOutError.localizedDescription)")
                    }
                }
            }
        }
        
        
    } // handleKakaoLogout()
}
