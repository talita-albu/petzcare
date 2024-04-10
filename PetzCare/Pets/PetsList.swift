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
        NavigationStack {
            VStack {
                List(viewModel.pets) { pet in
                    
                    HStack {
                        Image(pet.type)
                            .resizable()
                            .font(.largeTitle)
                            .bold()
                            .symbolRenderingMode(.monochrome)
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        VStack(alignment: .leading) {
                            Text(pet.name)
                                .font(.title)
                                .bold()
                            Text(pet.type)
                        }
                        Spacer()
                        Image(systemName: "ellipsis")
                            .resizable()
                            .symbolRenderingMode(.monochrome)
                            .scaledToFit()
                            .frame(width: 20, height: 20)


                    }
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .cornerRadius(16)
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
                    
                    Button {
                        self.showingSettingsView.toggle()
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
            .navigationTitle("Pet Registry")
            .navigationDestination(isPresented: $showingSettingsView) {
                SettingsView(showingSettingsView: $showingSettingsView)
            }
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

