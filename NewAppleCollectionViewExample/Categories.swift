//
//  Categories.swift
//  NewAppleCollectionViewExample
//
//  Created by A.Khwaja on 10/24/20.
//
/*
 
 The data model of categories and items.
 
 */

import Foundation

struct MainCategory: Hashable {
    
    let text: String
    let title: String
    let category: SubCatergory.Category
    
    static var list: [MainCategory] {
        return [
            MainCategory(text: "👕", title: "Clothing", category: .clothing),
            MainCategory(text: "🥤", title: "Drinks", category: .drinks),
            MainCategory(text: "🌭", title: "Food", category: .food),
            MainCategory(text: "🤖", title: "Electronics", category: .electronics),
            MainCategory(text: "🍴", title: "Sports", category: .sports),
        ]
    }
}


struct SubCatergory: Hashable {

    enum Category: CaseIterable, CustomStringConvertible {
        case electronics, drinks, food, clothing, sports
    }
    
    let text: String
    let title: String
    let category: Category
}

extension SubCatergory.Category {
    
    var description: String {
        switch self {
        case .electronics: return "Electronics"
        case .drinks: return "Drinks"
        case .food: return "Food"
        case .clothing: return "Clothing"
        case .sports: return "Sports"
        }
    }
    
    var products: [SubCatergory] {
        switch self {

        case .electronics:
            return [
                SubCatergory(text: "📱", title: "iPhone", category: self),
                SubCatergory(text: "💻", title: "Macbook", category: self),
                SubCatergory(text: "📷", title: "Camera", category: self)
            ]
            
        case .drinks:
            return [
                SubCatergory(text: "🥤", title: "Cola", category: self),
                SubCatergory(text: "🧃", title: "Juice", category: self),
                SubCatergory(text: "☕️", title: "Hot drinks", category: self)
            ]
            
        case .food:
            return [
                SubCatergory(text: "🥦", title: "Vegtables", category: self),
                SubCatergory(text: "🍎", title: "Fruits", category: self),
                SubCatergory(text: "🍕", title: "FastFood", category: self)
            ]
        case .clothing:
            return [
                SubCatergory(text: "👖", title: "Pants", category: self),
                SubCatergory(text: "👕", title: "Shirts", category: self),
                SubCatergory(text: "💍", title: "Accessories", category: self)
            ]
        case .sports:
            return [
                SubCatergory(text: "⚽️", title: "Football", category: self),
                SubCatergory(text: "🛹", title: "Skate", category: self),
                SubCatergory(text: "🤿", title: "Swimming Tools", category: self)
            ]
        }
    }
}
