//
//  SectionItemModels.swift
//  NewAppleCollectionViewExample
//
//  Created by A.Khwaja on 10/24/20.
//

import Foundation

enum Section: Int, Hashable, CaseIterable, CustomStringConvertible {
    case  horizantal, list
    
    var description: String {
        switch self {
        case .horizantal: return "Horizantal"
        case .list: return "List"
        }
    }
}

struct Item: Hashable {
    let title: String?
    let subCategory: SubCatergory?
    let mainList: MainCategory?
    let hasChildren: Bool
    init(subCategory: SubCatergory? = nil, mainList: MainCategory? = nil, title: String? = nil, hasChildren: Bool = false) {
        self.subCategory = subCategory
        self.mainList = mainList
        self.title = title
        self.hasChildren = hasChildren
    }
}
