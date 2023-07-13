//
//  VehicleDetailsPage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 20/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import MobileCoreServices

class VehicleDetailsPage: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDocumentPickerDelegate,UITextFieldDelegate,listSelectionDelegate {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var vehicleNameTF: FloatLabelTextField!
    @IBOutlet var noSeatsTF: FloatLabelTextField!
    @IBOutlet var bodyTypeTF: FloatLabelTextField!
    @IBOutlet var amenitiesTF: FloatLabelTextField!
    @IBOutlet var vehicleNoTF: FloatLabelTextField!
    @IBOutlet var licenceNoTF: FloatLabelTextField!
    @IBOutlet var licenceDocTF: FloatLabelTextField!
    @IBOutlet var licenceExpDateTF: FloatLabelTextField!
    @IBOutlet var insuranceNoTF: FloatLabelTextField!
    @IBOutlet var insuranceDocTF: FloatLabelTextField!
    @IBOutlet var insuranceExpDateTF: FloatLabelTextField!
    @IBOutlet var rcNoTF: FloatLabelTextField!
    @IBOutlet var rcDocTF: FloatLabelTextField!
    @IBOutlet var rcExpDateTF: FloatLabelTextField!
    @IBOutlet var licenceSuccessView: UIView!
    @IBOutlet var insuraceSuccessView: UIView!
    @IBOutlet var rcbookSuccessView: UIView!
    @IBOutlet var vehicleBorderLbl: UILabel!
    @IBOutlet var vehicleNoBorderLbl: UILabel!
    @IBOutlet var seatsBorderLbl: UILabel!
    @IBOutlet var licenceBorderLbl: UILabel!
    @IBOutlet var insuranceNoBorderLbl: UILabel!
    @IBOutlet var rcNoBorderLbl: UILabel!
    
    var currentDate = Date()
    var dateComponents = DateComponents()
    var maxDate = Date()
    var minDate = Date()
    let dateFormatter = DateFormatter()
    let imagePicker = UIImagePickerController()
    var amenitiesSelectedIndex = NSMutableArray()
    var bodyTypeSelectedIndex = NSMutableArray()

    var picType = String()
    var docuFor = String()
    var listArray = NSMutableArray()
    var viewType = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupInitialDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.changeToRTL()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.vehicleNameTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.vehicleNameTF.textAlignment = .right
            self.noSeatsTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.noSeatsTF.textAlignment = .right
            self.bodyTypeTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.bodyTypeTF.textAlignment = .right
            self.amenitiesTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.amenitiesTF.textAlignment = .right
            self.vehicleNoTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.vehicleNoTF.textAlignment = .right
            self.licenceNoTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.licenceNoTF.textAlignment = .right
            self.licenceDocTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.licenceDocTF.textAlignment = .right
            self.licenceExpDateTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.licenceExpDateTF.textAlignment = .right
            self.insuranceNoTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.insuranceNoTF.textAlignment = .right
            self.insuranceDocTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.insuranceDocTF.textAlignment = .right
            self.insuranceExpDateTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.insuranceExpDateTF.textAlignment = .right
            self.rcNoTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rcNoTF.textAlignment = .right
            self.rcDocTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rcDocTF.textAlignment = .right
            self.rcExpDateTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rcExpDateTF.textAlignment = .right

