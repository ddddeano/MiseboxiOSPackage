//
//  File.swift
//  
//
//  Created by Daniel Watson on 23.01.24.
//

import Foundation
import SwiftUI

public struct VerifyUserView: View {
    public var vm: CanMiseboxUser
    public var isOnboarding: Bool
    @State private var username = ""

    public var body: some View {
        VStack(spacing: 20) {
            if isOnboarding {
                Image("LogoType")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 50)

                Button("Skip") {
                    Task {
                        try? await vm.verifyMiseboxUser(with: .anon)
                    }
                }
            }

            TextField("Enter your name", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Sign In with Email") {
                Task {
                    vm.miseboxUserManager.miseboxUser.username = username
                    try? await vm.verifyMiseboxUser(with: .email)
                }
            }
        }
//        .padding()
    }
}
