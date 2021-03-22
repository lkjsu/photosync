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
            .background(Rectangle().fill(Color.blue)
                            .offset(y: -10))
                }
            )
        }
    }
    
    func login() {
        debugPrint(#function)
        let keychain = KeyChainAccess()
        authenticated = keychain.validateAuthToken()
        if !keychain.validateAuthToken() {
            Auth().authenticate(email: self.email, password: self.password)
            authenticated = true
        }
    }
}


