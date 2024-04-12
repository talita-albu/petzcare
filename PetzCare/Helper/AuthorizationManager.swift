//
//  FirebAuth.swift
//  PetzCare
//
//  Created by Talita Albuquerque Araújo on 07/04/24.
//

import Foundation
import FirebaseAuth
import Firebase
import GoogleSignIn

enum AuthenticationError: Error {
    case userNotLogged
    case notPassedInformationToLog(String)
}

struct AuthDataResultModel {
    let uid: String
    let email: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
    }
}

final class AuthorizationManager {
    
    static let shared = AuthorizationManager()
    private init() {}
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func getAuthenticatedUser()  throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw AuthenticationError.userNotLogged
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func signinWithGoogle(presenting: UIViewController,
                          completion: @escaping (Error?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { result, error in
          if let error = error {
              completion(error)
            return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                guard error == nil else {
                    //Mostrar um alerta
                    completion(error)
                    return
                }
                
                completion(nil)
            }
        }
    }
}
