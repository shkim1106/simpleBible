//
//  LoginView.swift
//  simpleBible
//
//  Created by shkim on 2/25/25.
//

import SwiftUI

struct LoginView: View {
    @Binding var selectedTab: Int

    @State private var username = ""
    @State private var password = ""

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            // Header
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()

            // Background image or color
            Image(systemName: "moon.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 150)
                .clipped()
                .cornerRadius(10)

            // Username field
            HStack {
                Text("Username:")
                    .foregroundColor(.gray)
                TextField("username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.default)
            }
            .padding()

            // Password field
            HStack {
                Text("Password:")
                    .foregroundColor(.gray)
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.default)
            }
            .padding()

            // Login button
            Button(action: {
                print("Login button pressed")
            }) {
                Text("Login")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()

            // Forgot password link
            HStack {
                Text("Forgot Password?")
                    .foregroundColor(.gray)
                Link(destination: URL(string: "https://example.com/forgot-password")!, label: {
                    Text("Link")
                        .foregroundColor(.blue)
                })
            }
            .padding()

            // Registration link
            HStack {
                Text("Don't have an account? Register now!")
                    .foregroundColor(.blue)
                Link(destination: URL(string: "https://example.com/register")!, label: {
                    Text("Register Now")
                        .foregroundColor(.white)
                })
            }
            .padding()

            // Bottom border
            Rectangle()
                .fill(Color.gray)
                .frame(height: 1)
                .padding()
        }
        .padding()
    }
}
