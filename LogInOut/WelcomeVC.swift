//
//  WelcomeVC.swift
//  LogInOut
//
//  Created by Akshay Tandel on 27/03/23.
//

import UIKit
import Firebase
import CoreLocation
import MapKit

// enum class banavelu
enum User{
    //enum property acess in switch case
    case none,
         checkIn,
         checkOut,
         breakStart,
         breakEnd
}

class WelcomeVC: UIViewController {
    
    var locationMng = CLLocationManager() // user locatin varible
    // location variable create & assin latutude and logititude value
    var lat = 0.0
    var long = 0.0
    // timer variable decler
    var timer = Timer()
    var count = 0
    var userCase = User.none// enum class varible created to acess enum property
    
    var loader = loaderStart() // loader start func assin to varible
    
    @IBOutlet weak var map: MKMapView! // location map view
    
    @IBOutlet weak var lblShow: UILabel!
    
    @IBOutlet weak var lblChechIn: UILabel!
    @IBOutlet weak var lblBreakStart: UILabel!
    @IBOutlet weak var lblBreakEnd: UILabel!
    @IBOutlet weak var lblCheckOut: UILabel!
    
    @IBOutlet weak var btnCheckIn: UIButton!
    @IBOutlet weak var btnBreakStart: UIButton!
    
    @IBOutlet weak var lblTotalTime: UILabel!
    
    var ref1 = DatabaseReference.init()// database create varible
    
    //show per-vc name in lbl
    var strname: String! = ""
    
    //current time and date varible
    var curDate = ""
    //var curTime = ""
    var curId = Int()
    // current time
    let format = DateFormatter()
    
    var checkInFlag = true // btn ni click properti access karva & set true default
    var breakFlag = true //  btn ni click properti access karva & set true default
    
    //location  two varible created
    var locationFor = ""
    var isFunctionCalled = false
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        
        // database ref
        self.ref1 = Database.database().reference()
        
        //Current Time
        format.timeStyle = .short
        format.dateStyle = .none
        format.dateFormat = "HH:mm"
        let time = format.string(from: Date())
        
        //Current Date
        format.dateFormat = "dd/MM/yyyy"
        let date = format.string(from: Date())
        self.curDate = date
        
        //show per-vc name in lbl
        lblShow.text = strname
        
        //current time
        format.timeStyle = .short
        format.dateStyle = .none
        format.string(from: Date())
        
        self.readTodaysDataCheckInOut()// read data & fetch data func call
        
