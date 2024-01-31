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
    @State private var firstName = ""
    @State private var lastName = ""

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

                Button(action: {
                    Task { try? await vm.verifyMiseboxUser(with: .anon) }
                }) {
                    Text("Skip")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }

            Text("Enter a username for the misebox ecosystem")
                .font(.headline)

            TextField("Username", text: $username)
                .textCase(.lowercase)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Text("And your Full Name")
                .font(.headline)

            HStack {
                TextField("First", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Surname", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()

            Button(action: {
                Task {
                    vm.miseboxUserManager.miseboxUser.username = username
                    vm.miseboxUserManager.miseboxUserProfile.fullName.first = firstName
                    vm.miseboxUserManager.miseboxUserProfile.fullName.last = lastName
                    try? await vm.verifyMiseboxUser(with: .email)
                }
            }) {
                Text("Sign In with Email")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
