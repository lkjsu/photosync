//
//  KeyChainAccess.swift
//  photosync
//
//  Created by Aditya Kishan Ankaraboyana on 3/14/21.
//

import Security
import Foundation

class KeyChainAccess {
    let tag = "com.sync.photosync.auth_token".data(using: .utf8)!
    
    func addAuthToken(auth_token: String) throws {
        let addQuery: [String:Any] = [kSecClass as String: kSecClassKey,
                                      kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
                                      kSecAttrApplicationTag as String: tag,
                                      kSecValueData as String: auth_token.data(using: String.Encoding.utf8)]
        let status = SecItemAdd(addQuery as CFDictionary, nil)
        debugPrint(#function," status:",status)
        guard status == errSecSuccess || status == errSecDuplicateItem else { throw Auth.AuthError.KeyChainAccessError}
    }
    
    func retrieveAuthToken() -> String {
        debugPrint(#function)
        let getQuery: [String:Any] = [kSecClass as String: kSecClassKey,
                                      kSecAttrApplicationTag as String: tag,
                                      kSecReturnData as String: true]
        debugPrint(getQuery)
        var item: CFTypeRef!
        let status = SecItemCopyMatching(getQuery as CFDictionary, &item)
        guard status == errSecSuccess else {
            debugPrint(#function," status:",status)
            return #function+" query not found"
        }
        let key = item as! Data
        return String(data: key, encoding: .utf8) ?? "notFound"
    }
    
    func checkAuthToken() -> Bool {
        let getQuery: [String:Any] = [kSecClass as String: kSecClassKey,
                                      kSecAttrApplicationTag as String: tag,
                                      kSecReturnData as String: true]
        debugPrint(getQuery)
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getQuery as CFDictionary, &item)
        print(#function," status:", status)
        if status == errSecDuplicateItem || status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
    func validateAuthToken() -> Bool {
        /* TODO:
         Validate auth token with server
        */
        let auth_token = retrieveAuthToken()
        debugPrint(auth_token)
        let isValidToken = Auth().checkAuthentication(auth_token: auth_token)
        if !isValidToken {
            debugPrint(#function)
            return deleteAuthToken()
        }
        return isValidToken
    }
    
    func deleteAuthToken() -> Bool{
        debugPrint(#function)
        let getQuery: [String:Any] = [kSecClass as String: kSecClassKey,
                                      kSecAttrApplicationTag as String: tag,
                                      kSecReturnData as String: true]
        debugPrint(getQuery)
        let status = SecItemDelete(getQuery as CFDictionary)
        guard status == errSecSuccess else {
            debugPrint(#function," status:",status)
            return false
        }
        return true
    }
}