        // Do any additional setup after loading the view.
    }
    // fun 1 complited than call func 2 start
    func delete() {
        defer {
            print("Leaving scope, time to cleanup!")
        }
        print("Performing some operation...")
    }
    // timer show after runn app
    @objc func updateTimer(){
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(timer1Action), userInfo: nil, repeats: true)
    }
    @objc func timer1Action(){
        count += 1
        self.lblTotalTime.text = self.timeFormatted(self.count) // will show timer in lbl
    }
    func timeFormatted(_ totalMinits: Int) -> String {
        let minutes = totalMinits   % 60
        let hours  = Int(totalMinits / 60)
        
        return String(format: "%02d : %02d", hours,minutes)//seconds)
    }
    
    func start(){
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(timer1Action), userInfo: nil, repeats: true)
    }
    func resume(){
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(timer1Action), userInfo: nil, repeats: true)
    }
    func stop(){
        if timer != nil{
            timer.invalidate()
        }
    }
    
    // insert data in ckeck-in time
    func getDataCheckIn(){
        
        //Current Time
        format.timeStyle = .short
        format.dateStyle = .none
        format.dateFormat = "HH:mm"
        let time = format.string(from: Date())
        
        //Id
        let Currentid = userDafault.value(forKey: kId) as! Int
        self.curId = Currentid
        
        // insert in database
        let UserCheckIn = ref1.child("/CheckIn")
        let dict : [String : Any] = ["Date" : curDate, "Id" : Currentid, "Latitude" : lat, "Longitude": long, "Status" : "IN" , "Time" : time ]
        UserCheckIn.childByAutoId().setValue(dict){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
            } else {
                self.lblChechIn.text = time
            }
        }
    }
    
    // insert data in ckeck-in time
    func getDataCheckOut(){
        //Current Time
        format.timeStyle = .short
        format.dateStyle = .none
        format.dateFormat = "HH:mm"
        let time = format.string(from: Date())
        
        //Id
        let currentId = userDafault.value(forKey: kId) as! Int
        self.curId = currentId
        
        // insert in database
        let userCheckOut = ref1.child("/CheckIn")
        let dict : [String : Any] = ["Date" : curDate, "Id" : currentId, "Latitude" : lat, "Longitude": long, "Status" : "OUT", "Time" : time ]
        
        userCheckOut.childByAutoId().setValue(dict){
            (error: Error?, ref:DatabaseReference) in
            if let error = error{
            }else{
                self.lblCheckOut.text = time
            }
        }
    }
    
    // insert data in break start time
    func getDataBreakStart(){
        
        //Current Time
        format.timeStyle = .short
        format.dateStyle = .none
        format.dateFormat = "HH:mm"
        //format.string(from: mytime)
        let BreakStartTime = format.string(from: Date())
        
        //Id
        let Currentid = userDafault.value(forKey: kId) as! Int
        
        self.curId = Currentid
        
        // insert in database
        let UserBreakStart = ref1.child("/BreakStart")
        let dict : [String : Any] = [ "Date" : curDate, "Id" : Currentid,"Latitude": lat, "Longitude": long ,"Status" : "START", "Time" : BreakStartTime ]
        UserBreakStart.childByAutoId().setValue(dict){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
            } else {
                self.lblBreakStart.text = BreakStartTime
            }
        }
    }
    
    // insert data in break end time
    func getDataBreakEnd(){
        
        //Current Time
        format.timeStyle = .short
        format.dateStyle = .none
        format.dateFormat = "HH:mm"
        //format.string(from: mytime)
        let BreakEndTime = format.string(from: Date())
        
        //Id
        let Currentid = userDafault.value(forKey: kId) as! Int
        self.curId = Currentid
        
        // insert in database
        let UserBreakEnd = ref1.child("/BreakStart")
        let dict : [String : Any] = [ "Date" : curDate, "Id" : Currentid,"Latitude" : lat, "Longitude" : long, "Status" : "END", "Time" : BreakEndTime ]
        UserBreakEnd.childByAutoId().setValue(dict){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                //print("Data could not be saved: \(error).")
            } else {
                self.lblBreakEnd.text = BreakEndTime
                // print("Data saved BreakEndTime successfully!", BreakEndTime)
            }
        }
    }
    
    // read data or fetch data  perticuler 1 filed in database
    func readTodaysDataCheckInOut(){
        // current date data fetch
        
        //var userCase = User.none// enum class varible created
        //runOnMainThread {
        
        //var lod = loaderStart() // loader start func call
        loader // loader start func call
        // print("first loader start")
        // }
        let ref = ref1.child("CheckIn").queryOrdered(byChild: "Date").queryEqual(toValue: curDate)
        ref.observe(DataEventType.value, with: { [self] snapshot  in
            
            loaderStop(loaderStart: loader) // loader stop func call
            if let id = userDafault.value(forKey: kId) as? Int { // userdefaul id assin it to  created varible
                self.curId = id // userdefault id assin to globalvarible
                
                if snapshot.value != nil{
                    var ischeckoutflag = false // chechout mate varible decler
                    for snap in snapshot.children.allObjects as! [DataSnapshot] {
                        if let disk = snap.value as? [String: AnyObject]{
                            // database store data fetch
                            let Date1 = disk["Date"] as? String
                            let Id1 = disk["Id"] as? Int
                            let Time1 = disk["Time"] as? String
                            let status1 = disk["Status"] as? String
                            
                            if Id1 == self.curId{ // comper database id and userdefault id
                                // enum class check satus than excute
                                
                                if status1 == "IN"{
                                    
                                    userCase = .checkIn // enum class varible use and call checkin property
                                    self.btnCheckIn.setTitle("Check Out", for: UIControl.State.normal)// btn text change
                                    self.lblChechIn.text = Time1 // database fetch time display in lbl
                                    checkInFlag = false // btn click property access karva false set
                                    
                                } else if  status1 == "OUT"{
                                    ischeckoutflag = true // swich case ma checkout case call karva mate aa varible set true
                                    userCase = .checkOut // enum class varible use and call checkout property
                                    self.btnCheckIn.setTitle("Check in", for: .normal)// btn text change
                                    self.lblCheckOut.text = Time1 // database fetch time display in lbl
                                    checkInFlag = true // btn click property access karva true set
                                }
                            }
                        }
                    }
                    
                    // different between two time and display
                    let date3 = Date()
                    let checkInTime = self.lblChechIn.text ?? "00:00" // date ne default opetional value api "00:00"//self.storTime// checkin time
                    let breakStatTime = self.lblBreakStart.text ?? "00:00"
                    let breakEndTime = self.lblBreakEnd.text ?? "00:00"
                    let checkOutTime = self.lblCheckOut.text ?? "00:00"
                    
                    let formatter = DateFormatter()
                    formatter.timeStyle = .short
                    formatter.dateFormat = "dd/MM/yyyy HH:mm "
                    // value ne date ma convert thayi
                    let checkInDate = formatter.date(from: "\(self.curDate) \(checkInTime)") ?? (date3)// opetionl value ne remove kari
                    let breakStartDate = formatter.date(from: "\(self.curDate) \(breakStatTime)") ?? (date3)
                    let breakEndDate = formatter.date(from: "\(self.curDate) \(breakEndTime)") ?? (date3)
                    let checkOutDate = formatter.date(from: "\(self.curDate) \(checkOutTime)") ?? (date3)
                    
                    // func break start and end started
                    // func break strat and end database fetch
                    // database fetch data
                    
                    //let loader =  loaderStart() // loader start
                    loader // loader fun call
                    let ref = ref1.child("BreakStart").queryOrdered(byChild: "Date").queryEqual(toValue: curDate)
                    ref.observe(DataEventType.value, with: { snapshot  in
                        runOnMainThread { // main thared ma mukyu
                            loaderStop(loaderStart: self.loader) // loader stop func call
                        }
                        for snap1 in snapshot.children.allObjects as! [DataSnapshot]{
                            if let disk1 = snap1.value as? [String: AnyObject]{
                                
                                //database store data fetch
                                let Date2 = disk1["Date"] as? String
                                let id2 = disk1["Id"] as? Int
                                let status2 = disk1["Status"] as? String
                                let time2 = disk1["Time"] as! String
                                
                                if id2 == self.curId{ // comper database id and userdefault id
                                    
                                    if status2 == "START"{ // check status fetch and compare
                                        
                                        self.userCase = .breakStart // enum class varible use and call breakstart property
                                        self.btnBreakStart.setTitle("Break End", for: UIControl.State.normal)
                                        self.lblBreakStart.text = time2 // database fetch time display in lbl
                                        self.breakFlag = false // btn click property access karva false set
                                        
                                    }else if status2 == "END"{ // check status fetch and compare
                                        
                                        self.userCase = .breakEnd // enum class varible use and call breakend property
                                        self.btnBreakStart.setTitle("Break Start", for: .normal)
                                        self.lblBreakEnd.text = time2 // database fetch time display in lbl
                                        self.breakFlag = true // btn click property access karva true set
                                    }
                                }
                            }
                        }
                        
                        // different between two time and display
                        let breakDate = Date()
                        let checkinTime = self.lblChechIn.text ?? "00:00"//self.storTime
                        let breakStartTime = self.lblBreakStart.text ?? "00:00"//time2
                        let breakEndTime = self.lblBreakEnd.text ?? "00:00" // time2
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd/MM/yyyy HH:mm"
                        
                        let checkinDate = formatter.date(from: "\(self.curDate) \(checkinTime)") ?? (breakDate)// checkIn time convert to date
                        let breakStartDate = formatter.date(from: "\(self.curDate) \(breakStartTime)") ?? (breakDate)// BreakStart time convert to date
                        let breakEndDate = formatter.date(from: "\(self.curDate) \(breakEndTime)") ?? (breakDate)// BreakEnd time convert to date
                        
                        if ischeckoutflag{    // break pehla exit thayi atle checkout call mate varible true karavyu globly
                            self.userCase = .checkOut
                        }
                        
                        var totalMinit = 0 // count ni value assin karva mate varible banavyo
                        
                        //switch case use enum class and call it
                        switch self.userCase {
                        case .checkIn :
                            
                            let diffCom1 = Calendar.current.dateComponents([.minute], from: checkInDate, to: date3)
                            totalMinit = diffCom1.minute ?? 0
                            print("User CheckIn")
                            self.start()
                            
                        case .checkOut:
                            
                            let differnt = Calendar.current.dateComponents([.minute], from: breakEndDate, to: checkOutDate)
                            let checkoutBreakEnd = differnt.minute ?? 0
                            
                            let differnt1 = Calendar.current.dateComponents([.minute], from: checkInDate, to: breakStartDate)
                            let breakStartCheckIn = differnt1.minute ?? 0
                            
                            totalMinit = checkoutBreakEnd + breakStartCheckIn
                            
                            print("User CheckOut")
                            self.stop()
                            
                        case .breakStart:
                            
                            let diffComponents1 = Calendar.current.dateComponents([.minute], from: checkinDate, to:  breakStartDate)
                            totalMinit = diffComponents1.minute ?? 0
                            print("User Break Start")
                            self.stop()
                            
                        case .breakEnd:
                            
                            let difference = Calendar.current.dateComponents([.minute], from: breakEndDate, to: breakDate)
                            let breakEnd = difference.minute ?? 0
                            print("User Break End breakEnd",  breakEnd)
                            
                            
                            let diffComponents1 = Calendar.current.dateComponents([.minute], from: checkinDate, to:  breakStartDate)
                            let checkinBreakstart = diffComponents1.minute ?? 0
                            
                            totalMinit = breakEnd + checkinBreakstart
                            print("User Break End")
                            self.resume()
                            
                        default:
                            print("User Not ChechIn")
                        }
                        self.count = totalMinit // value assine
                        var min = 0
                        var hour = 0
                        if totalMinit >= 60{ // 60 minit thi uper jayi to aa ma jase
                            min = totalMinit % 60
                            hour = Int(totalMinit / 60)
                        }else{ // 60 minit ni niche jayi to aa ma jase
                            min = totalMinit
                        }
                        // calculate time display in
                        self.lblTotalTime.text = "\(String(format: "%02d", hour)) : \(String(format: "%02d", min))" // time to print format "01:05"
                    })
                }
            }
        })
    }
    
    @IBAction func btnCheckInOut(_ sender: Any) {
        // location func call in btn
        locationFor = "checkinout"
        locationPopBoxAllow() // locton func
    }
    
    func checkLoginStatus(){
        if checkInFlag{ // access varible check true or false
            getDataCheckIn() // insert data funs call
            self.btnCheckIn.setTitle("Check Out", for: UIControl.State.normal)// btn text chnage
            checkInFlag = false // btn property access set false
            start() // timer func call
        }else{
            getDataCheckOut()// insert data funs call
            self.btnCheckIn.setTitle("Check In", for: UIControl.State.normal)// btn text change
            checkInFlag = true // btn property access set false
            stop() // timer func call
        }
    }
    
    @IBAction func btnBreakStartEnd(_ sender: Any) {
        // loaction func call in btn
        locationFor = "break"
        locationPopBoxAllow() // location func call
    }
    
    func checkBreakStatus(){
        if breakFlag { //access varible check true or false
            getDataBreakStart() //insert data funs call
            self.btnBreakStart.setTitle("Break End", for: UIControl.State.normal) // btn text change
            breakFlag = false // btn property access set false
            stop() // timer func call
        }else{
            getDataBreakEnd() //insert data funs call
            self.btnBreakStart.setTitle("Break Start", for: UIControl.State.normal) // btn text change
            breakFlag = true // btn property access set true
            resume() // timer func call
        }
    }
    
    // logout set click to go main login page
    @IBAction func btnLogout(_ sender: Any) {
        
        userDafault.removeObject(forKey: urLogin)
        userDafault.synchronize()
        let storybord = UIStoryboard(name: "Main", bundle: nil)
        let login = storybord.instantiateViewController(withIdentifier: "userLogin")
        
        UIApplication.shared.windows.first?.rootViewController = login
    }
}

