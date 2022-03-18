//
//  SaveDataViewController.swift
//  training_ios
//
//  Created by Pham Van Thai on 15/03/2022.
//

import UIKit

class SaveDataViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK:----------------UserDefaults--------------------
                let data = [1,2,3,4]
                let person = Person1(name: "Pham Van Thai", age: 23)
                UserDefaultsManager.shared().SaveDataSimple(data: data)
                UserDefaultsManager.shared().SaveDataObj(person: person)
        //MARK:----------------Keychain--------------------
        //        KeychainManager.shared().SaveDataKeychain(user: "thai2", password: "thai090499")
        //        KeychainManager.shared().ReadDataKeychain()
        //MARK:----------------SaveFileToDocument--------------------
        //        let fileName = "testFile1.txt"
        //
        //        FileDocumentManager.shared().save(text: "thaipv",
        //                                          toDirectory: FileDocumentManager.shared().documentDirectory(),
        //                                          withFileName: fileName)
        //        FileDocumentManager.shared().read(fromDocumentsWithFileName: fileName)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
