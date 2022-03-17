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
    func checkDataSever(data:Data,list:[Person])->Bool{
        if let getData = userdefault.data(forKey: "DataSever"){
            let json = getData.toJSON2()
            let results = json as! [JSON]
            
            var persons: [Person] = []
            for item in results {
                let person = Person(json: item)
                persons.append(person)
            }
            if persons.count == list.count{
                for i in 0...list.count - 1{
                    let a = persons[i] == list[i]
                    if !a{
                        print("du lieu thay doi")
                        userdefault.set(data, forKey: "DataSever")
                        return true
                    }
                }
                print("du lieu khong thay doi")
                return false
            }
            print("du lieu thay doi")
            userdefault.set(data, forKey: "DataSever")
            return true
        }
        print("them du lieu")
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