            self.nextBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.textAlignment = .right
        }
        else {
            self.view.transform = .identity
            self.vehicleNameTF.transform = .identity
            self.vehicleNameTF.textAlignment = .left
            self.noSeatsTF.transform = .identity
            self.noSeatsTF.textAlignment = .left
            self.bodyTypeTF.transform = .identity
            self.bodyTypeTF.textAlignment = .left
            self.amenitiesTF.transform = .identity
            self.amenitiesTF.textAlignment = .left
            self.vehicleNoTF.transform = .identity
            self.vehicleNoTF.textAlignment = .left
            self.licenceNoTF.transform = .identity
            self.licenceNoTF.textAlignment = .left
            self.licenceDocTF.transform = .identity
            self.licenceDocTF.textAlignment = .left
            self.licenceExpDateTF.transform = .identity
            self.licenceExpDateTF.textAlignment = .left
            self.insuranceNoTF.transform = .identity
            self.insuranceNoTF.textAlignment = .left
            self.insuranceDocTF.transform = .identity
            self.insuranceDocTF.textAlignment = .left
            self.insuranceExpDateTF.transform = .identity
            self.insuranceExpDateTF.textAlignment = .left
            self.rcNoTF.transform = .identity
            self.rcNoTF.textAlignment = .left
            self.rcDocTF.transform = .identity
            self.rcDocTF.textAlignment = .left
            self.rcExpDateTF.transform = .identity
            self.rcExpDateTF.textAlignment = .left

            self.nextBtn.transform = .identity
            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
        }
    }
    //MARK: set up intial details
    func setupInitialDetails()  {
        imagePicker.delegate = self
        self.navigationView.elevationEffect()
        scrollView.contentSize = CGSize.init(width:0 , height: 1700)
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "vehicle_details")
        self.vehicleNameTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "vehicle_name")
        self.noSeatsTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "no_seats")
        self.bodyTypeTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "body_type")
        self.amenitiesTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "amenities")
        self.vehicleNoTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "vehicle_no")
        self.licenceNoTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "licence_no")
        self.licenceDocTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "licence_doc")
        self.licenceExpDateTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "licence_exp_date")
        self.insuranceNoTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "insurance_no")
        self.insuranceDocTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "insurance_doc")
        self.insuranceExpDateTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "insurance_exp_date")
        self.rcNoTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "rc_book_no")
        self.rcDocTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "rc_book_doc")
        self.rcExpDateTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "rc_book_exp_date")
        self.nextBtn.config(color: .white, size: 17, align: .center, title: "next")
        self.nextBtn.cornerMiniumRadius()
        self.nextBtn.backgroundColor = PRIMARY_COLOR
        if IS_IPHONE_X {
            let adjustFrame = nextBtn.frame
            nextBtn.frame = CGRect.init(x: adjustFrame.origin.x, y: adjustFrame.origin.y-8, width: adjustFrame.size.width, height: adjustFrame.size.height)
            scrollView.contentSize = CGSize.init(width:0 , height: 1550)
        }
        //setup min & max date
        self.configDatePicker()
        if self.viewType == EDIT_VIEW {
            HPLActivityHUD.showActivity(with: .withMask)
            self.getVehicleDetailsService()
        }
    }
    
    //MARK: set up minimu & maximum date for datepicker
    func configDatePicker()  {
        var calendar = Calendar.init(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = +150
        maxDate = calendar.date(byAdding: components, to: currentDate)!
        components.year = -150
        minDate = currentDate
        dateFormatter.dateFormat = "dd/MM/yyyy"
    }
    //dismiss view
    @IBAction func backBtnTapped(_ sender: Any) {
       self.navigationController?.popToRootViewController(animated: true)
    }
    
    //go to list choosen view
    @IBAction func bodyTypeBtnTapped(_ sender: Any) {
        let listbodyObj = ListSelectionPage()
        listbodyObj.titleName = "body_type"
        listbodyObj.viewType = "1"
        listbodyObj.delegate = self
        listbodyObj.selectedIndexArray = self.bodyTypeSelectedIndex
        let tempArray :NSArray = UserModel.admin.value(forKey: "body_type") as! NSArray
        listbodyObj.listArray = tempArray.mutableCopy() as! NSMutableArray
        listbodyObj.modalPresentationStyle = .fullScreen
        self.navigationController?.present(listbodyObj, animated: true, completion: nil)

    }
    
    //go to list view
    @IBAction func amenitiesBtnTapped(_ sender: Any) {
        let listObj = ListSelectionPage()
        listObj.titleName = "amenities"
        listObj.viewType = "2"
        listObj.delegate = self
        listObj.selectedIndexArray = self.amenitiesSelectedIndex
        listObj.selectedArray = self.listArray
        let tempArray :NSArray = UserModel.admin.value(forKey: "amenities") as! NSArray
        listObj.listArray = tempArray.mutableCopy() as! NSMutableArray
        listObj.modalPresentationStyle = .fullScreen
        self.navigationController?.present(listObj, animated: true, completion: nil)
    }
    //MARK: licence document upload action
    @IBAction func licenceUploadTapped(_ sender: Any) {
        self.showDocumentPickerMenu(type: "1")
      
    }
    //MARK: Document picker menu
    func showDocumentPickerMenu(type:String) {
        self.picType = type
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let photos = UIAlertAction(title: Utility.shared.getLanguage()?.value(forKey: "photos") as? String, style: .default) { (action) in
            self.picPhoto()
        }
        let file = UIAlertAction(title: Utility.shared.getLanguage()?.value(forKey: "file") as? String, style: .default) { (action) in
            self.picDocument()
        }
        let cancel = UIAlertAction(title: Utility.shared.getLanguage()?.value(forKey: "cancel") as? String, style: .cancel)
        alertController.addAction(file)
        alertController.addAction(photos)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //MARK: pick photo from library
    func picPhoto()  {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
       self.present(imagePicker, animated: true, completion: nil)
    }
    //MARK: pic document from docment drobox icloud
    func picDocument()  {
        let types: NSArray = NSArray.init(objects: kUTTypePDF,kUTTypeJPEG)
        let documentPicker = UIDocumentPickerViewController(documentTypes: types as! [String], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        documentPicker.modalPresentationStyle = .fullScreen
        self.present(documentPicker, animated: true, completion: nil)
      
    }
    //MARK: Document picker delegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // you get from the urls parameter the urls from the files selected
        let fileData = NSData.init(contentsOf: URL.init(string: "\(urls[0])")!)
        let fileName = urls[0].lastPathComponent
        if self.picType == "1"{
            self.licenceDocTF.text = fileName
            self.docuFor = "licensedoc"
        }else if self.picType == "2"{
            self.insuranceDocTF.text = fileName
            self.docuFor = "insurancedoc"
        }else if self.picType == "3"{
            self.rcDocTF.text = fileName
            self.docuFor = "bookdoc"
        }
        self.uploadDocument(fileData: fileData! as Data, fileType:".\(urls[0].pathExtension)",fileName:fileName)
    }
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let imageUrl          = info[UIImagePickerControllerReferenceURL] as! NSURL
            print("Image Name \(imageUrl)")
            var imageName = String()
            
            let imageData: NSData = UIImageJPEGRepresentation(pickedImage, 0)! as NSData
            if self.picType == "1"{
                self.licenceDocTF.text = "licence.jpeg"
                imageName = self.licenceDocTF.text!
                self.docuFor = "licensedoc"
            }else if self.picType == "2"{
                self.insuranceDocTF.text = "insurance.jpeg"
                imageName = self.insuranceDocTF.text!
                self.docuFor = "insurancedoc"
            }else if self.picType == "3"{
                self.rcDocTF.text = "rcbook.jpeg"
                imageName = self.rcDocTF.text!
                self.docuFor = "bookdoc"
            }
            self.uploadDocument(fileData: imageData as Data, fileType:".jpeg",fileName:imageName)
        }
            self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // next btn tapped
    @IBAction func nextBtnTapped(_ sender: Any) {
        if isValidationSuccess() {
            self.updateVehicleDetails()
        }
    }
    
    //choose licence expiry date
    @IBAction func licenceDateTapped(_ sender: Any) {
        if !licenceExpDateTF.isEmptyValue() {
            currentDate = dateFormatter.date(from: licenceExpDateTF.text!)!
        }
        DPPickerManager.shared.showPicker(title: nil, selected: Date(), min: minDate, max: maxDate) { (date, cancel) in
            if !cancel {
                self.licenceExpDateTF.text = self.dateFormatter.string(from: date!)
            }
        }
    }
    
    //insurance doucment upload action
    @IBAction func insuranceUploadTapped(_ sender: Any) {
        self.showDocumentPickerMenu(type: "2")
    }
    
    //insurance expiry date action
    @IBAction func insuranceDateTapped(_ sender: Any) {
        if !insuranceExpDateTF.isEmptyValue() {
            currentDate = dateFormatter.date(from: insuranceExpDateTF.text!)!
        }
        DPPickerManager.shared.showPicker(title: nil, selected: currentDate, min: minDate, max: maxDate) { (date, cancel) in
            if !cancel {
                self.insuranceExpDateTF.text = self.dateFormatter.string(from: date!)
            }
        }
    }
    //rc book document upload action
    @IBAction func rcBookUploadTapped(_ sender: Any) {
        self.showDocumentPickerMenu(type: "3")
    }
    //rc book date expiry date action
    @IBAction func rcBookDateTapped(_ sender: Any) {
        if !rcExpDateTF.isEmptyValue() {
            currentDate = dateFormatter.date(from: rcExpDateTF.text!)!
        }
        DPPickerManager.shared.showPicker(title: nil, selected: currentDate, min: minDate, max: maxDate) { (date, cancel) in
            if !cancel {
                self.rcExpDateTF.text = self.dateFormatter.string(from: date!)
            }
        }
    }
    
    
    //MARK: Textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.clearValidation()
        let full_string = textField.text!+string

        if textField.tag == 1 {
            let set = NSCharacterSet.init(charactersIn:ALPHA_PREDICT)
            let characterSet = CharacterSet(charactersIn: string)
            return true //set.isSuperset(of: characterSet)
            
        } else if textField.tag == 2 {
            let set = NSCharacterSet.init(charactersIn:NUMERIC_PREDICT)
            let characterSet = CharacterSet(charactersIn: string)
            if full_string.count>2{
                return false
            }
            return set.isSuperset(of: characterSet)
            
        }else if textField.tag == 3 || textField.tag == 4 || textField.tag == 5 || textField.tag == 6{
            let set = NSCharacterSet.init(charactersIn:ALPHA_NUMERIC_PREDICT)
            let characterSet = CharacterSet(charactersIn: string)
            return set.isSuperset(of: characterSet)
        }
        return true
    }
    
    //MARK: amenties ,body type seletion delegate
    func selectedListWithDetails(listType: String, listArray: NSMutableArray,  indexArray: NSMutableArray)  {
        print("delegate\(indexArray)")
        
        var amentiesListName = String()
        if listArray.count != 0 {
        if listType == "1" {
            self.bodyTypeSelectedIndex = indexArray
            let listDict:NSDictionary = listArray.object(at: 0) as! NSDictionary
            self.bodyTypeTF.text = listDict.value(forKey: "name") as? String
        }else if listType == "2"{
            self.amenitiesSelectedIndex = indexArray
            self.listArray = listArray
            let requestArray = NSMutableArray()
            for listDict in listArray {
                let tempArray = NSMutableArray.init(array: [listDict])
                var tempDict = NSDictionary()
                tempDict = tempArray.object(at: 0) as! NSDictionary
                let tempDetails = NSMutableDictionary.init(dictionary:tempDict)
                requestArray.addObjects(from: [tempDetails])
                amentiesListName += "\(tempDetails.value(forKey: "name") ?? EMPTY_STRING),"
            }
            self.amenitiesTF.text = amentiesListName
        }
        }
        
        if indexArray.count == 0 {
            if listType == "1" {
            self.bodyTypeTF.text = EMPTY_STRING
            }else if listType == "2"{
            self.amenitiesTF.text = EMPTY_STRING
            }
        }
    }
    
    //MARK: Upload document function
    func uploadDocument(fileData:Data,fileType:String,fileName:String)  {
        HPLActivityHUD.showActivity(with: .withMask)
        let uploadObj = UploadServices()
        uploadObj.uploadDoc(fileData: fileData, uploaddocfor: self.docuFor, uploaddoctype: fileType, fileName: fileName, onSuccess: {response in
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                HPLActivityHUD.dismiss()
                if self.picType == "1"{
                    self.licenceSuccessView.isHidden = false
                }else if self.picType == "2"{
                    self.insuraceSuccessView.isHidden = false
                }else if self.picType == "3"{
                    self.rcbookSuccessView.isHidden = false
                }
            }
        })
    }
    
    //MARK: Vehicle details update service
    func updateVehicleDetails() {
        HPLActivityHUD.showActivity(with: .withMask)
        let updateVehicleObj = UserServices();        updateVehicleObj.updateVehicleDetails(vehicleName: self.vehicleNameTF.text!, noOfSeats: self.noSeatsTF.text!, bodyType: self.bodyTypeTF.text!, amenities: self.listArray, vehicleNo: self.vehicleNoTF.text!, licenceNo: self.licenceNoTF.text!, licenceDate: self.licenceExpDateTF.text!, insuranceNo: self.insuranceNoTF.text!, insruanceDate: self.insuranceExpDateTF.text!, rcNo: self.rcNoTF.text!, rcDate: self.rcExpDateTF.text!, onSuccess: {response in
            
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                Utility.shared.getStatusService()
            }
//            let paymentObj = PaymentDetailsPage()
//            self.navigationController?.pushViewController(paymentObj, animated: true)
        })
    }
    

    //MARK: get vehicle details
    func getVehicleDetailsService() {
        let getVehcileObj = UserServices()
        getVehcileObj.getVehicleInfo(onSuccess: {response in
            HPLActivityHUD.dismiss()
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                self.setVehicleDetails(vehicleDict:response)
            }
        })
    }
    //set vehicle details
    func setVehicleDetails(vehicleDict:NSDictionary) {
        self.vehicleNameTF.text = vehicleDict.value(forKey: "vehicle_name") as? String
        var availabelSeats = NSNumber()
         availabelSeats = vehicleDict.value(forKey: "available_seats") as! NSNumber
        self.noSeatsTF.text = String(describing: availabelSeats)
        self.bodyTypeTF.text = vehicleDict.value(forKey: "body_type") as? String
        self.vehicleNoTF.text = vehicleDict.value(forKey: "vehicle_number") as? String
        self.licenceNoTF.text = vehicleDict.value(forKey: "licence_no") as? String
        self.licenceDocTF.text = "licence.\(self.fileExtension(file: vehicleDict.value(forKey: "licensedoc") as! String))"
        
        self.licenceExpDateTF.text = vehicleDict.value(forKey: "licence_date") as? String
        self.insuranceNoTF.text = vehicleDict.value(forKey: "insurance_no") as? String
        self.insuranceDocTF.text = "insurance.\(self.fileExtension(file: vehicleDict.value(forKey: "insurancedoc") as! String))"
        self.insuranceExpDateTF.text = vehicleDict.value(forKey: "insurance_date") as? String
        self.rcNoTF.text = vehicleDict.value(forKey: "book_no") as? String
        self.rcDocTF.text = "rcbook.\(self.fileExtension(file: vehicleDict.value(forKey: "bookdoc") as! String))"
        self.rcExpDateTF.text = vehicleDict.value(forKey: "book_date") as? String
        
        //config amenties values
        var amentiesArray = NSArray()
        amentiesArray = vehicleDict.value(forKey: "amenities") as! NSArray
        let requestArray = NSMutableArray()
        var amentiesListName = String()
        for listDict in amentiesArray {
            let tempArray = NSMutableArray.init(array: [listDict])
            var tempDict = NSDictionary()
            tempDict = tempArray.object(at: 0) as! NSDictionary
            let tempDetails = NSMutableDictionary.init(dictionary:tempDict)
            requestArray.addObjects(from: [tempDetails])
            amentiesListName += "\(tempDetails.value(forKey: "name") ?? EMPTY_STRING),"
            self.amenitiesSelectedIndex.addObjects(from: [tempDetails.value(forKey: "_id") as Any])
            self.listArray.addObjects(from: [tempDetails])
        }
        self.amenitiesTF.text = amentiesListName
        
        //config body type
        var bodyTypeArray = NSArray()
       bodyTypeArray =  UserModel.admin.value(forKey: "body_type") as! NSArray
        for bodyDict in bodyTypeArray {
            let tempArray = NSMutableArray.init(array: [bodyDict])
            var tempDict = NSDictionary()
            tempDict = tempArray.object(at: 0) as! NSDictionary
            let tempDetails = NSMutableDictionary.init(dictionary:tempDict)
            let bodyType:String = tempDetails.value(forKey: "name") as! String
            if bodyType == self.bodyTypeTF.text{
                self.bodyTypeSelectedIndex.addObjects(from: [tempDetails.value(forKey: "_id") as Any])
            }
        }
    }
    
    //MARK : check all input validation
    func isValidationSuccess() -> Bool {
        var status:Bool = false
        if self.vehicleNameTF.isEmptyValue(){
            self.vehicleBorderLbl.backgroundColor = RED_COLOR
            self.vehicleNameTF.setAsInvalidTF("enter_vehiclename", in: self.view)
            self.vehicleNameTF.becomeFirstResponder()
        }else if self.noSeatsTF.isEmptyValue() {
            self.seatsBorderLbl.backgroundColor = RED_COLOR
            self.noSeatsTF.setAsInvalidTF("enter_seats", in: self.view)
            self.noSeatsTF.becomeFirstResponder()
        }else if self.bodyTypeTF.isEmptyValue(){
            Utility.shared.showAlert(msg: "choose_bodyType", status: "1")
        }else if self.amenitiesTF.isEmptyValue(){
            Utility.shared.showAlert(msg: "choose_amenities", status: "1")
        }else if self.vehicleNoTF.isEmptyValue() {
            self.vehicleNoBorderLbl.backgroundColor = RED_COLOR
            self.vehicleNoTF.setAsInvalidTF("enter_vehicleNo", in: self.view)
            self.vehicleNoTF.becomeFirstResponder()
        }else if self.licenceNoTF.isEmptyValue(){
            self.licenceBorderLbl.backgroundColor = RED_COLOR
            self.licenceNoTF.setAsInvalidTF("enter_licenceNo", in: self.view)
            self.licenceNoTF.becomeFirstResponder()
        }else if self.licenceDocTF.isEmptyValue(){
            Utility.shared.showAlert(msg: "upload_licenceDoc", status: "1")
        }else if self.licenceExpDateTF.isEmptyValue(){
            Utility.shared.showAlert(msg: "choose_licenceExpDate", status: "1")
        }else if self.insuranceNoTF.isEmptyValue(){
            self.insuranceNoBorderLbl.backgroundColor = RED_COLOR
            self.insuranceNoTF.setAsInvalidTF("enter_insuranceNo", in: self.view)
            self.insuranceNoTF.becomeFirstResponder()
        }else if self.insuranceDocTF.isEmptyValue(){
            Utility.shared.showAlert(msg: "upload_insuranceDoc", status: "1")
        }else if self.insuranceExpDateTF.isEmptyValue(){
            Utility.shared.showAlert(msg: "choose_insuranceExpDate", status: "1")
        }else if self.rcNoTF.isEmptyValue(){
            self.rcNoBorderLbl.backgroundColor = RED_COLOR
            self.rcNoTF.setAsInvalidTF("enter_rcNo", in: self.view)
            self.rcNoTF.becomeFirstResponder()
        }else if self.rcDocTF.isEmptyValue(){
            Utility.shared.showAlert(msg: "upload_rcDoc", status: "1")
        }else if self.rcExpDateTF.isEmptyValue(){
            Utility.shared.showAlert(msg: "choose_rcExpDate", status: "1")
        }else{
            status = true
            self.clearValidation()
        }
        return status
    }
    
    //MARK: Clear text field validation
    func clearValidation(){
        self.vehicleNameTF.setAsValidTF()
        self.vehicleNoTF.setAsValidTF()
        self.noSeatsTF.setAsValidTF()
        self.licenceNoTF.setAsValidTF()
        self.insuranceNoTF.setAsValidTF()
        self.rcNoTF.setAsValidTF()
        
        self.vehicleNoBorderLbl.backgroundColor = SEPARTOR_COLOR
        self.vehicleBorderLbl.backgroundColor = SEPARTOR_COLOR
        self.seatsBorderLbl.backgroundColor = SEPARTOR_COLOR
        self.licenceBorderLbl.backgroundColor = SEPARTOR_COLOR
        self.insuranceNoBorderLbl.backgroundColor = SEPARTOR_COLOR
        self.rcNoBorderLbl.backgroundColor = SEPARTOR_COLOR
    }
    
    func fileExtension(file:String) -> String {
        return NSURL(fileURLWithPath: file).pathExtension ?? ""
    }
   
}
