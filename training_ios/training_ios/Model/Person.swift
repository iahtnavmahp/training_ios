//
//  Person.swift
//  training_ios
//
//  Created by Pham Van Thai on 16/03/2022.
//

import Foundation
struct Person:Encodable,Equatable {
    var title:String
    var subtitle:String
    var image:String
    
    init(json: JSON) {
        self.title = json["title"] as! String
        self.subtitle = json["subtitle"] as! String
        self.image = json["image"] as! String
    }
    init(title:String,subtitle:String,image:String) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
    }
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.title == rhs.title && lhs.image == rhs.image && lhs.subtitle == rhs.subtitle
    }
}
