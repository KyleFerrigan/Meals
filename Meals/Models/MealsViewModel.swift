//
//  MealCategoryViewModel.swift
//  Meals
//
//  Created by Kyle Ferrigan on 6/12/24.
//

import Foundation

class MealsViewModel: ObservableObject {
    @Published var meals: [Meal] = [] // Watchable array
    let mealCategory = "Dessert" //Change this to get a different category of meals if desired
    
    init() {
        fetchMealCategoryData() //Fetch data as soon as viewmodel is initialized
    }
    
    // Get JSON data from URL
    func fetchMealCategoryData() {
        // Safely define URL
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c="+(mealCategory)) else {
            print("Invalid URL")
            return
        }
        
        // Define the URLSession
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { // Check if data can be safely unwrapped
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([String: [Meal]].self, from: data) // Decode the JSON data that fits the Meal Model
                
                if let meals = decodedData["meals"] {
                    DispatchQueue.main.async { // Start thread to asynchronously wait for meal data
                        self.meals = meals
                    }
                } else {
                    print("No meals found in response")
                }
            } catch let error {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume() // Execute request
    }
}
