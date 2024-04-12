//
//  PetzInitialControl.swift
//  PetzCare
//
//  Created by Talita Albuquerque Araújo on 12/04/24.
//

import SwiftUI

struct PetzInitialControl: View {
    @Binding var showSignInView: Bool
    
    var body: some View {
        TabView {
            NavigationStack {
                PetsList(showSignInView: $showSignInView)
            }
            .tabItem {
                Image(systemName: "teddybear")
                Text("Pets")
            }
            
            NavigationStack {
                SettingsView(showSignInView: $showSignInView)
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Profile")
            }
        }
    }
}

struct PetzInitialControl_Previews: PreviewProvider {
    static var previews: some View {
        PetzInitialControl(showSignInView: .constant(false))
    }
}
