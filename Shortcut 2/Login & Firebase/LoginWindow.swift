//
//  loginWindow.swift
//  Shortcut-2
//
//  Created by Stanislav on 03.06.2024.
//

import SwiftUI
import AuthenticationServices
import Firebase
import CryptoKit

struct LoginWindow: View {
    @State private var errorMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var isLoading: Bool = false
    @State private var nonce: String?
    @AppStorage("loginStatus_key") private var userIsLoggedIn: Bool = false
    var body: some View {
        VStack{
            Spacer()
            VStack{
                Text("Please Login:")
                SignInWithAppleButton(.signIn) { request in
                    let nonce = randomNonceString()
                    // Настройки чисто sign in
                    request.requestedScopes = [.email, .fullName ]
                    request.nonce = sha256(nonce)
                    self.nonce = nonce
                } onCompletion: { result in
                    switch result {
                    case .success(let authorization):
                        loginWithFirebase(authorization)
                    case .failure(let error):
                        showError(error.localizedDescription)
                    }
                }
                .frame(height: 50)
            }
            Spacer()
        }
        .alert(errorMessage, isPresented: $showAlert) {
            
        }
        .overlay{
            if isLoading {
                Text("Loading...")
            }
        }
    }
    
//    @ViewBuilder
//    func LoadingScreen() -> some View {
//        ZStack{
//            Rectangle()
//            .fill(.ultraThinMaterial)
//        }
//        LoadingView()
//            .frame(width: 45, height: 45)
//            .background(.background, in: .rect(corderRadius:5))
//    }
    
    func showError(_ message: String) {
        errorMessage = message
        showAlert.toggle()
        isLoading = false
    }
    func loginWithFirebase(_ authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            isLoading = true
          guard let nonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
          }
          guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
          }
          guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
          }
          // Initialize a Firebase credential, including the user's full name.
          let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                            rawNonce: nonce,
                                                            fullName: appleIDCredential.fullName)
          // Sign in with Firebase.
          Auth.auth().signIn(with: credential) { (authResult, error) in
              if (error != nil) {
              // Error. If error.code == .MissingOrInvalidNonce, make sure
              // you're sending the SHA256-hashed nonce as a hex string with
              // your request to Apple.
                  print(error?.localizedDescription)
              return
            }
              userIsLoggedIn = true
            // User is signed in to Firebase with Apple.
            // ...
          }
        }
    }
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}

#Preview {
    LoginWindow()
}
