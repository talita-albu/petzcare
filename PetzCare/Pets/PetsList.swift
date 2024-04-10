//
//  PetsList.swift
//  PetzCare
//
//  Created by Talita Albuquerque Araújo on 09/04/24.
//

import SwiftUI
import Firebase

@MainActor
final class PetViewModel: ObservableObject {
    
    @Published private(set) var user: AuthDataResultModel? = nil
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    @Published var pets: [Pet] = []
    
    func loadCurentUser() throws {
        self.user = try FirebAuth.shared.getAuthenticatedUser()
    }
    
    func loadPets() throws {
        try loadCurentUser()
        PetManager.shared.loadPets(userID: user?.uid ?? "0"){ pets in
            self.pets = pets
        }
        
    }
}
    
struct PetsList: View {
    
    @State private var showingAddPetView = false
    @State private var showingSettingsView = false
    @State private var newPet = Pet(id: "", name: "", birthDate: Date(), type: "dog", gender: "male", userID: "0")
    @StateObject private var viewModel = PetViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.pets) { pet in
                    VStack(alignment: .leading) {
                        Text("Name: \(pet.name)")
                        Text("Species: \(pet.type)")
                        Text("Birth Date: \(formattedDate(pet.birthDate))")
                    }
                }
                
                HStack {
                    Button {
                        self.showingAddPetView.toggle()
                    } label: {
                        Text("Add Pet")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.cyan)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $showingAddPetView) {
                        AddPetView(showingAddPetView: $showingAddPetView, newPet: $newPet)
                            .onDisappear {
                                if !self.newPet.name.isEmpty {
                                    do {
                                        try viewModel.loadCurentUser()
                                        try PetManager.shared.savePet(newPet: self.newPet, user: viewModel.user?.uid ?? "0")
                                    } catch {
                                        viewModel.alertTitle = "Alert"
                                        viewModel.alertMessage = "Pet not saved"
                                        viewModel.showAlert = true
                                    }
                                    
                                    do {
                                        try viewModel.loadPets()
                                    } catch {
                                        viewModel.alertTitle = "Alert"
                                        viewModel.alertMessage = "Pets not loaded"
                                        viewModel.showAlert = true
                                    }
                                }
                            }
                    }.alert(isPresented: $viewModel.showAlert, content: {
                        getAlert()
                    })
                    
                    NavigationLink {
                        SettingsView(showSignInView: $showSignInView)
                    } label: {
                            Text("Settings")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(height: 55)
                                .frame(maxWidth: .infinity)
                                .background(Color.indigo)
                                .cornerRadius(10)
                        }
                }.padding()
            }
            .navigationBarTitle("Pet Registry")
        }
        .onAppear {
            do {
                try viewModel.loadPets()
            } catch {
                viewModel.alertTitle = "Alert"
                viewModel.alertMessage = "Pets not loaded"
                viewModel.showAlert = true
            }
        }
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text(viewModel.alertTitle),
                     message: Text(viewModel.alertMessage),
                     dismissButton: .default(Text("Ok")))
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
    
struct PetsList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PetsList(showSignInView: .constant(false))
        }
    }
}

