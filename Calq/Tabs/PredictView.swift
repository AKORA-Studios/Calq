//
//  PredictView.swift
//  Calq
//
//  Created by Kiara on 09.12.21.
//

import UIKit
import CoreData

class PredictView: UIViewController {
    @IBOutlet weak var impactView: UIView!
    @IBOutlet weak var subjectPicker: UIButton!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    @IBOutlet weak var yearSegment: UISegmentedControl!
    
    var selectedYear: Int = 1
    var subject: UserSubject?
    var bigGrade: Bool = false
    
    let errorAlert = UIAlertController(title: "Fehler qwq", message: "Du hast nicht genügend Fächer eingetragen", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImpactSegemnts()
        yearSegment.selectedSegmentIndex = self.selectedYear - 1
        errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "sub")
        update()
    }

    
    func update(){
        if(UserDefaults.standard.data(forKey: "sub") == nil) {  return  }
        print("A")
        let sub = UserDefaults.standard.data(forKey: "sub") as! String?
        if(sub == nil) {return}
        print("B")
        let ObjectURL = URL(string: sub!)
        if(ObjectURL == nil) {return}
        print("C")
        let coordinator = CoreDataStack.shared.managedObjectContext.persistentStoreCoordinator
        let id = coordinator?.managedObjectID(forURIRepresentation: ObjectURL!)
        
        self.subject = Util.getSubject(id!)
        print(self.subject!.name)
            
            var year: Int = 1
            if(self.subject!.subjecttests?.count != 0){
                var tests = self.subject!.subjecttests!.allObjects as! [UserTest]
                tests =  tests.sorted(by: ({$0.year > $1.year}))
              
                year = Int(tests[0].year)
            }
            self.selectedYear = year
            yearSegment.selectedSegmentIndex = year - 1
     
        if(self.subject != nil){
            subjectPicker.setTitle(self.subject!.name, for: .normal)
        }
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch yearSegment.selectedSegmentIndex{
        case 0:
            selectedYear = 1
        case 1:
            selectedYear = 2
        case 2:
            selectedYear = 3
        case 3:
            selectedYear = 4
        default:
            selectedYear = 1
        }
    }
    
    @IBAction func gradeTypeChanged(_ sender: Any) {
        switch typeSegment.selectedSegmentIndex{
        case 0:
            bigGrade = false
        case 1:
            bigGrade = true
        default:
            bigGrade = false
        }
    }
    
    @IBAction func selectOne(_ sender: UIButton) {
        if(Util.getAllSubjects().count == 0){
            return  self.present(self.errorAlert, animated: true, completion: nil)
        }
        navigateSubjectPick()
    }
    
    func navigateSubjectPick(){
        let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        
        let newView = storyboard?.getView("PredictSelect") as! PredictSelect
        newView.callback = {
            self.update();
            print("call")
        }
        self.present(newView, animated: true)
    }
    
    func setImpactSegemnts(){
        let width = Int(impactView.frame.width / 15)
         var num = width
       
         for i in 1...15 {
             let text = UILabel()
             let view = UIView()
             view.backgroundColor = .red
             view.frame = CGRect(x: num, y: 0, width: width, height: Int(impactView.frame.height))
             text.frame = view.frame
             text.text = "\(i)"
             text.textAlignment = .center
             if(i % 2 == 0){ view.backgroundColor = .blue}
      
             impactView.addSubview(view)
             impactView.addSubview(text)
             num += width
         }
    }

}
