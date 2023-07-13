//
//  SignupValidationPage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 20/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class SignupValidationPage: UIViewController {
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet var vehicleDetailsBtn: UIButton!
    @IBOutlet var paymentDetailsBtn: UIButton!
    @IBOutlet var vehicleInpBtn: UIButton!
    @IBOutlet var securityDepositBtn: UIButton!
    @IBOutlet weak var infoLbl: UILabel!

    @IBOutlet var vehicleDetailsIcon: UIImageView!
    @IBOutlet var paymentIcon: UIImageView!
    @IBOutlet var vehicleInpIcon: UIImageView!
    @IBOutlet var securityIcon: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpInitialDetails()
        self.checkAdminApproveStatus()
    }

    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.infoLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.vehicleDetailsIcon.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.paymentIcon.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.vehicleInpIcon.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.securityIcon.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.textAlignment = .right
        }
        else {
            self.view.transform = .identity
            self.infoLbl.transform = .identity
            self.vehicleDetailsIcon.transform = .identity
            self.paymentIcon.transform = .identity
            self.vehicleInpIcon.transform = .identity
            self.securityIcon.transform = .identity
            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Utility.shared.fetchAdminData()
        self.configApproveStatus()
        self.changeToRTL()
    }
    
    func setUpInitialDetails()  {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationView.elevationEffect()
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text:"adminApprove")
        self.configBtn(button: self.vehicleDetailsBtn, title: "vehicle_details")
        self.configBtn(button: self.paymentDetailsBtn, title: "payment_management")
        self.configBtn(button: self.vehicleInpBtn, title: "vehicle_inspect")
        self.configBtn(button: self.securityDepositBtn, title: "security_deposit")
        self.infoLbl.config(color: TEXT_TERTIARY_COLOR, size: 14, align: .center, text:EMPTY_STRING)
        self.infoLbl.attributedText(text:"contact_admin")
    }
    func configBtn(button:UIButton,title:String){
        button.config(color: .white, size: 17, align: .center, title: title)
        button.cornerMiniumRadius()
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
    }
    
    func configApproveStatus(){
        //check vehicle details status
        if UserModel.shared.getApprove().value(forKey:"vehicle_details") as! String == "Complete"{
            if  UserModel.shared.getApprove().value(forKey:"vehicle_approval") as! String == "rejected"{
                self.vehicleDetailsBtn.backgroundColor = RED_COLOR
            }else{
                self.vehicleDetailsBtn.backgroundColor = GREEN_COLOR
            }
            self.vehicleDetailsIcon.isHidden = false
        }else{
            self.vehicleDetailsBtn.backgroundColor = VALIDATION_COLOR
        }
        
        //check payment details status
        if UserModel.shared.getApprove().value(forKey:"payment_details") as! String == "Complete"{
            self.paymentDetailsBtn.backgroundColor = GREEN_COLOR
            self.paymentIcon.isHidden = false
        }else{
            self.paymentDetailsBtn.backgroundColor = VALIDATION_COLOR
        }
        
        //check vehicle inspection status
        if UserModel.shared.getApprove().value(forKey:"vehicle_inspection") as! String == "Complete"{
         
            self.vehicleInpBtn.backgroundColor = GREEN_COLOR
            self.vehicleInpIcon.isHidden = false
        }else{
            self.vehicleInpBtn.backgroundColor = VALIDATION_COLOR
        }
        
        //check security inspection status
        if UserModel.shared.getApprove().value(forKey:"security_deposit") as! String == "Complete"{
            self.securityDepositBtn.backgroundColor = GREEN_COLOR
            self.securityIcon.isHidden = false
        }else{
            self.securityDepositBtn.backgroundColor = VALIDATION_COLOR
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
    }
    
    //go to vehicle details page
    @IBAction func vehicleDetailsBtnTapped(_ sender: Any) {
        let vehicleObj = VehicleDetailsPage()
        if UserModel.shared.getApprove().value(forKey:"vehicle_details") as! String == "Complete"{
            self.vehicleDetailsBtn.backgroundColor = GREEN_COLOR
            vehicleObj.viewType = EDIT_VIEW
            vehicleDetailsIcon.isHidden = false
        }else{
            vehicleObj.viewType = NORMAL_VIEW
        }
        self.navigationController?.pushViewController(vehicleObj, animated: true)
    }
    //go to payment details page
    @IBAction func paymentDetailsBtnTapped(_ sender: Any) {
        let paymentObj = PaymentDetailsPage()
        if UserModel.shared.getApprove().value(forKey:"payment_details") as! String == "Complete"{
            self.paymentDetailsBtn.backgroundColor = GREEN_COLOR
            paymentObj.viewType = EDIT_VIEW
            paymentIcon.isHidden = false

        }else{
            paymentObj.viewType = NORMAL_VIEW
        }
        self.navigationController?.pushViewController(paymentObj, animated: true)

    }
    //go to vehicle inspection page
    @IBAction func vehicleInpBtnTapped(_ sender: Any) {
        let vehicleObj = VehicleInspectionPage()
        if UserModel.shared.getApprove().value(forKey:"vehicle_inspection") as! String == "Complete"{
            self.vehicleInpBtn.backgroundColor = GREEN_COLOR
            vehicleObj.viewType = EDIT_VIEW
            vehicleInpIcon.isHidden = false
        }else{
            vehicleObj.viewType = NORMAL_VIEW
        }
        self.navigationController?.pushViewController(vehicleObj, animated: true)

    }
    
    //go to security inspection page
    @IBAction func securityInpBtnTapped(_ sender: Any) {
        let securityObj = SecurityDepositPage()
        if UserModel.shared.getApprove().value(forKey:"security_deposit") as! String == "Complete"{
            self.securityDepositBtn.backgroundColor = .gray
            securityObj.viewType = EDIT_VIEW
            securityIcon.isHidden = false
        }else{
            securityObj.viewType = NORMAL_VIEW
        }
        self.navigationController?.pushViewController(securityObj, animated: true)
    }
    
    func checkAdminApproveStatus()  {
        if UserModel.shared.getApprove().value(forKey:"vehicle_details") as! String == "Complete" || UserModel.shared.getApprove().value(forKey:"payment_details") as! String == "Complete" || UserModel.shared.getApprove().value(forKey:"vehicle_inspection") as! String == "Complete" || UserModel.shared.getApprove().value(forKey:"security_deposit") as! String == "Complete"{
//            waitingApprove
            self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, text:"waitingApprove")
            let phoneNo = UserModel.shared.getUserDetails().value(forKey: "phone_number") as? String ?? "\(UserModel.shared.getUserDetails().value(forKey: "phone_number") as? NSNumber ?? 0)"
            let signinServiceObj = LoginWebServices()
            signinServiceObj.signInService(email:  UserModel.shared.getUserDetails().value(forKey: "email") as! String, password: UserModel.shared.getPassword()! as String,country_code:UserModel.shared.getUserDetails().value(forKey: "country_code") as! String,phone_no:phoneNo,type:"withphone",onSuccess: {response in
                HPLActivityHUD.dismiss()
                let status:NSString = response.value(forKey: "status") as! NSString
                if status.isEqual(to: STATUS_TRUE){
                    UserModel.shared.removeEmergencyContact()
                    UserModel.shared.setUserInfo(userDict: response)
                    UserModel.shared.setApproveDict(adminDict: response)                    
                    if UserModel.shared.getApprove().value(forKey: "approval") as! String == "false"{
                        AJAlertController.initialization().showAlertWithOkButton(aStrMessage:Utility.shared.getLanguage()?.value(forKey: "acc_deactivate") as! String, status: "1" , completion: { (index, title) in
                            UserModel.shared.logoutUser()
                        })
                    }else if UserModel.shared.getApprove().value(forKey: "approval") as! String == "true" && UserModel.shared.getApprove().value(forKey:"vehicle_approval") as! String == "approved" {
                        Utility.shared.checkApprovedStatus()
                    }
                    self.configApproveStatus()
                }
            })
            
        }
    }

}
