//
//  Extensions.swift
//  NextStopAlarm
//
//  Created by Bradley Nordstrom on 2/10/17.
//  Copyright © 2017 Bradley Nordstrom. All rights reserved.
//

import MapKit
import UIKit

extension UIViewController {
    
    func showAlert(withTitle title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
