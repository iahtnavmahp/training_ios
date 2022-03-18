//
//  API.Persons.swift
//  training_ios
//
//  Created by Pham Van Thai on 16/03/2022.
//

import Foundation
struct Persons {
    static let domain = "https://15a35941-b8c2-4d9f-a8a6-0bbd76865bc0.mock.pstmn.io/person"
    struct PersonResult {
        var persons: [Person]
    }
    static func getPerson(completion: @escaping APICompletion<PersonResult>) {
        
        
        APIManager.shared().request(urlString: domain) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case .success(let data):
                if let data = data {
                    
                    let json = data.toJSON2()
                    let results = json as! [JSON]
                    
                    var persons: [Person] = []
                    for item in results {
                        let person = Person(json: item)
                        persons.append(person)
                    }
                    
                    print("check \(UserDefaultsManager.shared().checkDataSever(data: data,list: persons))")
                    let personResult = PersonResult(persons: persons)
                    
                    
                    completion(.success(personResult))
                    
                } else {
                    
                    completion(.failure(.error("Data is not format.")))
                }
            }
        }
    }
}
