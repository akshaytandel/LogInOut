//
//  ViewController.swift
//  LogInOut
//
//  Created by Akshay Tandel on 27/03/23.
//

import UIKit
import Firebase
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    // database refence maked it
    var ref = DatabaseReference.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //database ref call
        self.ref = Database.database().reference()
        
        // user login stay after close app and logout click than
        if let loginFlag = userDafault.value(forKey: urLogin) as? Bool,
           loginFlag == true{
            
            // go to welcome home page  navigation
            let storybord = UIStoryboard(name: "Main", bundle: nil)
            let home = storybord.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            
            //display user name to next vc
            home.strname = userDafault.value(forKey: kUser) as? String
            
            // root push / pop
            UIApplication.shared.windows.first?.rootViewController = home
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
    // button
    @IBAction func btnLogin(_ sender: Any) {
        // textfield na text check kare 6 thi ocha ni cahel te
        if (txtEmail.text?.count ?? 0) < 6, (txtPassword.text?.count ?? 0) < 6 {
            // namel or password 6 thi ocha hoy to error nu alert box pop thayi
            let alertcntroler = UIAlertController(title: "Alert", message: "Enter Name & Password", preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: .default)
            alertcntroler.addAction(ok)
            self.present(alertcntroler, animated: true, completion: nil)
        }else{
            // name and password 6 thi vadhare hoy to aa func call thayi
            displayData() // read data  func call
        }
    }
    
    func displayData(){
        // fetch thaya name and password mate varible banavela
        var emailText = txtEmail.text
        var passwordText = txtPassword.text
        // fetch database data
        self.ref.child("User").queryOrderedByKey().observe(.value) { [self] snapshort in
            if let snapShort1 = snapshort.children.allObjects as? [DataSnapshot]{// array or disctionary assing to snapshort1
                var isMatch = false // user matched than jump to next screen per set false
                
                for snap in snapShort1{
                    
                    if let maindisk = snap.value as? [String :  AnyObject]{ //  this AnyObject can use to value int or string
                        let id = maindisk["Id"] as? Int
                        let name = maindisk["Name"] as? String
                        let password = maindisk["Password"] as? String
                        
                        if emailText == name && passwordText == password {
                            isMatch = true // match true thay to unser jayi
                            
                            // alert box pop
                            let alertcontroler = UIAlertController(title: "Sucessfully", message: "", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "ok", style: .default)
                            alertcontroler.addAction(ok)
                            self.present(alertcontroler, animated: true, completion: nil)
                            
                            //userdefault contan make & userdefault save data
                            userDafault.set(true, forKey: urLogin)
                            userDafault.set(name, forKey: kUser)
                            userDafault.set(id, forKey: kId)
                            userDafault.synchronize() // respons that time to run
                            
                            // navigato to next screen
                            let storybord = UIStoryboard(name: "Main", bundle: nil)
                            let home = storybord.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                            home.strname = self.txtEmail.text
                            
                            //rootvc push/pop
                            UIApplication.shared.windows.first?.rootViewController = home
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                            
                            break
                        }
                    }
                }
                // user not-matched than alert box pop [!isMatch varible is false ]
                if !isMatch{
                    let alertcontroler = UIAlertController(title: "Alert", message: "Incorect Name And Password",preferredStyle: .alert)
                    let ok = UIAlertAction(title: "ok", style: .default)
                    alertcontroler.addAction(ok)
                    self.present(alertcontroler, animated: true, completion: nil)
                }
            }
        }
    }
    
}

