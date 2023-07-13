//
//  BrainTreeDetailsPage.swift
//  HSTaxiDriverApp
//
//  Created by APPLE on 27/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

protocol brainTreeDelegate {
   func BTdetailsStatus(enable:Bool)
}

class BrainTreeDetailsPage: UIViewController,UITextFieldDelegate {

    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var routingNoTF: FloatLabelTextField!
    @IBOutlet var accNoTF: FloatLabelTextField!
    @IBOutlet var nameTF: FloatLabelTextField!
    @IBOutlet var addressTF: FloatLabelTextField!

    @IBOutlet var navigationView: UIView!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var merchantBorderLbl: UILabel!
    @IBOutlet var publicBorderLbl: UILabel!
    @IBOutlet var primaryBorderLbl: UILabel!
    @IBOutlet var addressBorderLbl: UILabel!

    var delegate:brainTreeDelegate?
    var viewType = String()
    var paymentDict = NSDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupInitialDetails()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.changeToRTL()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.routingNoTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.routingNoTF.textAlignment = .right

            self.accNoTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.accNoTF.textAlignment = .right

            self.nameTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameTF.textAlignment = .right

            self.addressTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.addressTF.textAlignment = .right

            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.textAlignment = .right
        }
        else {
            self.view.transform = .identity
            self.routingNoTF.transform = .identity
            self.routingNoTF.textAlignment = .left

            self.accNoTF.transform = .identity
            self.accNoTF.textAlignment = .left

            self.nameTF.transform = .identity
            self.nameTF.textAlignment = .left

            self.addressTF.transform = .identity
            self.addressTF.textAlignment = .left

            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: set up intial details
    func setupInitialDetails()  {
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "payment_management")
        self.saveBtn.config(color: .white, size: 17, align: .center, title: "save")
        self.saveBtn.cornerMiniumRadius()
        self.saveBtn.backgroundColor = PRIMARY_COLOR
        self.navigationView.elevationEffect()
        self.routingNoTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "routing_no")
        self.accNoTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "bank_no")
        self.nameTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "holder_name")
        self.addressTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "holder_address")

        //set previously updated details
        if self.viewType == EDIT_VIEW {
            self.routingNoTF.text = self.paymentDict.value(forKey: "routingno") as? String
            self.accNoTF.text = self.paymentDict.value(forKey: "bankaccountno") as? String
            self.nameTF.text = self.paymentDict.value(forKey: "name") as? String
            self.addressTF.text = self.paymentDict.value(forKey: "address") as? String
        }
    }

    @IBAction func saveBtnTapped(_ sender: Any) {
        if isValidationSuccess(){
            let  paymentObj = UserServices()
            paymentObj.updatePaymentDetails(type: "bankaccount", routing_no: self.routingNoTF.text!, bank_ac: self.accNoTF.text!, name: self.nameTF.text!, address: self.addressTF.text!, onSuccess:{ response in
                let status:NSString = response.value(forKey: "status") as! NSString
                if status.isEqual(to: STATUS_TRUE){
                    self.delegate?.BTdetailsStatus(enable:true)
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Check text field validation
    func isValidationSuccess() -> Bool {
        var status:Bool = false
        if self.routingNoTF.isEmptyValue(){
            self.merchantBorderLbl.backgroundColor = RED_COLOR
            self.routingNoTF.setAsInvalidTF("enter_routing_no", in: self.view)
        }else if self.accNoTF.isEmptyValue(){
            self.publicBorderLbl.backgroundColor = RED_COLOR
            self.accNoTF.setAsInvalidTF("enter_ac", in: self.view)
        }else if self.nameTF.isEmptyValue() {
            self.primaryBorderLbl.backgroundColor = RED_COLOR
            self.nameTF.setAsInvalidTF("enter_name", in: self.view)
        }else if self.addressTF.isEmptyValue() {
            self.addressBorderLbl.backgroundColor = RED_COLOR
            self.addressTF.setAsInvalidTF("enter_address", in: self.view)
        }else{
            status = true
            self.clearValidation()
        }
        return status
    }
    
    //MARK: Clear text field validation
    func clearValidation()  {
        self.accNoTF.setAsValidTF()
        self.nameTF.setAsValidTF()
        self.routingNoTF.setAsValidTF()
        self.addressTF.setAsValidTF()
        self.addressBorderLbl.backgroundColor = SEPARTOR_COLOR
        self.merchantBorderLbl.backgroundColor = SEPARTOR_COLOR
        self.publicBorderLbl.backgroundColor = SEPARTOR_COLOR
        self.primaryBorderLbl.backgroundColor = SEPARTOR_COLOR
    }
    
    //MARK: Textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            self.clearValidation()
        if textField.tag == 1  || textField.tag == 4{
            let set = NSCharacterSet.init(charactersIn:ALPHA_NUMERIC_PREDICT)
            let characterSet = CharacterSet(charactersIn: string)
            return true //set.isSuperset(of: characterSet)
        }else if textField.tag == 2{
            let set = NSCharacterSet.init(charactersIn:NUMERIC_PREDICT)
            let characterSet = CharacterSet(charactersIn: string)
            return set.isSuperset(of: characterSet)
        }else if textField.tag == 3{
            let set = NSCharacterSet.init(charactersIn:ALPHA_PREDICT)
            let characterSet = CharacterSet(charactersIn: string)
            return set.isSuperset(of: characterSet)
        }
        return true
    }
    
}
