// File.swift

import Foundation
import SwiftUI
import FirebaseAuth

public class MiseboxUserProfileViewModel: CanMiseboxUser, ObservableObject {
    public var email = "fire119@fire.com"
    public var password = "Hello1234"
    
    public let authenticationManager = AuthenticationManager()
    public let miseboxUserManager: MiseboxUserManager

    public init(miseboxUserManager: MiseboxUserManager) {
        self.miseboxUserManager = miseboxUserManager
    }
    
    public func onboardMiseboxUser() async {
        
        let docRef: MiseboxUserManager.MiseboxUserDocCollectionMarker = .miseboxUser
        
        do {
            if try await miseboxUserManager.checkMiseboxUserExistsInFirestore(doc: docRef) {
                miseboxUserManager.documentListener(for: docRef) { result in
                    switch result {
                    case .success(_):
                        print("Success listening to document")
                    case .failure(let error):
                        print("Error in document listener: \(error.localizedDescription)")
                    }
                }
            } else {
                print("User does not exist")
            }
        } catch {
            print("Error checking MiseboxUser in Firestore: \(error.localizedDescription)")
        }
    }
    
    public func verifyMiseboxUser(with accountType: MiseboxUserManager.AccountAuthenticationMethod = .email) async throws {
        print("MiseboxUserProfileViewModel[verifyUser] Verifying user with account type: \(accountType.rawValue)")
        do {
            switch accountType {
            case .email:
                self.miseboxUserManager.miseboxUserProfile.accountProviders = [accountType.rawValue]
                try await authenticationManager.linkEmail(email: email, password: password)
                try await miseboxUserManager.setMiseboxUserAndCreateProfile()
                await onboardMiseboxUser()
            case .other, .anon:
                // Handle other or anonymous login types if needed
                break
            }
        } catch {
            print("Error in account verification: \(error.localizedDescription)")
            throw error
        }
    }
    
    public func signOut() {
        do {
            try Auth.auth().signOut()
            miseboxUserManager.resetMiseboxUser()
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
}

public struct MiseboxUserProfileDashboard: View {
    @EnvironmentObject private var miseboxUser: MiseboxUserManager.MiseboxUser
    @EnvironmentObject private var miseboxUserProfile: MiseboxUserManager.MiseboxUserProfile
    @StateObject public var vm: MiseboxUserProfileViewModel

    public init(vm: MiseboxUserProfileViewModel) { 
           self._vm = StateObject(wrappedValue: vm)
       }
    
    public var body: some View {
        VStack {
            Button("Sign Out") {
                vm.signOut()
            }
            Form {
                UserInformationSection()
                AccountProvidersSection(accountProviders: miseboxUserProfile.accountProviders)

                if !miseboxUser.verified {
                    VerifyUserView(vm: vm, isOnboarding: false)
                }
            }
        }
    }
}

public struct UserInformationSection: View {
    @EnvironmentObject public var miseboxUser: MiseboxUserManager.MiseboxUser

    public var body: some View {
        Section(header: Text("User Information")) {
            TextField("Name", text: $miseboxUser.username)
            Text("User ID: \(miseboxUser.id)")
            Toggle("Verified", isOn: $miseboxUser.verified)
        }
    }
}

public struct AccountProvidersSection: View {
    public var accountProviders: [String]

    public init(accountProviders: [String]) {
        self.accountProviders = accountProviders
    }

    public var body: some View {
        Section(header: Text("Account Providers")) {
            ForEach(accountProviders, id: \.self) { provider in
                Text(provider)
            }
        }
    }
}
