//
//  photosyncApp.swift
//  photosync
//
//  Created by Aditya Kishan Ankaraboyana on 2/4/21.
//

import SwiftUI

/* TODO:
     Check why after auth expiry login doesn't fail on the backend.
 */

@main
struct photosyncApp: App {
    @State private var authenticated: Bool = false
    var body: some Scene {
        WindowGroup {
            if KeyChainAccess().validateAuthToken() {
                ImageSelectorView()
            }
            else{
                LoginView(authenticated: self.$authenticated)
            }
        }
    }
}
