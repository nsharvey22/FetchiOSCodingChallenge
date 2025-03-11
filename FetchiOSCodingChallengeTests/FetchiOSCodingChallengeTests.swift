//
//  FetchiOSCodingChallengeTests.swift
//  FetchiOSCodingChallengeTests
//
//  Created by Nicholas Harvey on 3/11/25.
//

import XCTest
@testable import FetchiOSCodingChallenge

// MARK: - Test Fixtures
extension MealListItem {
    static func fixture(
        idMeal: String = "1",
        strMeal: String = "Test Dessert",
        strMealThumb: String = "test_url"
    ) -> MealListItem {
        MealListItem(idMeal: idMeal, strMeal: strMeal, strMealThumb: strMealThumb)
    }
}

extension Meal {
    static func fixture(
        idMeal: String = "1",
        strMeal: String = "Test Dessert",
        strInstructions: String = "Test Instructions",
        strMealThumb: String = "test_url",
        ingredients: [String] = ["Ingredient 1", "Ingredient 2"],
        measurements: [String] = ["1 cup", "2 tbsp"]
    ) -> Meal {
        var dict: [String: String?] = [
            "idMeal": idMeal,
            "strMeal": strMeal,
            "strInstructions": strInstructions,
            "strMealThumb": strMealThumb
        ]

        for (index, ingredient) in ingredients.enumerated() {
            dict["strIngredient\(index + 1)"] = ingredient
        }
        
        for (index, measurement) in measurements.enumerated() {
            dict["strMeasure\(index + 1)"] = measurement
        }
        
        for i in (ingredients.count + 1)...20 {
            dict["strIngredient\(i)"] = nil
            dict["strMeasure\(i)"] = nil
        }
        
        let data = try! JSONSerialization.data(withJSONObject: dict)
        return try! JSONDecoder().decode(Meal.self, from: data)
    }
}

class MockAPIService: APIServiceProtocol {
    var shouldSucceed = true
    var desserts: [MealListItem] = []
    var mealDetails: Meal?
    
    func fetchDesserts() async throws -> [MealListItem] {
        if shouldSucceed {
            return desserts
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    func fetchMealDetails(id: String) async throws -> Meal {
        if shouldSucceed, let meal = mealDetails {
            return meal
        } else {
            throw URLError(.badServerResponse)
        }
    }
}

@MainActor
final class DessertsViewModelTests: XCTestCase {
    var sut: DessertsViewModel!
    var mockAPIService: MockAPIService!
    
    override func setUpWithError() throws {
        super.setUp()
        mockAPIService = MockAPIService()
        sut = DessertsViewModel(apiService: mockAPIService)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    func testLoadDessertsSuccess() async throws {
        // Given
        let mockDesserts: [MealListItem] = [
            .fixture(idMeal: "1", strMeal: "Apple Pie"),
            .fixture(idMeal: "2", strMeal: "Banana Bread")
        ]
        mockAPIService.desserts = mockDesserts
        mockAPIService.shouldSucceed = true
        
        // When
        await sut.loadDesserts()
        
        // Then
        XCTAssertEqual(sut.desserts.count, 2)
        XCTAssertEqual(sut.desserts[0].idMeal, "1")
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
    }
    
    func testLoadDessertsFailure() async throws {
        // Given
        mockAPIService.shouldSucceed = false
        
        // When
        await sut.loadDesserts()
        
        // Then
        XCTAssertTrue(sut.desserts.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.error)
    }
    
    func testLoadMealDetailsSuccess() async throws {
        // Given
        let mockMeal = Meal.fixture(
            idMeal: "1",
            strMeal: "Apple Pie",
            ingredients: ["Apple", "Sugar", "Cinnamon"],
            measurements: ["6", "1 cup", "1 tsp"]
        )
        mockAPIService.mealDetails = mockMeal
        mockAPIService.shouldSucceed = true
        
        // When
        await sut.loadMealDetails(for: "1")
        
        // Then
        XCTAssertNotNil(sut.selectedMealDetails)
        XCTAssertEqual(sut.selectedMealDetails?.idMeal, "1")
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
    }
    
    func testLoadMealDetailsFailure() async throws {
        // Given
        mockAPIService.shouldSucceed = false
        
        // When
        await sut.loadMealDetails(for: "1")
        
        // Then
        XCTAssertNil(sut.selectedMealDetails)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.error)
    }
}

