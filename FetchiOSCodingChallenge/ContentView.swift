//
//  ContentView.swift
//  FetchiOSCodingChallenge
//
//  Created by Nicholas Harvey on 3/11/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DessertsViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    Text(error.localizedDescription)
                        .foregroundColor(.red)
                } else {
                    List(viewModel.desserts) { dessert in
                        NavigationLink(destination: MealDetailView(mealId: dessert.idMeal)) {
                            Text(dessert.strMeal)
                        }
                    }
                }
            }
            .navigationTitle("Desserts")
        }
        .task {
            await viewModel.loadDesserts()
        }
    }
}

#Preview {
    ContentView()
}
