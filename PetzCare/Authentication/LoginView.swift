//
//  LoginView.swift
//  PetzCare
//
//  Created by Talita Albuquerque Araújo on 07/04/24.
//

import SwiftUI

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            showAlert = true
            alertTitle = "Attention"
            throw AuthenticationError.notPassedInformationToLog("Email and Password must be valid.")
        }
        
        let _ = try await AuthorizationManager.shared.createUser(email: email, password: password)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            showAlert = true
            alertTitle = "Attention"
            throw AuthenticationError.notPassedInformationToLog("Email and Password must be valid.")
        }

        let _ = try await AuthorizationManager.shared.signInUser(email: email, password: password)
    }
}

struct LoginView: View {
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            Image("petz")
                .resizable()
                .font(.largeTitle)
                .bold()
                .symbolRenderingMode(.monochrome)
                .scaledToFit()
            
            TextField("Email...", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            SecureField("Password...", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            HStack {
                Button {
                    Task {
                        do {
                            try await viewModel.signIn()
                            showSignInView = false
                        } catch {
                            viewModel.showAlert = true
                            viewModel.alertTitle = "Attention"
                            viewModel.alertMessage = "\(error)"
                        }
                    }
                } label: {
                    Text("Sing in")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.mint)
                        .cornerRadius(10)
                }
                
                Button {
                    Task {
                        do {
                            try await viewModel.signUp()
                            showSignInView = false
                        } catch {
                            viewModel.showAlert = true
                            viewModel.alertTitle = "Attention"
                            viewModel.alertMessage = "\(error)"
                        }
                    }
                } label: {
                    Text("Sing Up and Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.indigo)
                        .cornerRadius(10)
                }.alert(isPresented: $viewModel.showAlert, content: {
                    getAlert()
                })
            }
            
            Text("or")
                .padding()
            
            GoogleSiginBtn {
                AuthorizationManager.shared.signinWithGoogle(presenting: getRootViewController()) {error in
                    if let error = error {
                        viewModel.showAlert = true
                        viewModel.alertTitle = "Attention"
                        viewModel.alertMessage = "\(error)"
                    } else {
                        showSignInView = false
                    }
                }
            }.alert(isPresented: $viewModel.showAlert, content: {
                getAlert()
            })
            
        }
        .padding()
        .navigationTitle("Petz Care")
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text(viewModel.alertTitle),
                     message: Text(viewModel.alertMessage),
                     dismissButton: .default(Text("Ok")))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoginView(showSignInView: .constant(true))
        }
    }
}
