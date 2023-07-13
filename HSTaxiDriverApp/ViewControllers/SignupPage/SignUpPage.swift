//
//  SignUpPage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 10/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
//import AccountKit
import CoreLocation
import FirebaseAuthUI
import PhoneNumberKit
import FirebasePhoneAuthUI

class SignUpPage: UIViewController,UITextFieldDelegate,locationPickerDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var fullnameTF: FloatLabelTextField!

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var emailTF: FloatLabelTextField!
    @IBOutlet var passwordTF: FloatLabelTextField!
    @IBOutlet var rePasswordTF: FloatLabelTextField!

    @IBOutlet var locationTF: FloatLabelTextField!
    @IBOutlet var signInBtn: UIButton!
    
    @IBOutlet var nameBorderLbl: UILabel!
    @IBOutlet var emailBorderLbl: UILabel!
    @IBOutlet var passwordBorderLbl: UILabel!
    @IBOutlet var locationBorderLbl: UILabel!
    @IBOutlet var repasswordBorderLbl: UILabel!
    
//    var accountKit: AccountKitManager?
  let authUI = FUIAuth.defaultAuthUI()
    
    var country_code:String?
    var phone_no:String?
    var lat = String()
    var lon  = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let providers: [FUIAuthProvider] = [
            FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!),
            ]
        authUI?.delegate = self
        self.authUI?.providers = providers


        // Do any additional setup after loading the view.
        self.setupInitialDetails()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.changeToRTL()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.textAlignment = .right
            self.nextBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.signInBtn.transform = CGAffineTransform(scaleX: -1, y: 1)

            self.fullnameTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.fullnameTF.textAlignment = .right
            self.emailTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.emailTF.textAlignment = .right
            self.passwordTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.passwordTF.textAlignment = .right
            self.rePasswordTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rePasswordTF.textAlignment = .right
            self.locationTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.locationTF.textAlignment = .right
        }
        else {
            self.view.transform = .identity
            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
            self.nextBtn.transform = .identity
            self.signInBtn.transform = .identity
            
            self.fullnameTF.transform = .identity
            self.fullnameTF.textAlignment = .left
            self.emailTF.transform = .identity
            self.emailTF.textAlignment = .left
            self.passwordTF.transform = .identity
            self.passwordTF.textAlignment = .left
            self.rePasswordTF.transform = .identity
            self.rePasswordTF.textAlignment = .left
            self.locationTF.transform = .identity
            self.locationTF.textAlignment = .left
        }
    }
    func firebaseLogin() {
        let phoneProvider = FUIAuth.defaultAuthUI()?.providers.first as! FUIPhoneAuth
        FUIAuth.defaultAuthUI()?.auth?.languageCode = "en"
        phoneProvider.signIn(withPresenting: self, phoneNumber: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: set up intial details
    func setupInitialDetails()  {
//        self.accountKit = AccountKitManager.init(responseType: ResponseType.accessToken)
        self.navigationView.elevationEffect()
        scrollView.contentSize = CGSize.init(width:0 , height: 600)
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "signup")
        self.fullnameTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "name")
        self.emailTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "email")
        self.passwordTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "password")
        self.rePasswordTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "repassword")
        self.locationTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "location")
        self.nextBtn.config(color: .white, size: 17, align: .center, title: "next")
        self.nextBtn.cornerMiniumRadius()
        self.nextBtn.backgroundColor = PRIMARY_COLOR
        self.signInBtn.config(color: .black, size: 14, align: .center, title: "haveaccount")
        
        let alreadyMemberStr = Utility.shared.getLanguage()?.value(forKey: "haveaccount")as! NSString
        let signupStr = Utility.shared.getLanguage()?.value(forKey: "signin")as! NSString
        let range = alreadyMemberStr.range(of: signupStr as String)
        
        let attribute = NSMutableAttributedString.init(string: alreadyMemberStr as String)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: PRIMARY_COLOR , range: range)
        self.signInBtn.titleLabel?.attributedText = attribute
    }
    
    //config fb accountkit