//MARK: Location
extension WelcomeVC: CLLocationManagerDelegate{ // loaction ni deleget method banavi
    
    func locationPopBoxAllow(){
        isFunctionCalled = false // loction mate varible set false
        locationMng.requestAlwaysAuthorization() //Ask for Authorisation from the User.
        locationMng.delegate = self // delegate mrthid call
        DispatchQueue.global().async {
            let authStatus = self.locationMng.authorizationStatus
            if (CLLocationManager.locationServicesEnabled()), authStatus != .authorizedAlways || authStatus != .authorizedWhenInUse {
                self.locationMng.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationMng.startUpdatingLocation()
            }else{
                //TODO: show message to user that user must give permission for location to do checkin, checkout, break start, break end
                //enter in  pop alert box show
                print(" akshay show message to user that user must give permission for location to do checkin, checkout, break start, break end")
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authStatus = manager.authorizationStatus
        if (CLLocationManager.locationServicesEnabled()), authStatus == .authorizedAlways || authStatus == .authorizedWhenInUse {
            self.locationMng.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationMng.startUpdatingLocation()
            
        }else{
            //TODO: show message to user that user must give permission for location to do checkin, checkout, break start, break end
            // main thared
            runOnMainThread { // main thared ma mukyu
                // alert box pop
                let alertMsg = UIAlertController(title: "Location Permission Required", message: "Please Enable Location Permissions In Settings.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .default)
                alertMsg.addAction(ok)
                self.present(alertMsg, animated: true, completion: nil)
            }
            print(" tandel show message to user that user must give permission for location to do checkin, checkout, break start, break end")
        }
    }
    
    func  locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //userRequestLocation()
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return}
        locationMng.stopUpdatingLocation()
        // varible assin latitude and logitude value
        lat = locValue.latitude
        long = locValue.longitude
        if isFunctionCalled { // varible totrue ke false  check kri under jayi
            print("already called")
        }else{ // varible false hoy tyare aa ma jayi
            isFunctionCalled = true
            if locationFor == "break" { // location check kare break hoy to jayi
                checkBreakStatus() // break status func call thayi
            }else if locationFor == "checkinout"{ // location check kare checkinout hoy to jayi
                checkLoginStatus() // checkin status fun call thayi
            }
        }
    }
}
