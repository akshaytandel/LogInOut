//
//  Utils.swift
//  LogInOut
//
//  Created by Akshay Tandel on 19/05/23.
//

import Foundation
import UIKit
//loader created and loader start thayi
func loaderStart() -> UIAlertController{
    
    let alert = UIAlertController(title: nil, message: "plz wait..", preferredStyle: .alert)
    let lodingIndicator =  UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    lodingIndicator.hidesWhenStopped = true
    lodingIndicator.style = UIActivityIndicatorView.Style.large
    lodingIndicator.startAnimating()
    lodingIndicator.color = .red
    //alert.addAction(lodingIndicator)
    alert.view.addSubview(lodingIndicator)
    DispatchQueue.main.async {
        if let vc =  UIApplication.shared.windows.first?.rootViewController{
            runOnMainThread { //main thared  ma mukyu
                vc.present(alert, animated: true, completion: nil)
            }
        }
        else {
            print("loader error")
        }
    }
    return alert
}
//loader stop func
func loaderStop(loaderStart : UIAlertController){
    DispatchQueue.main.async {
        runOnMainThread { // mai thared per mukyu
            loaderStart.dismiss(animated: true, completion: nil)
        }
    }
}
