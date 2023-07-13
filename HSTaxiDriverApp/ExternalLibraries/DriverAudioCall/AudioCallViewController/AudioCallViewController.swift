//
//  AudioCallViewController.swift
//  HSTaxiUserApp
//  Created by Hitasoft on 11/12/20.
//  Copyright © 2020 APPLE. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
import SwiftyJSON
import CallKit


class AudioCallViewController: ARDVideoCallViewController {

    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var callEndButton: UIButton!
    @IBOutlet weak var cameraSpeakerButton: UIButton!
    @IBOutlet weak var endCallButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var receiverImageView: UIImageView!
    @IBOutlet weak var userImageview: UIImageView!
    @IBOutlet weak var propertiesView: UIView!

    var call_type : String!
    var random_id :String!
    var receiverId : String!
    var senderFlag: Bool!
    var previewAdded: Bool!
    var hideEnabled = Bool()
//    var chatData: Match?
    var room_id :String!
    var viewType :String!
    var av_Player : AVAudioPlayer!
    var poorConnection : Bool = false
    var timerStart : Bool = false
    var countTimer = Timer()
    var startTime = 0
    var muteFlag : Bool = false
    var call_status :String!
    var speakerMode : Bool!
    var blockedMe = false
//    var localCallDB = CallStorage()
    var captureSession = AVCaptureSession()
    var previewLayer:CALayer!
    var captureDevice:AVCaptureDevice!
    var platform = String()
//    var viewModel = CallViewModel()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let rideObj = RideServices()
    var callNotifyDict: JSON!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customUI()
        self.configWebRTC()
        self.initialSetup()
        self.appDelegate.isAlreadyInCall = true
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        av_Player.stop()
        isCallkitEnabled = true
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(automaticallyDisConnectCall), object: nil)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(makeRinging), object: nil)

        UIApplication.shared.isIdleTimerDisabled = false
    }
    func customUI() {
        self.cameraSpeakerButton.backgroundColor = TRASPARENT_WHITE_COLOR
        self.muteButton.backgroundColor = TRASPARENT_WHITE_COLOR

        self.receiverImageView.cornerViewRadius()
        self.callButton.cornerViewRadius()
        self.muteButton.cornerViewRadius()
        self.endCallButton.cornerViewRadius()
        self.callEndButton.cornerViewRadius()
        self.cameraSpeakerButton.cornerViewRadius()
        self.callButton.backgroundColor = CALL_ACCEPT_COLOR
        self.endCallButton.backgroundColor = CALL_DECLINE_COLOR
        self.callEndButton.backgroundColor = CALL_DECLINE_COLOR
        self.userNameLabel.config(color: .white, size: 16, align: .center, text: "")
        self.statusLabel.config(color: .white, size: 14, align: .center, text: "")
        self.timerLabel.config(color: TEXT_PRIMARY_COLOR, size: 14, align: .center, text: "")
    }
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    func initialSetup() {

        hideEnabled = false
        call_status = "waiting"
        self.delegate = self
        
        self.userNameLabel.text = self.callNotifyDict["user_name"].stringValue
        self.userImageview.image = nil
//        if (UserModel.shared.getProfilePic() as String? ?? "") != ""{
//            self.userImageview.sd_setImage(with: URL(string: (UserModel.shared.getProfilePic() as String? ?? "")), placeholderImage: #imageLiteral(resourceName: "temp_1024"))
//        }else{
//            self.userImageview.image = #imageLiteral(resourceName: "temp_1024")
//        }
        self.receiverImageView.sd_setImage(with: URL(string: self.callNotifyDict["user_image"].stringValue), placeholderImage: #imageLiteral(resourceName: "temp_1024"))
        self.performSelector(inBackground: #selector(self.makeRinging), with: nil)

        if(senderFlag){
            let del = UIApplication.shared.delegate as! AppDelegate
            del.callKitPopup = true
            room_id = Utility.shared.random()
            self.join(toCall: room_id, platform: platform, call_type: call_type)
//            self.enableCallKit()
            self.makeCallToReceiver()
        }else{
            if self.viewType == "2" {
                self.join(toCall: room_id, platform: platform, call_type: call_type)
            }
       }
        //call ui changes method
        self.setUIDesigns()
    }
    func enableCallKit() {
        self.appDelegate.baseUUId = UUID()
        let update = CXCallUpdate()
        let username = self.userNameLabel.text!
        update.remoteHandle = CXHandle(type: .generic, value: username)
        update.hasVideo = false
        self.appDelegate.provider.configuration.maximumCallsPerCallGroup = 1
        self.appDelegate.provider.reportNewIncomingCall(with: self.appDelegate.baseUUId, update: update, completion: { error in })
        self.appDelegate.callKitPopup = true
    }
    func setUIDesigns() {
        //sender receiver based ui changes
        self.callEndButton.isHidden = true
        if senderFlag {
            self.callButton.isHidden = true
            self.cameraSpeakerButton.isHidden = false
            self.muteButton.isHidden = false
        }else{
            if viewType == "2" {
                self.callButton.isHidden = true
                self.cameraSpeakerButton.isHidden = false
                self.muteButton.isHidden = false
            }else{
                self.callButton.isHidden = false
                self.cameraSpeakerButton.isHidden = true
                self.muteButton.isHidden = true
            }
        }
        //Audio Call ui changes
        self.cameraSpeakerButton.tintColor = WHITE_COLOR
//        self.cameraSpeakerButton.setImage(#imageLiteral(resourceName: "speaker"), for: .normal)
        self.speakerMode = false
        self.speakerOff()
        self.statusLabel.text = Utility.shared.getLanguage()?.value(forKey: "audio_calling") as? String ?? ""

        if viewType == "2" {
            self.statusLabel.text = "Connecting...."
        }
        self.view.bringSubview(toFront: self.propertiesView)
    }

    @objc func makeRinging(){
        var audioName = String()
        var audioType = String()
        
        if senderFlag{
            audioName = "sound2"
            audioType = "caf"
        }else{
            audioName = "RingTone"
            audioType = "mp3"
        }
        
        let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: audioName, ofType: audioType)!)
        let session = AVAudioSession.sharedInstance()
        
        var availbleInput = NSArray()
        availbleInput = AVAudioSession.sharedInstance().availableInputs! as NSArray
        var port = AVAudioSessionPortDescription()
        port = availbleInput.object(at: 0) as! AVAudioSessionPortDescription
        
        var _: Error?
        try? session.setPreferredInput(port)
        
        try? session.setCategory(AVAudioSessionCategoryPlayAndRecord, mode: AVAudioSessionModeDefault, options: [])
        if viewType == "1" {
            try? session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            speakerMode = true
            self.speakerOn()
        } else {
            try? session.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
        }
        try? session.setActive(true)
        try! av_Player = AVAudioPlayer(contentsOf: alertSound)
        av_Player!.prepareToPlay()
        av_Player.numberOfLoops = -1
        av_Player!.play()
    }
    func makeCallToReceiver()  {
        self.rideObj.makeCall(sender_id: (UserModel.shared.userID() as String? ?? ""), receiver_id: self.receiverId, room_id: self.room_id) { (response) in
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
            }
            else {
            }
        }
        self.perform(#selector(automaticallyDisConnectCall), with: nil, afterDelay: 30.0)
        
    }
    @objc func automaticallyDisConnectCall(){
        if (call_status == "waiting"){
            rideObj.endCall(sender_id: (UserModel.shared.userID() as String? ?? ""), receiver_id: self.receiverId, room_id: self.room_id) { (result) in
            }
//            SocketIOManager.sharedInstance.endCall(self.room_id)
            self.missCallAlert()
            self.disconnectCall()
        }
    }

    func missCallAlert() {
        if senderFlag {
            if call_status == "waiting" {
//                self.viewModel.missedCall(fromId: UserModel.shared.userID(), toId: self.receiverId, token: (self.userData?.token ?? ""), chatId: "\(self.chatData?.chatId ?? 0)", type: self.call_type, room_id: self.room_id, onSuccess: { (sucess) in
//
//                }) { (failure) in
//                }
            }
        }
    }
    @IBAction func cameraSpeakerButtonAct(_ sender: UIButton) {
        self.cameraSpeakerButton.setImage(#imageLiteral(resourceName: "speaker"), for: .normal)
        if speakerMode {
            speakerMode = false
            self.cameraSpeakerButton.backgroundColor = TRASPARENT_WHITE_COLOR
            self.cameraSpeakerButton.tintColor = WHITE_COLOR
            self.speakerOff()
        }
        else {
            speakerMode = true
            cameraSpeakerButton.backgroundColor = WHITE_COLOR
            self.cameraSpeakerButton.tintColor = LINE_COLOR
            self.speakerOn()
        }
    }
    @IBAction func endCallButtonAct(_ sender: UIButton) {
        rideObj.endCall(sender_id: (UserModel.shared.userID() as String? ?? ""), receiver_id: self.receiverId, room_id: self.room_id) { (result) in
        }
        self.missCallAlert()
//        SocketIOManager.sharedInstance.endCall(self.room_id)
        self.disconnectCall()
    }
    
    @IBAction func muteButtonAct(_ sender: UIButton) {
        if muteFlag {
            muteFlag = false
            muteButton.backgroundColor = TRASPARENT_WHITE_COLOR
            self.muteButton.tintColor = WHITE_COLOR
            self.muteOn()
        }
        else{
            muteFlag = true
            muteButton.backgroundColor = LINE_COLOR
            self.muteButton.tintColor = TRASPARENT_WHITE_COLOR
            self.muteOff()
        }
    }
    @IBAction func callAttendButtonAct(_ sender: UIButton) {
        self.viewType = "2"
        self.initialSetup()
        
    }
    //set timer count
    @objc func updateTimer()  {
        self.startTime += 1
        DispatchQueue.main.async {
            if !self.poorConnection{
                self.statusLabel.text = self.timeString(time: TimeInterval(self.startTime))
            }
        }
    }
    func timeString(time:TimeInterval)-> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AudioCallViewController: ARDVideoCallViewControllerDelegate {
//    func getSocketInfo(dict: JSON, type: String) {
//        self.appDelegate.isAlreadyInCall = false
//        self.dismiss(animated: false, completion: nil)
//    }
    
   
    //apprtc state delegate
    func streamDetails(_ state: Int) {
        // Print("ICE STATE \(state)")
        if state == 2 { // CONNECTED STATE
            
            call_status = "connected"
            av_Player.stop()
            self.statusLabel.textColor = .white
            self.poorConnection = false
            self.updateTimer()
            if !self.timerStart{
                self.countTimer = Timer.scheduledTimer(timeInterval: 1.0, target:self,selector:#selector(self.updateTimer), userInfo: nil, repeats: true)
                self.timerStart = true
            }
        }else if state == 4{
            self.poorConnection = false
        }else if state == 5{ // SLOW CONNECTION
            self.poorConnection = true
            self.statusLabel.textColor = .black
            self.statusLabel.isHidden = false
            self.statusLabel.text = "Poor Network! Connecting..."
        }else if state == 6{ // DISCONNECTED STATE
            UIApplication.shared.keyWindow?.rootViewController?.view.hideToast()
            if call_status == "connected" {
                call_status = "disconnected"
                self.disconnectCall()
            }
            else {
                call_status = "disconnected"
                self.disconnectMissedCall()
            }
        }
    }
    //handle
    @objc func hideProperties(sender: UITapGestureRecognizer? = nil) {
        // handling code
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            if self.hideEnabled {
                self.hideEnabled = false
                self.propertiesView.frame.origin.y = 0
            }else{
                self.hideEnabled = true
                self.propertiesView.frame.origin.y = 200
            }
        }, completion: nil)
    }
    func disconnectCall() {
        self.countTimer.invalidate()
//        SocketIOManager.sharedInstance.disconnect()
        av_Player.stop()
        if !senderFlag {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.endCall()
        }else{
            let del = UIApplication.shared.delegate as! AppDelegate
            del.callKitPopup = false
        }
        self.hangup()
        self.appDelegate.isAlreadyInCall = false
        self.dismiss(animated: false, completion: nil)
        UIApplication.shared.keyWindow?.rootViewController?.view.makeToast(Utility.shared.getLanguage()?.value(forKey: "call_end") as? String ?? "", align: "")

    }
    func disconnectMissedCall() {
        self.countTimer.invalidate()
        av_Player.stop()
        if !senderFlag {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.endCall()
        }else{
            let del = UIApplication.shared.delegate as! AppDelegate
            del.callKitPopup = false
        }
        self.hangup()
        self.appDelegate.isAlreadyInCall = false
        self.dismiss(animated: false, completion: nil)
        UIApplication.shared.keyWindow?.rootViewController?.view.makeToast(Utility.shared.getLanguage()?.value(forKey: "call_decline") as? String ?? "", align: "")
        
        //missed call view
        if (call_status == "waiting" && !senderFlag){
            let callerId = receiverId as String
            let time = NSDate().timeIntervalSince1970
//            self.localCallDB.addNewCall(call_id: random_id, contact_id: callerId, status: "missed", call_type: call_type, timestamp: "\(time.rounded().clean)", unread_count: "1")
        }
        
    }
}
