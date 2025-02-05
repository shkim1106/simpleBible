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
    func handleKakaoLogin() {
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카카오톡이 설치 되어 있을때
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    // 성공 시 동작 구현
                    _ = oauthToken
                    UserApi.shared.me() {(user, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            print("me() success.")
                            // 성공 시 동작 구현
                            _ = user
                        }
                    }
                }
            }
        } else {  // 카카오톡이 설치 되어있지 않을때
            // 웹 뷰로 로그인
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("loginWithKakaoAccount() success.")

                        // 성공 시 동작 구현
                        _ = oauthToken
                    }
                }
        }

    }
}

