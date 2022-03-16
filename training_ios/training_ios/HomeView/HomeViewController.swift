//
//  HomeViewController.swift
//  training_ios
//
//  Created by Pham Van Thai on 15/03/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var btnSync: UIButton!
    var stateBtn:Int8 = 0
    var LorG:CGFloat = 1
    var addItem:UIBarButtonItem!
    var changeList:UIBarButtonItem!
    var editItem:UIBarButtonItem!
    var isChange = true
    let listIcon = UIImage(systemName: "text.justify")
    let collectionIcon = UIImage(systemName: "squareshape.split.3x3")
    var viewModel = HomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib1 = UINib(nibName: "HomeCollectionViewCell", bundle:nil)
        myCollectionView.register(nib1, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        title = "HOME"
        addItem = UIBarButtonItem(title: "add", style: .plain, target: self, action: #selector(addAction))
        changeList = UIBarButtonItem(title: "change", style: .plain, target: self, action: #selector(changeAction))
        let addIcon = UIImage(systemName: "plus.square.on.square.fill")
        
        editItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editAction))
        changeList.image = collectionIcon
        addItem.image = addIcon
        
        changeList.action = #selector(changeAction)
        navigationItem.rightBarButtonItems = [addItem,changeList]
        navigationItem.leftBarButtonItem = editItem
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if viewModel.isReload == 1{
            myCollectionView.reloadData()
            print("reloadData")
            
            viewModel.isReload = 0
        }else if viewModel.isReload == 2{
            myCollectionView.reloadItems(at: [viewModel.idxPath])
           
            print("reload\(viewModel.isReload)")
            viewModel.isReload = 0
        }

    }
    @objc func addAction(_ button:UIBarButtonItem!) {
        print("taped addItem")
        let vc = AddViewController()
        vc.isScr = true
        vc.viewModel = viewModel
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func changeAction(_ button:UIBarButtonItem!) {
        print("taped changeList")
        if isChange{
            isChange = false
            changeList.image = listIcon
            LorG = 2
            myCollectionView.reloadData()
        }else{
            isChange = true
            changeList.image = collectionIcon
            LorG = 1
            myCollectionView.reloadData()
        }
    }
    @objc func editAction(_ button:UIBarButtonItem!) {
        print("taped editItem")
        print("reloadk\(viewModel.isReload)")
        if stateBtn == 0 {
            stateBtn = 1
            btnSync.isEnabled = false
            btnSync.setTitle("delete", for: .normal)
        }else{
            stateBtn = 0
            btnSync.isEnabled = true
            btnSync.setTitle("sync", for: .normal)
        }
        
        
    }
    @IBAction func getAction(_ sender: Any) {
        print("sync")
        getData()
    }
    @objc func delItem(sender:UIButton){
        
        let indexpath = IndexPath(row: sender.tag, section: 0)
        print(indexpath)
        //        if indexpath.row < arr.count {
        //            arr.remove(at: indexpath.row)
        //            myCollectionView.deleteItems(at: [indexpath])
        //
        //        }
        
        
    }
    func getData(){
        viewModel.loadAPI { (done, msg) in
            if done {
                print("success")
                self.myCollectionView.reloadData()
            } else {
                print("API ERROR: \(msg)")
            }
        }
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
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.persons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        cell.btnDel.tag = indexPath.row
        cell.lblTitle?.text = viewModel.persons[indexPath.row].subtitle
        //        if let url = URL(string:"https://raw.githubusercontent.com/iahtnavmahp/linkImage/main/Screen%20Shot%202022-03-15%20at%2015.10.43.png"){
        //            cell.imgAvatar.load(url: url)
        //          }
        cell.btnDel.addTarget(self, action: #selector(delItem), for: .touchUpInside)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt
                            indexPath: IndexPath) -> CGSize {
        return CGSize(width: (myCollectionView.frame.width)/LorG - 10,height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        
            let vc = AddViewController()
            vc.isScr = false
            viewModel.idxPath = indexPath
            vc.viewModel = viewModel
            self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
