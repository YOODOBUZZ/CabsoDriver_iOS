//
//  SignInPage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 10/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
//import AccountKit
import FirebaseAuthUI
import FirebasePhoneAuthUI
import PhoneNumberKit

class SignInPage: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var signInBtn: UIButton!
    @IBOutlet var emailTF: FloatLabelTextField!
    @IBOutlet var passwordTF: FloatLabelTextField!
    @IBOutlet var signUpBtn: UIButton!
    @IBOutlet var forgotBtn: UIButton!
    @IBOutlet weak var rideBtn: UIButton!
    @IBOutlet var emailBorderLbl: UILabel!
    @IBOutlet var passwordBorderLbl: UILabel!
    @IBOutlet weak var orLbl: UILabel!
    
    var country_code:String?
    var phone_no:String?
    //    var accountKit: AccountKitManager?
    let authUI = FUIAuth.defaultAuthUI()
    
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
            self.orLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.emailTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.emailTF.textAlignment = .right
            self.passwordTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.passwordTF.textAlignment = .right
            self.forgotBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.signInBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.signUpBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rideBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            //            self.forgotBtn.contentHorizontalAlignment = .left
        }
        else {
            self.view.transform = .identity
            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
            self.orLbl.transform = .identity
            self.emailTF.transform = .identity
            self.emailTF.textAlignment = .left
            self.passwordTF.transform = .identity
            self.passwordTF.textAlignment = .left
            self.forgotBtn.transform = .identity
            self.rideBtn.transform = .identity
            //            self.forgotBtn.contentHorizontalAlignment = .right
            self.signInBtn.transform = .identity
            self.signUpBtn.transform = .identity
            
        }
    }
    func firebaseLogin() {
        let phoneProvider = FUIAuth.defaultAuthUI()?.providers.first as! FUIPhoneAuth
        phoneProvider.signIn(withPresenting: self, phoneNumber: nil)
    }
    //MARK: set up intial details
    func setupInitialDetails()  {
        //        self.accountKit = AccountKitManager.init(responseType: ResponseType.accessToken)
        
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "signin")
        self.orLbl.config(color: TEXT_PRIMARY_COLOR, size: 14, align: .center, text: "or")
        self.emailTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "email")
        self.passwordTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "password")
        self.signInBtn.config(color: .white, size: 17, align: .center, title: "signin")
        self.signInBtn.cornerMiniumRadius()
        self.signInBtn.backgroundColor = PRIMARY_COLOR
        self.signUpBtn.config(color: .black, size: 14, align: .center, title: "noaccount")
        
        let alreadyMemberStr = Utility.shared.getLanguage()?.value(forKey: "noaccount")as! NSString
        let signupStr = Utility.shared.getLanguage()?.value(forKey: "signup")as! NSString
        let range = alreadyMemberStr.range(of: signupStr as String)
        let attribute = NSMutableAttributedString.init(string: alreadyMemberStr as String)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: PRIMARY_COLOR , range: range)
        self.signUpBtn.titleLabel?.attributedText = attribute
        
        self.rideBtn.config(color: .black, size: 14, align: .center, title: "ride_app")
        self.forgotBtn.config(color: RED_COLOR, size: 15, align: .center, title: "fogotpassword")
        self.navigationView.elevationEffect()
    }
    
    //dismiss current page
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //sign in action
    @IBAction func signInBtnTapped(_ sender: Any) {

        if self.isValidationSuccess() {
            self.emailTF.resignFirstResponder()
            self.passwordTF.resignFirstResponder()
            self.signInService(type: "withoutphone")
        }
    }
    
    //dont have account move to sign up page
    @IBAction func signUpBtnTapped(_ sender: Any) {
        let signUpObj = SignUpPage()
        self.navigationController?.pushViewController(signUpObj, animated: true)
    }
    
    @IBAction func rideApp(_ sender: Any) {
        UIApplication.shared.open(URL.init(string:USER_APP_LINK)!, options: [:], completionHandler: nil)
        //        UIApplication.shared.canOpenURL(URL(string:"from-cabso://")! as URL)
        
        
    }
    
    //forgot password move to reset password page
    @IBAction func forgotBtnTapped(_ sender: Any) {
        let forgotObj  = ForgotPasswordPage()
        forgotObj.modalPresentationStyle = .fullScreen
        self.navigationController?.present(forgotObj, animated: true, completion: nil)
    }
    
    //MARK: Textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.clearValidation()
        return true
    }
    
    //MARK: Check text field validation
    func isValidationSuccess() -> Bool {
        var status:Bool = false
        if self.emailTF.isEmptyValue() {
            self.emailBorderLbl.backgroundColor = RED_COLOR
            self.emailTF.setAsInvalidTF("enter_email", in: self.view)
        }else if !self.emailTF.isValidEmail(){
            self.emailBorderLbl.backgroundColor = RED_COLOR
            self.emailTF.setAsInvalidTF("enter_valid_email", in: self.view)
        }else if self.passwordTF.isEmptyValue(){
            self.clearValidation()
            self.passwordBorderLbl.backgroundColor = RED_COLOR
            self.passwordTF.setAsInvalidTF("enter_password", in: self.view)
        }else if (self.passwordTF.text?.count)!<6{
            self.passwordBorderLbl.backgroundColor = RED_COLOR
            self.passwordTF.setAsInvalidTF("password_limit", in: self.view)
        }else{
            self.clearValidation()
            status = true
        }
        return status
    }
    
    //MARK: Clear text field validation
    func clearValidation()  {
        self.emailTF.setAsValidTF()
        self.passwordTF.setAsValidTF()
        self.emailBorderLbl.backgroundColor = SEPARTOR_COLOR
        self.passwordBorderLbl.backgroundColor = SEPARTOR_COLOR
        
    }
    
    //config account kit
    //    func _prepareLoginViewController(_ loginViewController: (UIViewController & AKFViewController)?) {
    //        loginViewController?.delegate = self
    //        // Optionally, you may set up backup verification methods.
    //        loginViewController?.isSendToFacebookEnabled = true
    //        loginViewController?.uiManager = SkinManager.init(skinType: .classic, primaryColor: PRIMARY_COLOR)
    //
    //    }
    
    //MARK: move to phone number verification page
    //    func verifyPhoneNo()  {
    //        let preFillPhoneNumber: PhoneNumber? = nil
    //        let inputState = UUID().uuidString
    //        weak var viewController: (UIViewController & AKFViewController)? = accountKit?.viewControllerForPhoneLogin(with: preFillPhoneNumber, state: inputState)
    //        _prepareLoginViewController(viewController)
    //        // see above
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
    //                print("error \(String(describing: error?.localizedDescription)) ")
    //            }else{
    //                self.phone_no = account?.phoneNumber?.phoneNumber
    //                self.country_code = account?.phoneNumber?.countryCode
    //                self.signInService(type: "withphone")
    //            }
    //        }
    //    }
    
    //    func viewController(_ viewController: (UIViewController & AKFViewController), didFailWithError error: Error) {
    //        print("failed \(error.localizedDescription) ")
    //    }
    
    //MARK: sign in web service call
    func signInService(type:String)  {
        if self.phone_no == nil {
            self.phone_no = ""
            self.country_code = ""
        }
        HPLActivityHUD.showActivity(with: .withMask)
        let signinServiceObj = LoginWebServices()
        signinServiceObj.signInService(email: self.emailTF.text!, password: self.passwordTF.text!,country_code:self.country_code!,phone_no: self.phone_no!,type: type, onSuccess: {response in
            HPLActivityHUD.dismiss()
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                if type == "withoutphone"{
//                                        self.verifyPhoneNo()
                    self.firebaseLogin()
//                    self.phone_no = "9597121763"
//                    self.country_code = "+91"
//                    self.signInService(type: "withphone")
                    
                }else{
                    UserModel.shared.removeEmergencyContact()
                    UserModel.shared.setUserInfo(userDict: response)
                    UserModel.shared.setApproveDict(adminDict: response)
                    UserModel.shared.setProfilePic(URL: response.object(forKey: "user_image") as! NSString)
                    if UserModel.shared.getApprove().value(forKey: "approval") as! String == "false"{
                        AJAlertController.initialization().showAlertWithOkButton(aStrMessage:Utility.shared.getLanguage()?.value(forKey: "acc_deactivate") as! String, status: "1" , completion: { (index, title) in
                            UserModel.shared.logoutUser()
                        })
                    }else{
                        Utility.shared.registerPushServices()
                        Utility.shared.checkApprovedStatus()
                    }
                }
            }else{
                let message:NSString = response.value(forKey: "message") as! NSString
                if message.isEqual(to: Utility.shared.getLanguage()?.value(forKey: "password_auth") as! String){
                    self.passwordTF.text = EMPTY_STRING
                }
                Utility.shared.showAlert(msg: message as String, status: "1")
            }
        })
    }
}
extension SignInPage: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        print(error?.localizedDescription ?? "")
        if error == nil {
            let phoneNumberKit = PhoneNumberKit()
            do {
                let phoneNumbers = try phoneNumberKit.parse(authDataResult?.user.phoneNumber ?? "")
                self.phone_no = "\(phoneNumbers.nationalNumber)"
                self.country_code = "\(phoneNumbers.countryCode)"
                self.signInService(type: "withphone")
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
