//
//  QiitaSwiftClientApp.swift
//  QiitaSwiftClient
//
//  Created by erika yoshikawa on 2024/07/09.
//

import SwiftUI

@main
struct QiitaSwiftClientApp: App {
    @StateObject var userStateViewModel = UserStateViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
            .environmentObject(userStateViewModel)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var userStateViewModel: UserStateViewModel
    @AppStorage("AccessToken") private var accessToken: String = ""

    var body: some View {
        if accessToken != "" {
            TabView {
                HomeScreen()
                    .tabItem {
                        Label("ホーム", systemImage: "house.fill")
                    }
                SearchScreen()
                    .tabItem {
                        Label("検索", systemImage: "magnifyingglass")
                    }
            }
        } else {
            LoginScreen()
        }
    }
}
