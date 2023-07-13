//
//  ListSelectionPage.swift
//  HSTaxiDriverApp
//
//  Created by APPLE on 28/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

protocol listSelectionDelegate {
    func selectedListWithDetails(listType:String,listArray:NSMutableArray,indexArray:NSMutableArray)
}

class ListSelectionPage: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var listArray = NSMutableArray()
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var list_TableView: UITableView!
    @IBOutlet var titleLbl: UILabel!
    var viewType = String()
    var titleName = String()
    var selectedArray = NSMutableArray()
    var selectedIndexArray = NSMutableArray()

    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var bottomView: UIView!
    var delegate:listSelectionDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupInitialDetails()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.changeToRTL()
        self.list_TableView.reloadData()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nextBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.textAlignment = .right
        }
        else {
            self.view.transform = .identity
            self.nextBtn.transform = .identity
            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:initial setup
    func setupInitialDetails()   {
        self.navigationView.elevationEffect()
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: titleName)
        list_TableView.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        self.nextBtn.config(color: .white, size: 17, align: .center, title: "next")
        self.nextBtn.cornerMiniumRadius()
        self.nextBtn.backgroundColor = PRIMARY_COLOR
        
        if self.viewType == "1"{
            self.bottomView.isHidden = true
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        if self.viewType == "2"{
            AJAlertController.initialization().showAlert(aStrMessage: "without_saving", aCancelBtnTitle: "cancel", aOtherBtnTitle: "okay", status: "", completion: { (index, title) in
                print(index,title)
                if index == 1{
                    //open settings page
                    self.selectedArray.removeAllObjects()
                    self.selectedIndexArray.removeAllObjects()
                    self.delegate?.selectedListWithDetails(listType: self.viewType, listArray: self.selectedArray, indexArray: self.selectedIndexArray)
                    self.dismiss(animated: true, completion: nil)
                }
            })

        }else{
            self.delegate?.selectedListWithDetails(listType: self.viewType, listArray: self.selectedArray, indexArray: self.selectedIndexArray)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int{
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listObj = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
        let listDict:NSDictionary =  listArray.object(at: indexPath.row) as! NSDictionary
        listObj.listNameLbl.text = listDict.value(forKey: "name") as? String
        let listID = listDict.value(forKey: "_id")
         if selectedIndexArray.contains(listID ?? EMPTY_STRING){
            listObj.selectIcon.isHidden = false
        }else{
            listObj.selectIcon.isHidden = true
        }
        return listObj
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        self.delegate?.selectedListWithDetails(listType: self.viewType, listArray: self.selectedArray, indexArray: self.selectedIndexArray)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:ListCell = tableView.cellForRow(at: indexPath) as! ListCell
        let listDict:NSDictionary =  listArray.object(at: indexPath.row) as! NSDictionary
        if self.viewType == "1"{
            selectedArray.removeAllObjects()
            selectedIndexArray.removeAllObjects()
            selectedArray.addObjects(from: [listDict])
            selectedIndexArray.addObjects(from: [listDict.value(forKey: "_id") as Any])
            cell.selectIcon.isHidden = false
            self.delegate?.selectedListWithDetails(listType: self.viewType, listArray: self.selectedArray, indexArray: self.selectedIndexArray)
            self.dismiss(animated: true, completion: nil)
        }else if self.viewType == "2"{
            if (cell.selectIcon.isHidden == false){
                cell.selectIcon.isHidden = true
                selectedArray.removeObjects(in: [listDict])
                selectedIndexArray.removeObjects(in: [listDict.value(forKey: "_id") as Any])
            }else{
                cell.selectIcon.isHidden = false
                selectedArray.addObjects(from: [listDict])
                selectedIndexArray.addObjects(from: [listDict.value(forKey: "_id") as Any])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell:ListCell = tableView.cellForRow(at: indexPath) as! ListCell
        if self.viewType == "1"{
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.selectIcon.isHidden = true
        }
    }
  
}
