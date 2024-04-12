//
//  SettingsView.swift
//  PetzCare
//
//  Created by Talita Albuquerque Araújo on 07/04/24.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
    func logOut() throws {
        try FirebAuth.shared.signOut()
    }
}

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            Button("Log out") {
                Task {
                    do {
                        try viewModel.logOut()
                        showSignInView = true
                    } catch {
                        
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(showSignInView: .constant(false))
        }
    }
}
