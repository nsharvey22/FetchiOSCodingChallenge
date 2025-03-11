import Foundation

struct MealResponse: Codable {
    let meals: [Meal]
}

struct MealListItemResponse: Codable {
    let meals: [MealListItem]
}

struct MealListItem: Codable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    
    var id: String { idMeal }
}

struct Meal: Codable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strInstructions: String
    let strMealThumb: String
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    let strIngredient16: String?
    let strIngredient17: String?
    let strIngredient18: String?
    let strIngredient19: String?
    let strIngredient20: String?
    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    let strMeasure6: String?
    let strMeasure7: String?
    let strMeasure8: String?
    let strMeasure9: String?
    let strMeasure10: String?
    let strMeasure11: String?
    let strMeasure12: String?
    let strMeasure13: String?
    let strMeasure14: String?
    let strMeasure15: String?
    let strMeasure16: String?
    let strMeasure17: String?
    let strMeasure18: String?
    let strMeasure19: String?
    let strMeasure20: String?
    
    var id: String { idMeal }
    
    var ingredientsAndMeasurements: [(ingredient: String, measurement: String)] {
        var result: [(String, String)] = []
        
        // Mirror to reflect properties
        let mirror = Mirror(reflecting: self)
        
        var ingredients: [String] = []
        var measurements: [String] = []
        
        for child in mirror.children {
            if let label = child.label {
                if label.hasPrefix("strIngredient"), 
                   let ingredient = child.value as? String,
                   !ingredient.isEmpty {
                    ingredients.append(ingredient)
                }
                if label.hasPrefix("strMeasure"),
                   let measurement = child.value as? String,
                   !measurement.isEmpty {
                    measurements.append(measurement)
                }
            }
        }
        
        // Pair ingredients with measurements
        for i in 0..<min(ingredients.count, measurements.count) {
            result.append((ingredients[i], measurements[i]))
        }
        
        return result
    }
}
