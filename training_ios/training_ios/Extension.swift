//
//  Extension.swift
//  training_ios
//
//  Created by Pham Van Thai on 15/03/2022.
//

import Foundation
import UIKit
extension UIImageView {
    public func imageFromServerURL(url: URL, PlaceHolderImage:UIImage) {

           if self.image == nil{
                 self.image = PlaceHolderImage
           }

           URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in

               if error != nil {
                   print(error ?? "No Error")
                   return
               }
               DispatchQueue.main.async(execute: { () -> Void in
                   let image = UIImage(data: data!)
                   self.image = image
               })

           }).resume()
       }

    func makeRounded() {

        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
