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

    public init(vm: CanMiseboxUser, isOnboarding: Bool) {
        self.vm = vm
        self.isOnboarding = isOnboarding
    }

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
            Text("Enter a username for the misebox ecosysytem")
            TextField("Username", text: $username)
                .textCase(.lowercase)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Sign In with Email") {
                Task {
                    vm.miseboxUserManager.miseboxUser.username = username
                    try? await vm.verifyMiseboxUser(with: .email)
                }
            }
        }
    }
}
