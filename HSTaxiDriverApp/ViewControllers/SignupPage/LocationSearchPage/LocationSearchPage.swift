//
//  LocationSearchPage.swift
//  HSTaxiDriverApp
//
//  Created by APPLE on 27/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

protocol locationPickerDelegate {
    func selectedLocation(location_name:String,lat:String, lon:String)
}

class LocationSearchPage: UIViewController,CLLocationManagerDelegate,UITextFieldDelegate {

    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var locationTableVeiw: UITableView!
    @IBOutlet var searchTF: UITextField!
    var locationManager = CLLocationManager()
    var locationArray = NSMutableArray()
    var fetcher: GMSAutocompleteFetcher?
    var delegate:locationPickerDelegate?
    var clearView = UIView()
    var selectedLocation = String()
    var session_token = GMSAutocompleteSessionToken()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpInitialDetails()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.changeToRTL()
        self.locationTableVeiw.reloadData()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.searchTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.searchTF.textAlignment = .right
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.textAlignment = .right
        }
        else {
            self.view.transform = .identity
            self.searchTF.transform = .identity
            self.searchTF.textAlignment = .left
            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setUpInitialDetails()  {
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.navigationView.elevationEffect()
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text:"location")
    //register custom cell to tableview
        locationTableVeiw.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        //config search TF
        self.searchTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "search_location")
        self.clearView.frame = CGRect.init(x: 0, y: 0, width: 15, height: 15)
        let clearImgView = UIImageView()
        clearImgView.frame = CGRect.init(x: 0, y: 0, width: 15, height: 15)
        clearImgView.image = #imageLiteral(resourceName: "close_icon")
        clearImgView.contentMode = .scaleAspectFill
        self.clearView.addSubview(clearImgView)

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.clearSearchTF(_:)))
        self.clearView.addGestureRecognizer(tap)
        
        self.searchTF.rightView = self.clearView
        self.searchTF.rightViewMode = .whileEditing

    }
    @objc func clearSearchTF(_ sender: UITapGestureRecognizer) {
        self.searchTF.text = EMPTY_STRING
        self.searchTF.becomeFirstResponder()
    }

    @IBAction func closeBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    //MARK: Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        //set filter bounds to fetch near by location as first
        let location = locations.last
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        let mylocation = CLLocationCoordinate2D.init(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let bounds = GMSCoordinateBounds.init(coordinate: mylocation, coordinate: mylocation)
        fetcher = GMSAutocompleteFetcher.init(bounds:bounds , filter:filter)
        fetcher?.delegate = self
        session_token = GMSAutocompleteSessionToken.init()
        fetcher?.provide(session_token)
        self.searchTF.text = selectedLocation
        fetcher?.sourceTextHasChanged(selectedLocation)
        self.searchTF.becomeFirstResponder()

    }
    //MARK: location manager authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
            self.locationPermissionAlert()
        case .denied:
            print("User denied access to location.")
            self.locationPermissionAlert()
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    //MARK:location restriction alert
    func locationPermissionAlert()  {
        AJAlertController.initialization().showAlert(aStrMessage: "location_permission", aCancelBtnTitle: "cancel", aOtherBtnTitle: "settings", status: "", completion: { (index, title) in
            print(index,title)
            if index == 1{
                //open settings page
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
    }
    //MARK: TextField delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let location = textField.text!+string
        if location.count > 2 {
            fetcher?.sourceTextHasChanged(textField.text!+string)
        }
        return true
    }

}

//MARK: Location auto complete fetcher
extension LocationSearchPage: GMSAutocompleteFetcherDelegate,UITableViewDelegate,UITableViewDataSource {
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        self.locationArray.removeAllObjects()
        for prediction in predictions{
            let mutableDict = NSMutableDictionary()
            mutableDict.setValue(prediction.attributedPrimaryText.string, forKey: "address_first")
            mutableDict.setValue(prediction.attributedSecondaryText?.string, forKey: "address_second")
            mutableDict.setValue(prediction.attributedFullText.string, forKey: "address_full")
            self.locationArray.addObjects(from: [mutableDict])
        }
        self.locationTableVeiw.reloadData()
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        print(error.localizedDescription)
    }
    
    //MARK: Table view delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationArray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let locationObj = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
            let locationDict:NSDictionary =  self.locationArray.object(at: indexPath.row) as! NSDictionary
            locationObj.configCell(locationDict: locationDict)
        return locationObj
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        let locationDict:NSDictionary =  self.locationArray.object(at: indexPath.row) as! NSDictionary
        self.searchTF.text = Utility.shared.getLanguage()?.value(forKey: "loading") as? String
        self.getLocationDetails(address: locationDict.value(forKey: "address_full") as! String, primary_text:(locationDict.value(forKey: "address_first") as? String)! )
    }
    
    func getLocationDetails(address:String,primary_text:String)  {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error as Any)
            }
            if let placemark = placemarks?.first {
                self.searchTF.text = primary_text
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                print("lat \(coordinates.latitude) long\(coordinates.longitude)")
                self.delegate?.selectedLocation(location_name: primary_text, lat: "\(coordinates.latitude)", lon: "\(coordinates.longitude)")
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
}

