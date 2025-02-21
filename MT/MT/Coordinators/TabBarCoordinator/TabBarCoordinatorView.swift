//
//  TabBarCoordinatorView.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import SwiftUI

struct TabBarCoordinatorView: View {
    @StateObject var coordinator: TabBarCoordinator

    var body: some View {
        VStack {
            Spacer()
            
            TabView(selection: $coordinator.selectedDestination) {
                ForEach(coordinator.destinations.indices, id: \.self) { index in
                    let destination = coordinator.destinations[index]
                    
                    destination
                        .tabItem {
                            Image(systemName: coordinator.selectedDestination == index ? destination.iconSelected : destination.icon)
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            TypographyText(text: destination.title, typography: .smallText)
                                .multilineTextAlignment(.center)
                                .lineLimit(1)
                        }
                        .tag(index)
                }
                .toolbarBackground(.white, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
            }
        }
        .ignoresSafeArea()
    }
}
