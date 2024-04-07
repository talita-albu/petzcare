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
    @Binding var showLoginView: Bool
    
    var body: some View {
        List {
            Button("Log out") {
                Task {
                    do {
                        try viewModel.logOut()
                        showLoginView = true
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
            SettingsView(showLoginView: .constant(false))
        }
    }
}
