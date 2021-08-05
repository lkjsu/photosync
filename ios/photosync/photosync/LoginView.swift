//
//  LoginView.swift
//  photosync
//
//  Created by Aditya Kishan Ankaraboyana on 2/4/21.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
   @State private var email = ""
   @State private var password = ""
   @State private var auth_token:OSStatus = err_none
   @Binding var authenticated:Bool
   let keychain = KeyChainAccess()

    
    var body: some View {
        VStack {
            Color
                .gray
                .edgesIgnoringSafeArea(.all)
                .overlay(VStack {
            TextField("Email", text: self.$email)
                .offset(x: /*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/, y: -40)
                .autocapitalization(.none)
                .background(RoundedRectangle(cornerRadius: 50).fill(Color
                                                                                                                    .white).offset(x: 0, y: -40))
            SecureField("Password", text: self.$password)
                .offset(x: /*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/, y: -20)
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                .background(RoundedRectangle(cornerRadius: 50).fill(Color.white)
                                .offset(x: 0, y: -20))
            Button("Sign In", action: {
                self.login()
            })
            .foregroundColor(.white)
            .offset(y: -10)
            .background(Rectangle().fill(Color.gray)
                            .offset(y: -10))
                    SignInWithAppleButton(.signIn, onRequest: {(request) in
                    }, onCompletion: {(result) in
                        switch(result) {
                        case .success(let authorization):
                            break
                        case .failure(let error):
                            break
                        }
                    }).signInWithAppleButtonStyle(.black)
                    .fixedSize()
                }
            )
        }
    }
    
    func login() {
        debugPrint(#function)
        authenticated = keychain.validateAuthToken()
        if !keychain.validateAuthToken() {
            let returnCode = Auth().authenticate(email: self.email, password: self.password)
            debugPrint("Return code: Authenticate:",returnCode)
            if returnCode == 200 {
                authenticated = true
            }
            else {
                authenticated = false
            }
        }
    }
}


