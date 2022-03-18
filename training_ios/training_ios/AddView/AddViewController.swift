//
//  AddViewController.swift
//  training_ios
//
//  Created by Pham Van Thai on 15/03/2022.
//

import UIKit

class AddViewController: UIViewController {
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var tfLinkImage: UITextField!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfSubTitle: UITextField!
    @IBOutlet weak var btnSave: UIButton!

    var isScr : Bool = true
    var isSave : Bool = true
    var idx = 0
    var viewModel = HomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        imgAvatar.makeRounded()
        tfLinkImage.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        tfTitle.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        tfSubTitle.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        btnSave.isEnabled = false
        if isScr {
            title = "Add Item"
        }else{
            title = "Detail Item"
          
            if viewModel.idxPath.row < viewModel.persons.count{
                let data = viewModel.persons[viewModel.idxPath.row]
                if let url = URL(string:data.image){
                    imgAvatar.imageFromServerURL(url: url, PlaceHolderImage: UIImage(systemName: "person.fill.questionmark")!)
                }
                tfLinkImage.text = data.image
                tfTitle.text = data.title
                tfSubTitle.text = data.subtitle
            }
            
            
        }
        // Do any additional setup after loading the view.
    }
    @objc func textFieldDidChanged(){
        if isSave{
            isSave = false
            btnSave.isEnabled = true
        }
    }
    @IBAction func btnSaveObj(_ sender: Any) {
        
        if isScr{
            viewModel.isReload = 1
           
            viewModel.persons.append(Person(title: tfTitle.text ?? "", subtitle: tfSubTitle.text ?? "", image: tfLinkImage.text ?? ""))
            
        }else{
            viewModel.isReload = 2
            viewModel.persons[viewModel.idxPath.row].image = tfLinkImage.text ?? ""
            viewModel.persons[viewModel.idxPath.row].subtitle = tfSubTitle.text ?? ""
            viewModel.persons[viewModel.idxPath.row].title = tfTitle.text ?? ""
            
           
        }
        UserDefaultsManager.shared().editData(persons: viewModel.persons)
        self.navigationController?.popViewController(animated: true)
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
