//
//  simpleBibleApp.swift
//  simpleBible
//
//  Created by shkim on 2/1/25.
//

import SwiftUI

import KakaoSDKCommon
import KakaoSDKAuth

import Firebase


@main
struct simpleBibleApp: App {
    // ViewModel 인스턴스 (전역적으로 사용)
        @StateObject var firebaseVM = FirebaseVM()
        @StateObject var viewModel = BibleVM()
    
    init() {
        // Kakao SDK 초기화
        let kakaoAppkey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        KakaoSDK.initSDK(appKey: kakaoAppkey as! String)
        print("KEY IS: \(kakaoAppkey)")
        
        // Firebase 초기화
        FirebaseApp.configure()
        print("Firebase 초기화")
    }
    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(.light)
                .onOpenURL(perform: { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        let result = AuthController.handleOpenUrl(url: url)
                        if result {
                            print("카카오톡 URL 처리 성공")
                        } else {
                            print("카카오톡 URL 처리 실패")
                        }
                    }
                })  // onOpenURL()을 사용해 커스텀 URL 스킴 처리
                .environmentObject(firebaseVM)  // ViewModel을 하위 View로 전달
                .environmentObject(viewModel)  // ViewModel을 하위 View로 전달
        }
    }
}
