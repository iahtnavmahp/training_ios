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
            changeList.image = listIcon
            myCollectionView.collectionViewLayout = layoutDynamicCell(isLG: 2,ld: .fixed(5))
            myCollectionView.reloadData()
        }else{
            isChange = true
            changeList.image = collectionIcon
            myCollectionView.collectionViewLayout = layoutDynamicCell(isLG: 1,ld: nil)
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
    
    
    
}
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.persons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        //        cell.btnDel.tag = indexPath.row
        //        cell.subTitle.text = viewModel.persons[indexPath.row].subtitle
        cell.lblSub?.text = viewModel.persons[indexPath.row].subtitle
        cell.lblTitle?.text = viewModel.persons[indexPath.row].title
                        if let url = URL(string:viewModel.persons[indexPath.row].image){
                            cell.imgAvatar.load(url: url)
                            
                                  }
        
        //        cell.btnDel.addTarget(self, action: #selector(delItem), for: .touchUpInside)
        return cell
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
