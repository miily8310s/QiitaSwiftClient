//
//  LoginScreen.swift
//  QiitaSwiftClient
//
//  Created by erika yoshikawa on 2024/07/15.
//

import SwiftUI

struct LoginScreen: View {
    @StateObject private var viewModel = UserStateViewModel()

    var body: some View {
        ZStack {
            Color(red: 85 / 255, green: 197 / 255, blue: 0)
            VStack {
                VStack {
                    Text("Qiita App")
                        .font(.title)
                    Text("Qiitaサンプルクライアント")
                        .font(.caption)
                }
                Button("Qiitaログイン") {
                    viewModel.signIn()
                }
                .padding()
                .foregroundStyle(.green)
                .background(.white)
            }
        }
    }
}

#Preview {
    LoginScreen()
}