//    func _prepareLoginViewController(_ loginViewController: (UIViewController & AKFViewController)?) {
//        loginViewController?.delegate = self
//        // Optionally, you may set up backup verification methods.
//        loginViewController?.isSendToFacebookEnabled = true
//        loginViewController?.uiManager = SkinManager.init(skinType: .classic, primaryColor: PRIMARY_COLOR)
//    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        if self.isValidationSuccess() {
            
            self.emailTF.resignFirstResponder()
            self.passwordTF.resignFirstResponder()
            self.fullnameTF.resignFirstResponder()
            self.rePasswordTF.resignFirstResponder()
            self.locationTF.resignFirstResponder()
            self.signUpWebService()
        }
    }
    
    @IBAction func signInBtnTapped(_ sender: Any) {
        let signInObj  = SignInPage()
        self.navigationController?.pushViewController(signInObj, animated: true)
    }
    
    @IBAction func locationBtnTapped(_ sender: Any) {
        let locationObj = LocationSearchPage()
        locationObj.delegate = self
        locationObj.selectedLocation = self.locationTF.text!
        locationObj.modalPresentationStyle = .fullScreen
        self.navigationController?.present(locationObj, animated: true, completion: nil)
    }
    
    
    //MARK: move to phone number verification page
//    func verifyPhoneNo()  {
//        let preFillPhoneNumber: PhoneNumber? = nil
//        let inputState = UUID().uuidString
//        weak var viewController: (UIViewController & AKFViewController)? = accountKit?.viewControllerForPhoneLogin(with: preFillPhoneNumber, state: inputState)
//        _prepareLoginViewController(viewController)
//        // see above
//        if let aController = viewController {
//            present(aController, animated: true) {() -> Void in }
//        }
//    }
    //MARK: Phone number verification delegate
//    func viewController(_ viewController: (UIViewController & AKFViewController), didCompleteLoginWith accessToken: AKFAccessToken, state: String) {
//        let accountK = AccountKitManager(responseType: ResponseType.accessToken)
//        accountK.requestAccount { (account, error) in
//            if(error != nil){
//                //error while fetching information
//                print("error \(String(describing: error?.localizedDescription))")
//            }else{
//                self.phone_no = account?.phoneNumber?.phoneNumber
//                self.country_code = account?.phoneNumber?.countryCode
//                HPLActivityHUD.showActivity(with: .withMask)
//                self.signInService()
//
//            }
//        }
//    }
    
//    func viewController(_ viewController: (UIViewController & AKFViewController), didFailWithError error: Error) {
//        print("failed \(error.localizedDescription) ")
//    }
    
