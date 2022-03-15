//
//  Person.swift
//  training_ios
//
//  Created by Pham Van Thai on 16/03/2022.
//

import Foundation
struct Person { 
    var title:String
    var subtitle:String
    var image:String
    init(json: JSON) {
        self.title = json["title"] as! String
        self.subtitle = json["subtitle"] as! String
        self.image = json["image"] as! String
    }
}
