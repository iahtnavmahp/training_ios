//
//  UserDefaultsManager.swift
//  training_ios
//
//  Created by Pham Van Thai on 15/03/2022.
//

import Foundation
struct Person: Codable {
    let name: String
    let age: Int
}
class UserDefaultsManager {
    private static var share: UserDefaultsManager = {
        let share = UserDefaultsManager()
        return share
    }()
    
    static func shared() -> UserDefaultsManager {
        return share
    }
    let userdefault = UserDefaults.standard
    
    func SaveDataSimple<T>(data:T){
        userdefault.set(data, forKey: "SimpleData")
        let favoriteFruits = userdefault.object(forKey: "SimpleData") as! T
        print("data: \(favoriteFruits)")
    }
    func SaveDataObj(person:Person){
        let encoder = JSONEncoder()
        if let encodedUser = try? encoder.encode(person) {
            userdefault.set(encodedUser, forKey: "ObjData")
        }
        
        if let savedPersonData = userdefault.object(forKey: "ObjData") as? Data {
            let decoder = JSONDecoder()
            if let savedPerson = try? decoder.decode(Person.self, from: savedPersonData) {
                print("person: \(savedPerson)")
            }
        }
    }
}
