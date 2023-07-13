//
//  SideMenuPage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 15/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit



class SideMenuPage: UIViewController,UITableViewDataSource,UITableViewDelegate{
  

    @IBOutlet var editdesLbl: UILabel!
    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var profileImgView: UIImageView!
    @IBOutlet var menuTableView: UITableView!
    var menuArray = NSMutableArray()

    @IBOutlet var advertisorBtn: UIButton!
    @IBOutlet var advertisorLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureMenuDetails()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupInitialDetails()
        self.changeToRTL()
        self.configureMenuDetails()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.editdesLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.editdesLbl.textAlignment = .right
            self.usernameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.usernameLbl.textAlignment = .right
            self.profileImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else {
            self.view.transform = .identity
            self.editdesLbl.transform = .identity
            self.editdesLbl.textAlignment = .left
            self.usernameLbl.transform = .identity
            self.usernameLbl.textAlignment = .left
            self.profileImgView.transform = .identity
        }
    }
    func setupInitialDetails()  {
        self.usernameLbl.config(color: TEXT_PRIMARY_COLOR, size: 26, align: .left, text: EMPTY_STRING)
        self.usernameLbl.text = UserModel.shared.getUserDetails().value(forKey: "full_name") as? String
        self.profileImgView.makeItRound()
        if (UserModel.shared.getProfilePic() != nil) {
            profileImgView.sd_setImage(with: URL(string: UserModel.shared.getProfilePic()! as String), placeholderImage: #imageLiteral(resourceName: "placeholder_image"))
            sleep(1)
//            profileImgView.image = profileImgView.image?.withGrayscale

        }
        self.editdesLbl.config(color: TEXT_TERTIARY_COLOR, size: 14, align: .left, text: "view_edit")
        self.advertisorBtn.config(color: .white, size: 17, align: .center, title: "advertisement")
        self.advertisorBtn.cornerMiniumRadius()
        self.advertisorBtn.backgroundColor = PRIMARY_COLOR
        self.advertisorLbl.config(color: TEXT_PRIMARY_COLOR, size: 16, align: .center, text: "advertisor_promo")

        let attributedText = NSMutableAttributedString(string: Utility.shared.getLanguage()?.value(forKey: "advertisor_promo") as! String)
        let paragraphStyle = NSMutableParagraphStyle()
        //SET THIS:
        paragraphStyle.lineSpacing = 10
        paragraphStyle.alignment = .center
        //OR SET THIS:
//        paragraphStyle.lineHeightMultiple = 4
        let range = NSMakeRange(0, attributedText.length)
        attributedText.addAttributes([NSAttributedStringKey.paragraphStyle : paragraphStyle], range: range)
        self.advertisorLbl.attributedText = attributedText
    
    }
    
      @IBAction func profileBtnTapped(_ sender: Any) {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = false
        }
        DispatchQueue.main.async{
        let profileObj = ProfilePage()
        self.navigationController?.pushViewController(profileObj, animated: true)
        }
    }
   
    //MARK: custom menu details
    func configureMenuDetails()  {
        self.menuArray.removeAllObjects()
        menuTableView.register(UINib(nibName: "MenuTableCell", bundle: nil), forCellReuseIdentifier: "MenuTableCell")

        self.addMenu(menu_name: "payment", menu_icon: "menu_1", menu_wallet: EMPTY_STRING)
        self.addMenu(menu_name: "ride_details", menu_icon: "menu_2", menu_wallet: EMPTY_STRING)
      //  self.addMenu(menu_name: "ride_earnings", menu_icon: "menu_3", menu_wallet: "$200")
//        self.addMenu(menu_name: "advertisement", menu_icon: "menu_4", menu_wallet: EMPTY_STRING)
        self.addMenu(menu_name: "help", menu_icon: "menu_5", menu_wallet: EMPTY_STRING)
        menuTableView.reloadData()
    }

    func addMenu(menu_name:String,menu_icon:String,menu_wallet:String) {
        let menuDict  = NSMutableDictionary()
        menuDict.setValue(menu_name, forKey: "menu_name")
        menuDict.setValue(menu_icon, forKey: "menu_icon")
        menuDict.setValue(menu_wallet, forKey: "menu_wallet")
        menuArray.addObjects(from: [menuDict])
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int{
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileCell = tableView.dequeueReusableCell(withIdentifier: "MenuTableCell", for: indexPath) as! MenuTableCell
        let menuDict:NSDictionary =  menuArray.object(at: indexPath.row) as! NSDictionary
        profileCell.configCell(menuDict: menuDict)
        return profileCell
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let paymentObj = PaymentDetailsPage()
            paymentObj.viewType = EDIT_VIEW
            paymentObj.type = "1"
            self.navigationController?.pushViewController(paymentObj, animated: true)
        }else if indexPath.row == 1{
            let historyObj = HistoryPage()
            historyObj.modalPresentationStyle = .fullScreen
            self.navigationController?.present(historyObj, animated: true, completion: nil)
        }else if indexPath.row == 2{
            let helpObj = HelpPage()
            helpObj.modalPresentationStyle = .fullScreen
            self.navigationController?.present(helpObj, animated: true, completion: nil)
        }
    }
}