//    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)) {
//            self.fullnameTF.text = EMPTY_STRING
//            self.emailTF.text = EMPTY_STRING
//            self.passwordTF.text = EMPTY_STRING
//            self.rePasswordTF.text = EMPTY_STRING
//            self.locationTF.text = EMPTY_STRING
//        self.view.makeToast(Utility.shared.getLanguage()?.value(forKey: "account_created") as? String)
//    }
    
    //MARK: Check text field validation
    func isValidationSuccess() -> Bool {
        var status:Bool = false
        if self.fullnameTF.isEmptyValue(){
            self.nameBorderLbl.backgroundColor = RED_COLOR
            self.fullnameTF.setAsInvalidTF("enter_name", in: self.view)
        }else if (self.fullnameTF.text?.count)!<3{
            self.nameBorderLbl.backgroundColor = RED_COLOR
            self.fullnameTF.setAsInvalidTF("name_limit", in: self.view)
        }else if self.emailTF.isEmptyValue() {
            self.emailBorderLbl.backgroundColor = RED_COLOR
            self.emailTF.setAsInvalidTF("enter_email", in: self.view)
        }else if !self.emailTF.isValidEmail(){
            self.emailBorderLbl.backgroundColor = RED_COLOR
            self.emailTF.setAsInvalidTF("enter_valid_email", in: self.view)
        }else if self.passwordTF.isEmptyValue(){
            self.passwordBorderLbl.backgroundColor = RED_COLOR
            self.passwordTF.setAsInvalidTF("enter_password", in: self.view)
        }else if (self.passwordTF.text?.count)!<6{
            self.passwordBorderLbl.backgroundColor = RED_COLOR
            self.passwordTF.setAsInvalidTF("password_limit", in: self.view)
        }else if self.rePasswordTF.isEmptyValue(){
            self.repasswordBorderLbl.backgroundColor = RED_COLOR
            self.rePasswordTF.setAsInvalidTF("enter_repassword", in: self.view)
        }else if self.passwordTF.text != self.rePasswordTF.text{
            self.rePasswordTF.text = EMPTY_STRING
            self.repasswordBorderLbl.backgroundColor = RED_COLOR
            self.rePasswordTF.setAsInvalidTF("password_not_match", in: self.view)
        }else if self.locationTF.isEmptyValue(){
            self.locationBorderLbl.backgroundColor = RED_COLOR
            self.locationTF.setAsInvalidTF("enter_location", in: self.view)
        }else{
            status = true
            self.clearValidation()
        }
        return status
    }
    //MARK: Clear text field validation
    func clearValidation()  {
        self.emailTF.setAsValidTF()
        self.passwordTF.setAsValidTF()
        self.fullnameTF.setAsValidTF()
        self.rePasswordTF.setAsValidTF()
        self.locationTF.setAsValidTF()
        
        self.emailBorderLbl.backgroundColor = SEPARTOR_COLOR
        self.passwordBorderLbl.backgroundColor = SEPARTOR_COLOR
        self.nameBorderLbl.backgroundColor = SEPARTOR_COLOR
        self.repasswordBorderLbl.backgroundColor = SEPARTOR_COLOR
        self.locationBorderLbl.backgroundColor = SEPARTOR_COLOR
    }
    
    //MARK: Textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.clearValidation()
        let full_string = textField.text!+string
        
        if textField.tag == 1 {
            let set = NSCharacterSet.init(charactersIn:ALPHA_PREDICT)
            let characterSet = CharacterSet(charactersIn: string)
            if full_string.count>30{
                return false
            }
            return set.isSuperset(of: characterSet)
        }
        return true
    }
    
    //MARK: location picker delegate
    func selectedLocation(location_name: String, lat: String, lon: String) {
        UserModel.shared.setLocation(lat: lat, lng: lon)
        self.locationTF.text = location_name
        self.lat = lat
        self.lon = lon
        self.clearValidation()
    }
    //MARK: sign up Web service
    func signUpWebService()  {
        let loginObj = LoginWebServices()
        loginObj.signUpService(full_name: self.fullnameTF.text!, email: self.emailTF.text!, password: self.passwordTF.text!,location: self.locationTF.text!,lat:self.lat,lon:self.lon, onSuccess: {response in
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                HPLActivityHUD.dismiss()
                self.firebaseLogin()
            }else{
                HPLActivityHUD.dismiss()
                Utility.shared.showAlert(msg: response.value(forKey: "message") as! String, status: "1")
            }
        }, onFailure: {errorResponse in
        })
    }

    //MARK: sign in Web service
    func signInService()  {
        let signinServiceObj = LoginWebServices()
        signinServiceObj.signInService(email: self.emailTF.text!, password: self.passwordTF.text!,country_code:self.country_code!,phone_no: self.phone_no!,type:"withphone",onSuccess: {response in
            HPLActivityHUD.dismiss()
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                UserModel.shared.removeEmergencyContact()
                UserModel.shared.setUserInfo(userDict: response)
                UserModel.shared.setApproveDict(adminDict: response)
                UserModel.shared.setProfilePic(URL: response.object(forKey: "user_image") as! NSString)
                Utility.shared.registerPushServices()
                Utility.shared.checkApprovedStatus()
            }else{
            }
        })
    }
}
extension SignUpPage: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        print(error?.localizedDescription ?? "")
        if error == nil {
            let phoneNumberKit = PhoneNumberKit()
            do {
                let phoneNumbers = try phoneNumberKit.parse(authDataResult?.user.phoneNumber ?? "")
                self.phone_no = "\(phoneNumbers.nationalNumber)"
                self.country_code = "\(phoneNumbers.countryCode)"
                HPLActivityHUD.showActivity(with: .withMask)
                self.signInService()
            }
            catch {
                print("Generic parser error")
            }
        }
        else {
        }
    }
    
    func authUI(_ authUI: FUIAuth, didFinish operation: FUIAccountSettingsOperationType, error: Error?) {
        print(error?.localizedDescription ?? "")
    }
    
}
