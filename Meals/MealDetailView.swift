//
//  ContentView.swift
//  Meals
//
//  Created by Kyle Ferrigan on 6/12/24.
//

import SwiftUI

struct MealDetailView: View {
    let mealId: String
    @State private var meal: MealDetails? = nil
    
    var body: some View {
        VStack{
            if let meal = meal { // If meal is loaded in already
                AsyncImage(url: URL(string: meal.strMealThumb)) { phase in // Load Image Asynchronously
                    if let image = phase.image { // Image Loaded
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .clipShape(.rect(cornerRadius: 10)) // Rounded edges make image look nicer
                    } else if phase.error != nil { // If image fails to load
                        Color.red
                            .frame(width: 200, height: 200)
                    } else { // If no image provided
                        Color.gray
                            .frame(width: 200, height: 200)
                    }
                }
                List{ // List here allows overflow data to be scrolled though while providing a nice contrast between the text area and image area
                    Text(meal.strMeal)
                        .font(.headline)
                    Text("Instructions: \(meal.strInstructions)")
                        .font(.subheadline)
                    Text("Ingredients: " + formatMealIngredients(mealIn: meal)) // TODO: this
                        .font(.subheadline)
                }
                
                
            } else { // If meal hasnt loaded in yet
                Text("Loading...")
                    .font(.headline)
            }
        }
        .onAppear { // Load data as soon as view is clicked from in previous navigationview
            fetchMealDetail()
        }
    }
    
    // Function to pull Detailed Data
    private func fetchMealDetail() {
        
        // Safely define URL
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(mealId)") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { // check if data is safe to unwrap
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([String: [MealDetails]].self, from: data) // Decode data as JSON and conform relevant data to MealsDetails Model
                
                if let meal = decodedData["meals"]?.first { // Data starts after first occurance of "meals"
                    DispatchQueue.main.async { // Asynchronously load meal in
                        self.meal = meal
                    }
                } else {
                    print("No meal found in response")
                }
            } catch let error {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume() // Start Request
    }
    
    //Function to merge all 20 ingredients and measures into a single string
    private func formatMealIngredients(mealIn: MealDetails) -> String {
        
        return (mealIn.strMeasure1 + " " + mealIn.strIngredient1 + " " +
                mealIn.strMeasure2 + " " + mealIn.strIngredient2 + " " +
                mealIn.strMeasure3 + " " + mealIn.strIngredient3 + " " +
                mealIn.strMeasure4 + " " + mealIn.strIngredient4 + " " +
                mealIn.strMeasure5 + " " + mealIn.strIngredient5 + " " +
                mealIn.strMeasure6 + " " + mealIn.strIngredient6 + " " +
                mealIn.strMeasure7 + " " + mealIn.strIngredient7 + " " +
                mealIn.strMeasure8 + " " + mealIn.strIngredient8 + " " +
                mealIn.strMeasure9 + " " + mealIn.strIngredient9 + " " +
                mealIn.strMeasure10 + " " + mealIn.strIngredient10 + " " +
                mealIn.strMeasure11 + " " + mealIn.strIngredient11 + " " +
                mealIn.strMeasure12 + " " + mealIn.strIngredient12 + " " +
                mealIn.strMeasure13 + " " + mealIn.strIngredient13 + " " +
                mealIn.strMeasure14 + " " + mealIn.strIngredient14 + " " +
                mealIn.strMeasure15 + " " + mealIn.strIngredient15 + " " +
                mealIn.strMeasure16 + " " + mealIn.strIngredient16 + " " +
                mealIn.strMeasure17 + " " + mealIn.strIngredient17 + " " +
                mealIn.strMeasure18 + " " + mealIn.strIngredient18 + " " +
                mealIn.strMeasure19 + " " + mealIn.strIngredient19 + " " +
                mealIn.strMeasure20 + " " + mealIn.strIngredient20)
    }
}
