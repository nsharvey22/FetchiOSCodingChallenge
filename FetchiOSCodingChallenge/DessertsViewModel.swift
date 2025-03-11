import Foundation

@MainActor
class DessertsViewModel: ObservableObject {
    @Published var desserts: [MealListItem] = []
    @Published var selectedMealDetails: Meal?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
    
    func loadDesserts() async {
        isLoading = true
        error = nil
        
        do {
            desserts = try await apiService.fetchDesserts()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func loadMealDetails(for mealId: String) async {
        isLoading = true
        error = nil
        
        do {
            selectedMealDetails = try await apiService.fetchMealDetails(id: mealId)
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
}
