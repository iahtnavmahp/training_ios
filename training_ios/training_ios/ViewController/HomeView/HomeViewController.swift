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
    var addItem:UIBarButtonItem!
    var changeList:UIBarButtonItem!
    var editItem:UIBarButtonItem!
    var isChange = true
    let listIcon = UIImage(systemName: "text.justify")
    let collectionIcon = UIImage(systemName: "squareshape.split.3x3")
    var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        myCollectionView.collectionViewLayout = layoutDynamicCell(isLG: 1,ld: nil)
        let nib1 = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
        myCollectionView.register(nib1, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
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
            myCollectionView.reloadData()
            changeList.image = listIcon
            myCollectionView.collectionViewLayout = layoutDynamicCell(isLG: 2,ld: .fixed(5))
            
        }else{
            isChange = true
            changeList.image = collectionIcon
            myCollectionView.collectionViewLayout = layoutDynamicCell(isLG: 1,ld: nil)
            myCollectionView.reloadData()
        }
    }
    @objc func editAction(_ button:UIBarButtonItem!) {
        print("taped editItem")
        
        if stateBtn == 0 {
            stateBtn = 1
            btnSync.isEnabled = false
            btnSync.setTitle("delete", for: .normal)
            
            myCollectionView.reloadData()
        }else{
            stateBtn = 0
            btnSync.isEnabled = true
            btnSync.setTitle("sync", for: .normal)
            myCollectionView.reloadData()
        }
        
    }
    @IBAction func getAction(_ sender: Any) {
        
        
        if stateBtn == 0{
            print("sync")
            getData()
        }else{
            print("delete")
            showAlert()
            
        }
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
    func multiDelete(){
        var arrI = [Int]()
        for (i,e) in viewModel.arrCheck.enumerated(){
            if !e{
                arrI.append(i)
            }
        }
        if arrI.count > 0{
            
            let arrayK = viewModel.arrCheck
                .enumerated()
                .filter { !arrI.contains($0.offset) }
                .map { $0.element }
            viewModel.arrCheck = arrayK
            let arrayR = viewModel.persons
                .enumerated()
                .filter { !arrI.contains($0.offset) }
                .map { $0.element }
            viewModel.persons = arrayR
            stateBtn = 0
            btnSync.setTitle("sync", for: .normal)
            myCollectionView.reloadData()
        }
    }
    func unCheck(){
        viewModel.arrCheck.removeAll()
        for _ in viewModel.persons{
            viewModel.arrCheck.append(true)
        }
        stateBtn = 0
        btnSync.setTitle("sync", for: .normal)
        myCollectionView.reloadData()
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
    func showAlert(){
        let alert = UIAlertController(title: "Delete",
                                      message: "ban co muon xoa?",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
            self.unCheck()
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {_ in
            self.multiDelete()
        }))
        
        self.present(alert, animated: true)
    }
    
    func layoutDynamicCell(isLG:Int,ld:NSCollectionLayoutSpacing?)->UICollectionViewLayout{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: ld, top: .fixed(8), trailing: nil, bottom: .fixed(8))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,count: isLG)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.persons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        //        cell.btnDel.tag = indexPath.row
        //        cell.subTitle.text = viewModel.persons[indexPath.row].subtitle
        
        switch stateBtn {
        case 0:
            cell.imgDelete.isHidden = true
        case 1:
            cell.imgDelete.isHidden = false
            if viewModel.arrCheck[indexPath.row]{
                cell.imgDelete.image = UIImage(systemName: "poweroff")
            }else{
                cell.imgDelete.image = UIImage(systemName: "checkmark.circle")
            }
         
        default:
            print("loi tai cellForItemAt")
        }
        cell.lblSub?.text = viewModel.persons[indexPath.row].subtitle
        cell.lblTitle?.text = viewModel.persons[indexPath.row].title
        if let url = URL(string:viewModel.persons[indexPath.row].image){
            cell.imgAvatar.imageFromServerURL(url: url, PlaceHolderImage: UIImage(systemName: "person.fill.questionmark")!)
            
        }
        
        //        cell.btnDel.addTarget(self, action: #selector(delItem), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        switch stateBtn {
        case 0:
            let vc = AddViewController()
            vc.isScr = false
            viewModel.idxPath = indexPath
            vc.viewModel = viewModel
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            viewModel.arrCheck[indexPath.row] = !viewModel.arrCheck[indexPath.row]
            myCollectionView.reloadItems(at: [indexPath])
            btnSync.isEnabled = true
        default:
            print("loi tai didSelectItemAt")
        }
        
    }
    
}
