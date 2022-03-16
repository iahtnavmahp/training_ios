//
//  HomeViewModel.swift
//  training_ios
//
//  Created by Pham Van Thai on 16/03/2022.
//

import Foundation
typealias Completion = (Bool, String) -> Void
class HomeViewModel {
    var persons:[Person] = []
    var isReload = 0
    var idxPath = IndexPath(row: 0, section: 0)
    func loadAPI(completion: @escaping Completion) {
        self.persons.removeAll()
        Persons.getPerson { (result) in
            switch result {
            case .failure(let error):
                //call back
                completion(false, error.localizedDescription)
                
            case .success(let personResult):
                self.persons.append(contentsOf: personResult.persons)
                print(self.persons.count)
                //call back
                
                completion(true, "")
            }
        }
    }
}
