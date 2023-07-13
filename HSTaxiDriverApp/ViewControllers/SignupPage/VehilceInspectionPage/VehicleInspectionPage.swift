//
//  VehicleInspectionPage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 20/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class VehicleInspectionPage: UIViewController {
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet var agreeBtn: UIButton!
    var viewType = String()
    @IBOutlet weak var contentTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpInitialDetails()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.changeToRTL()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.textAlignment = .right
            self.contentTextView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.contentTextView.textAlignment = .right
            self.agreeBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else {
            self.view.transform = .identity
            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
            self.contentTextView.transform = .identity
            self.contentTextView.textAlignment = .left
            self.agreeBtn.transform = .identity
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setUpInitialDetails()  {
        self.navigationView.elevationEffect()
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text:"vehicle_inspect")
        self.agreeBtn.config(color: .white, size: 17, align: .center, title: "iagree")
        self.agreeBtn.cornerMiniumRadius()
        self.agreeBtn.backgroundColor = PRIMARY_COLOR
        let docuArray:NSArray = UserModel().getAdmin().value(forKey: "driverdocs") as! NSArray
        if docuArray.count != 0 {
        for docu in docuArray {
            let tempArray = NSMutableArray.init(array: [docu])
            var tempDict = NSDictionary()
            tempDict = tempArray.object(at: 0) as! NSDictionary
            let pageType:String = tempDict.value(forKey: "pagetype") as! String
            if (pageType == "vehicleInspection"){
                self.configWebView(document: tempDict.value(forKey: "content") as! String)
            }
          }
        }
        if IS_IPHONE_X {
            let adjustFrame = agreeBtn.frame
            agreeBtn.frame = CGRect.init(x: adjustFrame.origin.x, y: adjustFrame.origin.y-5, width: adjustFrame.size.width, height: adjustFrame.size.height)
        }
    }
    
    //MARK: Configure web view
    func configWebView(document:String)  {
        let htmlString:String = "<font face=\(APP_FONT_REGULAR) size='3'>\(document)"
        self.contentTextView.text = htmlString.html2String
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func agreeBtnTapped(_ sender: Any) {
        HPLActivityHUD.showActivity(with: .withMask)
        let agreeObj = UserServices()
        agreeObj.updateAgreement(type: "vehicle_inspection", onSuccess: {response in
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                Utility.shared.getStatusService()
            }
        })
        
    }

}
