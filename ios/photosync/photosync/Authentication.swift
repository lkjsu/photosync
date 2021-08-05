//
//  Authentication.swift
//  photosync
//
//  Created by Aditya Kishan Ankaraboyana on 2/13/21.
//

import Foundation
import SwiftUI
import Security

//figure this bit out
struct LoginPayload: Codable {
    let email: String
    let password: String
}

struct AuthPayload: Codable {
    let auth_token: String
}

class Auth {
    struct AuthError{
        enum AuthenticationError: Error{
            case KeyChainAccessError
        }
    }
    
    func authenticate(email: String, password: String) -> Int{
        debugPrint(#function)
        var auth_token:String = ""
        let authUrl = URL(string: "http://localhost:5000/auth/login")!
        var request = URLRequest(url: authUrl)
        var returnCode = 500
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let loginPayload = LoginPayload(email: email, password: password)
        guard let uploadData = try? JSONEncoder().encode(loginPayload) else {
            return 500
        }
        let semaphore = DispatchSemaphore(value: 0)
        let logintask = URLSession.shared.uploadTask(with: request, from: uploadData) {
            data, response, error in
            if let error = error {
                print("error: \(error)")
            }
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
//                debugPrint(response)
                let ret = response as? HTTPURLResponse
                returnCode = ret?.statusCode ?? 500
                debugPrint(ret?.description)
                semaphore.signal()
                return
            }
            returnCode = response.statusCode
            if returnCode == 200 {
                if let mimeType = response.mimeType,
                   mimeType == "application/json",
                   let data = data,
                   let _ = String(data: data, encoding: .utf8) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                        auth_token = json?["auth_token"] as? String ?? "something else"
                        try KeyChainAccess().addAuthToken(auth_token: auth_token)
                        returnCode = 200
                        semaphore.signal()
                    } catch {
                        print("Something is wrong")
                }
            }
            }
        }
        logintask.resume()
        semaphore.wait()
        return returnCode
    }
    
    func checkAuthentication(auth_token: String) -> Bool{
        debugPrint(#function)
        var isValid = false
        let authUrl = URL(string: "http://localhost:5000/auth/status")!
        var request = URLRequest(url: authUrl)
        request.httpMethod = "GET"
        request.setValue("auth_token "+auth_token, forHTTPHeaderField: "Authorization")

        let semaphore = DispatchSemaphore(value: 0)
        let authtask = URLSession.shared.dataTask(with: request){
            data, response, error in
            if let error = error {
                print("error: \(error)")
            }
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                semaphore.signal()
                return
            }
            if let mimeType = response.mimeType,
               mimeType == "application/json",
               let data = data,
               let _ = String(data: data, encoding: .utf8) {
                do {
                    debugPrint(data)
                    isValid = true
                    semaphore.signal()
                } catch {
                    print(#function,"Something is wrong")
            }
        }
        }
        authtask.resume()
        semaphore.wait()
        debugPrint(#function, isValid)
        return isValid
    }
}
