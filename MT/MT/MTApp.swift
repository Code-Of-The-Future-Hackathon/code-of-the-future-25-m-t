//
//  MTApp.swift
//  MT
//
//  Created by Ivan Gamov on 21.02.25.
//

import SwiftUI

@main
struct MTApp: App {
    @StateObject var appCoordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            ZStack {
                appCoordinator.start()
                    .preferredColorScheme(.light)
            }
        }
    }
}
