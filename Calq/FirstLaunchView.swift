//
//  FirstLaunchView.swift
//  Calq
//
//  Created by Kiara on 09.01.22.
//

import UIKit

class FirstLaunch: UIViewController {
    
    @IBOutlet weak var pointSlider: UISlider!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pointLabel.text = "9"
        pointSlider.value = 9.0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let settings = Util.getSettings()
        settings?.goalGrade = Int16(pointSlider.value)
        try! CoreDataStack.shared.managedObjectContext.save()
        super.viewDidDisappear(true)
    }
    @IBAction func navigateBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        sender.value =  round(sender.value)
        pointLabel.text = String(Int(pointSlider.value))
    }
}
