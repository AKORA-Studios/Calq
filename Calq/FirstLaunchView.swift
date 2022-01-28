//
//  FirstLaunchView.swift
//  Calq
//
//  Created by Kiara on 09.01.22.
//

import UIKit

class FirstLaunch: UIViewController {
    
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var stepperLabelBig: UILabel!
    @IBOutlet weak var stepperLabelSmall: UILabel!
    @IBOutlet weak var pointSlider: UISlider!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pointLabel.text = "9"
        pointSlider.value = 9.0
        
        stepperLabelBig.text = "50"
        stepperLabelSmall.text = "50"
        
        view.backgroundColor = .clear
        backgroundView.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = view.bounds
        view.insertSubview(effectView, at: 0)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let settings = Util.getSettings()
        settings?.goalGrade = Int16(pointSlider.value)
        settings?.weightBigGrades = stepperLabelBig.text
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
    
    @IBAction func stpperChanged(_ sender: UIStepper) {
        let newBig = sender.value
        stepperLabelBig.text =  String(format: "%.0f", newBig)
        stepperLabelSmall.text =  String(format: "%.0f", 100 - newBig)
    }
}
