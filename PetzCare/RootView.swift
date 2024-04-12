//
//  RootView.swift
//  PetzCare
//
//  Created by Talita Albuquerque Araújo on 07/04/24.
//

import SwiftUI

struct RootView: View {
    @State private var showSignInView = false
    
    var body: some View {
        ZStack {
            if !showSignInView {
                NavigationStack {
                    PetzInitialControl(showSignInView: $showSignInView)
                }
            }
        }
        .onAppear{
            let authUser = try? AuthorizationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView){
            NavigationStack {
                LoginView(showSignInView: $showSignInView)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
