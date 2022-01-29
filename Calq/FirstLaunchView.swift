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
    
    var settings: AppSettings?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settings = Util.getSettings()
        let oldWeight = Double((settings?.weightBigGrades)!)
        stepperLabelBig.text = String(oldWeight! * 100)
        stepperLabelSmall.text = String((1 - oldWeight!) * 100)
        
        let oldGoal = Int(settings!.goalGrade)
        pointLabel.text = String(oldGoal)
        pointSlider.value = Float(oldGoal)
        
        view.backgroundColor = .clear
        backgroundView.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = view.bounds
        view.insertSubview(effectView, at: 0)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        settings?.goalGrade = Int16(pointSlider.value)
        settings?.weightBigGrades = String(Double(stepperLabelBig.text!)! / 100)
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
