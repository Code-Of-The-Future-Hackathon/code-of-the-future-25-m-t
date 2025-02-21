//
//  MTApp.swift
//  MT
//
//  Created by Ivan Gamov on 21.02.25.
//

import SwiftUI
import GoogleSignIn


@main
struct MTApp: App {
    @StateObject var appCoordinator = AppCoordinator()
    @StateObject private var locationManager = LocationManager()

    var body: some Scene {
        WindowGroup {
            ZStack {
                appCoordinator.start()
                    .preferredColorScheme(.light)
                    .onOpenURL { url in
                        GIDSignIn.sharedInstance.handle(url)
                    }
                    .environmentObject(locationManager)
            }
        }
    }
}
