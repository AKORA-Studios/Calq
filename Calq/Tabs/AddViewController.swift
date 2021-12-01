import UIKit
import CoreData
import WidgetKit

class AddViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate {
    var inpactArr = [1, 2, 3,4,5,6,7,8,9,10,11,12,13,14,15]
    var SegmentItems = ["1", "2", "3", "4"]
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var gradeName: UITextField!
    @IBOutlet weak var customSC: UISegmentedControl!
    @IBOutlet weak var gradeTypeSelect: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pointSlider: UISlider!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var pointViewer: UILabel!
    
    var gradeType: Bool = false
    var yearSelcted: Int = 1
    var subject: UserSubject!
    var callback: (() -> Void)?
    
    var settings: AppSettings!
    
    @IBAction func addNewGrade(_ sender: Any) {
        let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
        
        let name = gradeName.text?.count == 0 ? "Neue Note" : gradeName.text
        let newTest = UserTest(context: CoreDataStack.shared.managedObjectContext)
        
        
        newTest.name = name ?? "Neue Note"
        newTest.grade =  Int16(pointSlider.value)
        newTest.date = datePicker.date
        newTest.big = gradeType
        newTest.year = Int16(yearSelcted)
        
        self.subject.addToSubjecttests(newTest)
        try! CoreDataStack.shared.managedObjectContext.save()
        WidgetCenter.shared.reloadAllTimelines()
        
        let newView = self.storyboard?.getView("gradeTableView") as! gradeTableView
        newView.subject = self.subject
        newView.update()
        
        dismiss(animated: true, completion: ({
            if ((self.callback) != nil) {
                self.callback!();
            }
            
          print("Neue Note hinzugefügt: \(newTest.name!)")
        }))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.update()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        update()
        gradeName.delegate = self;
        subjectLabel.text = self.subject.name!
        subjectLabel.textColor = settings!.colorfulCharts ? Util.getPastelColorByIndex(self.subject.name!) :
        UIColor.init(hexString: self.subject.color!)
        
        pointViewer.text = "9"
        pointSlider.value = 9.0
        
        customSC.removeAllSegments()
        gradeTypeSelect.removeAllSegments()
        
        for index in 0...3{
            customSC.insertSegment(withTitle: "\(index + 1)", at: index, animated: false)
        }
        
        customSC.selectedSegmentIndex = 0
        gradeTypeSelect.insertSegment(withTitle: "Test", at: 0, animated: false)
        gradeTypeSelect.insertSegment(withTitle: "Klausur", at: 1, animated: false)
        gradeTypeSelect.selectedSegmentIndex = 0
        gradeTypeSelect.selectedSegmentTintColor = settings!.colorfulCharts ? Util.getPastelColorByIndex(self.subject.name!) :
        UIColor.init(hexString: self.subject.color!)
        customSC.selectedSegmentTintColor = settings!.colorfulCharts ? Util.getPastelColorByIndex(self.subject.name!) :
        UIColor.init(hexString: self.subject.color!)
    }
    
    func update(){
        self.settings = Util.getSettings()
        self.subject = Util.getSubject(self.subject.objectID)
        
        var year: Int = 1
        
        if(self.subject.subjecttests?.count != 0){
            var tests = self.subject.subjecttests!.allObjects as! [UserTest]
            tests =  tests.sorted(by: ({$0.year > $1.year}))
          
            year = Int(tests[0].year)
        }
        self.yearSelcted = year
        customSC.selectedSegmentIndex = year - 1
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch customSC.selectedSegmentIndex{
        case 0:
            yearSelcted = 1
        case 1:
            yearSelcted = 2
        case 2:
            yearSelcted = 3
        case 3:
            yearSelcted = 4
        default:
            yearSelcted = 1
        }
    }
    
    @IBAction func gradeTypeChanged(_ sender: Any) {
        switch gradeTypeSelect.selectedSegmentIndex{
        case 0:
            gradeType = false
        case 1:
            gradeType = true
        default:
            gradeType = false
        }
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        sender.value =  round(sender.value)
        pointViewer.text = String(Int(pointSlider.value))
        
        let OldGradesValue: Int = 20
        let OldGradeCount: Int = 2
        let OldAverage = round(Double(Int(OldGradesValue) / Int(OldGradeCount)))
        let newGradeValue = OldGradesValue + Int(sender.value)
        let NewAverage = round(Double(newGradeValue / (OldGradeCount + 1)))
        
        if NewAverage > OldAverage{
            pointSlider.tintColor = .systemGreen
        }else if  NewAverage == OldAverage{
            pointSlider.tintColor = .systemGray
        }else if NewAverage < OldAverage{
            pointSlider.tintColor = .systemPink
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
