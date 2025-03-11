import Foundation

protocol APIServiceProtocol {
    func fetchDesserts() async throws -> [MealListItem]
    func fetchMealDetails(id: String) async throws -> Meal
}

class APIService: APIServiceProtocol {
    static let shared = APIService()
    
    private init() {}
    
    private let baseURL = "https://themealdb.com/api/json/v1/1"
    
    func fetchDesserts() async throws -> [MealListItem] {
        let urlString = "\(baseURL)/filter.php?c=Dessert"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MealListItemResponse.self, from: data)
        return response.meals.map { MealListItem(idMeal: $0.idMeal, strMeal: $0.strMeal, strMealThumb: $0.strMealThumb) }
            .sorted { $0.strMeal < $1.strMeal }
    }
    
    func fetchMealDetails(id: String) async throws -> Meal {
        let urlString = "\(baseURL)/lookup.php?i=\(id)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MealResponse.self, from: data)
        guard let meal = response.meals.first else {
            throw URLError(.cannotParseResponse)
        }
        return meal
    }
}
