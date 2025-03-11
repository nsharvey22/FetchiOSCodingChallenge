import SwiftUI

struct MealDetailView: View {
    let mealId: String
    @StateObject private var viewModel = DessertsViewModel()
    
    var body: some View {
        ScrollView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    Text(error.localizedDescription)
                        .foregroundColor(.red)
                } else if let meal = viewModel.selectedMealDetails {
                    VStack(alignment: .leading, spacing: 16) {
                        AsyncImage(url: URL(string: meal.strMealThumb )) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Text(meal.strMeal)
                            .font(.title)
                            .bold()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Instructions")
                                .font(.title2)
                                .bold()
                            
                            Text(meal.strInstructions)
                        }
                        
                        if !meal.ingredientsAndMeasurements.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Ingredients")
                                    .font(.title2)
                                    .bold()
                                
                                ForEach(Array(meal.ingredientsAndMeasurements.enumerated()), id: \.offset) { index, item in
                                    Text("\(item.measurement) \(item.ingredient)")
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .task {
            await viewModel.loadMealDetails(for: mealId)
        }
    }
}

#Preview {
    MealDetailView(mealId: "53049")
}
