//
//  UserDefaultsManager.swift
//  training_ios
//
//  Created by Pham Van Thai on 15/03/2022.
//

import Foundation
struct Person1: Codable {
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
    func SaveDataObj(person:Person1){
        let encoder = JSONEncoder()
        if let encodedUser = try? encoder.encode(person) {
            userdefault.set(encodedUser, forKey: "ObjData")
        }
        
        if let savedPersonData = userdefault.object(forKey: "ObjData") as? Data {
            let decoder = JSONDecoder()
            if let savedPerson = try? decoder.decode(Person1.self, from: savedPersonData) {
                print("person: \(savedPerson)")
            }
        }
    }
    func checkDataSever(data:Data)->Bool{
        if let getData = userdefault.data(forKey: "DataSever"){
            if getData == data {
                print("du lieu khong thay doi")
                return false
            }else{
                userdefault.set(data, forKey: "DataSever")
                print("du lieu thay doi")
                return true
            }
        }
        userdefault.set(data, forKey: "DataSever")
       return true
        
    }
    func editData(persons:[Person]){
        let encoder = JSONEncoder()
        if let encodedUser = try? encoder.encode(persons) {
            userdefault.set(encodedUser, forKey: "DataSever")
            print("succes edit")
        }
    }
 
}
