//
//  CreateVehicleView.swift
//  SimpleVehicleManagementSystem
//
//  Created by Nishu Nishanta on 25/01/25.
//

import SwiftUI

struct SelectBrandView: View {
    @ObservedObject var createVM: CreateVehicleViewModel
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var isSearchBarFocused: Bool // Focus state for the search bar
    var body: some View {
        ZStack {
            Color(.darkGray)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                searchBar
                
                List {
                    
                    ForEach(createVM.filteredBrands) { brand in
                        // NavigationLink: tapping a brand -> Series screen
                        NavigationLink(
                            destination: SelectSeriesView(createVM: createVM)
                                .onAppear {
                                    // Set the brand as soon as we navigate
                                    createVM.selectedBrand = brand
                                }
                        ) {
                            HStack {
                                Text(brand.brandName)
                                    .foregroundColor(.white)
                                Spacer()
                                
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
        }.onAppear{
            createVM.searchQuery = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isSearchBarFocused = true // Set focus after a short delay
            }
        }
        
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    createVM.selectedBrand = nil
                    createVM.selectedSeries = nil
                    createVM.selectedYear = nil
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                    
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Car selection")
                    .foregroundColor(.white)
                    .font(.headline)
            }
        }
    }
    
    private var searchBar: some View {
        HStack(spacing: 8) {
            TextField(
                "",
                text: $createVM.searchQuery,
                prompt: { Text("Search for brand ...").foregroundColor(.white.opacity(0.6)) }()
            )
            .focused($isSearchBarFocused)
            .foregroundColor(.white)
            
            Image("searchIcon")
                .foregroundColor(.white)
        }
        .padding(8)
        .background(Color.black)
        .cornerRadius(8)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
