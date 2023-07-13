//
//  SuccessPage.swift
//  HSTaxiDriverApp
//
//  Created by APPLE on 16/04/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class SuccessPage: UIViewController {
    @IBOutlet var successLbl: UILabel!
    @IBOutlet var detailLbl: UILabel!
    var amount = Double()
    
    @IBOutlet weak var tickMark: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpInitialDetails()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setUpInitialDetails()
        self.changeToRTL()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.successLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.detailLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.tickMark.transform = CGAffineTransform(scaleX: -1, y: 1)

        }
        else {
            self.view.transform = .identity
            self.successLbl.transform = .identity
            self.detailLbl.transform = .identity
            self.tickMark.transform = .identity
        }
    }
    //set up initial details
    func setUpInitialDetails()  {
        print("payment amount \(amount)")
        let collectedamount = String(format: "%.2f", Double(amount))
        print("payment amount1 \(collectedamount)")
        self.successLbl.config(color: TEXT_PRIMARY_COLOR, size: 25, align: .center, text: "success_complete")
        let detailsString = "\(Utility.shared.getLanguage()?.value(forKey: "have_you_collect") ?? EMPTY_STRING) \(collectedamount) \(Utility.shared.getLanguage()?.value(forKey: "for_this_ride") ?? EMPTY_STRING)"
        self.detailLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .center, text: EMPTY_STRING)
        self.detailLbl.text = detailsString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        Utility.shared.goToHomePage()
    }
    
}
