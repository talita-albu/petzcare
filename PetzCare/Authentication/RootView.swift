//
//  RootView.swift
//  PetzCare
//
//  Created by Talita Albuquerque Araújo on 07/04/24.
//

import SwiftUI

struct RootView: View {
    @State private var showLoginView = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                SettingsView(showLoginView: $showLoginView)
            }
        }
        .onAppear{
            let authUser = try? FirebAuth.shared.getAuthenticatedUser()
            self.showLoginView = authUser == nil
        }
        .fullScreenCover(isPresented: $showLoginView){
            NavigationStack {
                LoginView(showLoginView: $showLoginView)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
