//
//  KeychainManager.swift
//  training_ios
//
//  Created by Pham Van Thai on 15/03/2022.
//

import Foundation
import Security
class KeychainManager{
    private static var share: KeychainManager = {
        let share = KeychainManager()
        return share
    }()
    
    static func shared() -> KeychainManager {
        return share
    }
    func SaveDataKeychain(user:String,password:String){
        let query = [
          kSecValueData: password.data(using: .utf8)!,
          kSecAttrAccount: user,
          kSecAttrServer: "thaipv.dev",
          kSecClass: kSecClassInternetPassword,
          kSecReturnData: true,
          kSecReturnAttributes: true
        ] as CFDictionary

        var ref: AnyObject?

        let status = SecItemAdd(query, &ref)
        let result = ref as! NSDictionary
        print("Operation finished with status: \(status)")
        print("Username: \(result[kSecAttrAccount] ?? "")")
        let passwordData = result[kSecValueData] as! Data
        let passwordString = String(data: passwordData, encoding: .utf8)
        print("Password: \(passwordString ?? "")")
    }
    func ReadDataKeychain(){
        let query = [
          kSecClass: kSecClassInternetPassword,
          kSecAttrServer: "thaipv.dev",
          kSecReturnAttributes: true,
          kSecReturnData: true,
          kSecMatchLimit: 20
        ] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)

        print("Operation finished with status: \(status)")
        let array = result as! [NSDictionary]

        array.forEach { dic in
          let username = dic[kSecAttrAccount] ?? ""
          let passwordData = dic[kSecValueData] as! Data
          let password = String(data: passwordData, encoding: .utf8)!
          print("Username: \(username)")
          print("Password: \(password)")
        }
    }
}
