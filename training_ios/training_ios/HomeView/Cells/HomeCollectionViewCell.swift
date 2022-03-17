//
//  HomeCollectionViewCell.swift
//  training_ios
//
//  Created by Pham Van Thai on 15/03/2022.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblSub: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
        imgAvatar.makeRounded()
    }
    func config(){
            self.clipsToBounds = false
            self.backgroundColor = .systemBackground
            self.layer.cornerRadius = 10
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 0.0)
            self.layer.shadowRadius = 10
            self.layer.shadowOpacity = 0.2
        self.backgroundColor = .brown
    }

}
