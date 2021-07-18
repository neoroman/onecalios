//
//  OnecaliosApp.swift
//  onecalios
//
//  Created by Henry Kim on 2021/07/09.
//

import SwiftUI

@main
struct OnecaliosApp: App {
    let userManager = UserManager()
    
    init() {
        userManager.load()
    }
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
        }
    }
}
