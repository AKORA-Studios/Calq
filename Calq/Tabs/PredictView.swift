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
        
        yearSegment.selectedSegmentIndex = self.selectedYear - 1
        errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        update()
    }
    
    func update(){
        if(UserDefaults.standard.string(forKey: "sub") == nil) {  return  }

        let sub = UserDefaults.standard.string(forKey: "sub")
        if(sub == nil) {return}
     
        let ObjectURL = URL(string: sub!)
        if(ObjectURL == nil) {return}

        let coordinator = CoreDataStack.shared.managedObjectContext.persistentStoreCoordinator
        let id = coordinator?.managedObjectID(forURIRepresentation: ObjectURL!)
        
        self.subject = Util.getSubject(id!)
            
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
        setImpactSegemnts()
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
            self.update()
        }
        self.present(newView, animated: true)
    }
    
    func setImpactSegemnts(){
        let width = Int(impactView.frame.width / 15)
         var num = width
        let colors = generateColors()
       
         for i in 1...15 {
             let text = UILabel()
             let view = UIView()
             if(self.subject == nil) { view.backgroundColor = .systemGray4} else { view.backgroundColor = colors[i - 1]}
             view.frame = CGRect(x: num, y: 0, width: width, height: Int(impactView.frame.height))
             text.frame = view.frame
             text.text = "\(i)"
             text.textAlignment = .center
      
             impactView.addSubview(view)
             impactView.addSubview(text)
             num += width
         }
    }
    
    
    func generateColors()-> [UIColor]{
        var arr : [UIColor] = []
        var none: Bool = false
    
        if(self.subject!.subjecttests?.count == 0 ) {none = true}
        var tests = self.subject!.subjecttests!.allObjects as! [UserTest]
        tests = tests.filter{Int($0.year) == selectedYear}
        if (tests.count == 0) {none = true}
        
        if(none){
            for _ in 1...15 {arr.append(.systemGray4)}
            return arr
        }
        
        //calculation old grade
        var divider = 2.0
        let big =  Util.testAverage(tests.filter{$0.big})
        if(tests.filter{$0.big}.count == 0) {divider = 1}
        
        let small = Util.testAverage(tests.filter{!$0.big})
        if(tests.filter{!$0.big}.count == 0) {divider = 1}
        
        let averageOld: Int = Int((big + small)/divider)
        
        //calculation new grade
        for i in 1...15 {
            divider = 2.0
            var newAverage: Int = 0
            
            if(typeSegment.selectedSegmentIndex == 0){ //small
                var gradeArr = tests.filter{!$0.big}.map{Int($0.grade)}
                gradeArr.append(i)
                let newSmall = Util.average(gradeArr)
                
                if(tests.filter{$0.big}.count == 0) {divider = 1}
                 newAverage = Int((big + newSmall)/divider)
                
            }else { //big
                var gradeArr = tests.filter{$0.big}.map{Int($0.grade)}
                gradeArr.append(i)
                let newBig = Util.average(gradeArr)
                
                if(tests.filter{!$0.big}.count == 0) {divider = 1}
                newAverage = Int((newBig + small)/divider)
            }
            
            //push colors
            if(averageOld > newAverage){
                arr.append(.systemRed)
            } else if(newAverage > averageOld ){
                arr.append(.systemGreen)
            }
            else {
                arr.append(.systemGray4)
            }
        }
        return  arr
    }

}
