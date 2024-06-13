//
//  MealCategoryView.swift
//  Meals
//
//  Created by Kyle Ferrigan on 6/12/24.
//

import SwiftUI

struct MealsView: View {
    
    @ObservedObject var viewModel = MealsViewModel() // Pull Published Data From view model
    @State private var selectedMealId: String? = nil // @State variable to control what MealDetailView NavigationView loads
    
    var body: some View {
        NavigationView {
            List(viewModel.meals, id: \.idMeal) { meal in // Dynamic List based on meals
                NavigationLink(destination: MealDetailView(mealId: meal.idMeal), tag: meal.idMeal, selection: $selectedMealId) { // NavigationLink leads to new screen that will grab mealid and start http request in mealdetailview with given id
                    
                    HStack {
                        AsyncImage(url: URL(string: meal.strMealThumb)) { phase in // Load image thumbnail from URL Asynchronously
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 35.0)
                                    .clipShape(.rect(cornerRadius: 5)) //round corners look nice
                                    .padding(.trailing, 2)
                            } else if phase.error != nil { // If image fails to load
                                Color.red //red rounded square
                                    .frame(height: 35.0)
                                    .clipShape(.rect(cornerRadius: 5))
                                    .padding(.trailing, 2)
                            } else { // If no image provided
                                Color.gray //gray rounded square
                                    .frame(height: 35.0)
                                    .clipShape(.rect(cornerRadius: 5))
                                    .padding(.trailing, 2)
                            }
                        }
                        // Name of meal next to image
                        Text(meal.strMeal)
                            .font(.headline)
                    }
                }
                .padding(.bottom,2)
                .padding(.top,2)
                .padding(.leading, 2)
                // Padding makes list look less cramped
            }
            .navigationBarTitle(viewModel.mealCategory) // If doing a different category of meal this will dynamically update
        }
    }
}
