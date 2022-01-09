//
//  FirstLaunchView.swift
//  Calq
//
//  Created by Kiara on 09.01.22.
//

import UIKit

class FirstLaunch: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func navigateBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
