import UIKit
import CoreData
import WidgetKit

class editGradeView: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var gradeTypeSegemnt: UISegmentedControl!
    @IBOutlet weak var gradeDate: UIDatePicker!
    @IBOutlet weak var yearSegment: UISegmentedControl!
    @IBOutlet weak var gradeName: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var pointSlider: UISlider!
    @IBOutlet weak var pointLabel: UILabel!
    
    var subject: UserSubject!;
    var test: UserTest!;
    var callback: ((_ sub : UserSubject) -> Void)!;

    var settings: AppSettings?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update();
        gradeName.delegate = self
        
        self.gradeTypeSegemnt.selectedSegmentIndex = Int(truncating: NSNumber(value: self.test.big));
        self.gradeDate.date = self.test.date!;
        self.yearSegment.selectedSegmentIndex = Int(self.test.year) - 1;
        self.gradeName.text = self.test.name
        self.pointSlider.value = Float(self.test.grade)
        self.pointLabel.text = String(self.test.grade)
        
        
        gradeTypeSegemnt.selectedSegmentTintColor = settings!.colorfulCharts ? Util.getPastelColorByIndex(self.subject.name!) :UIColor.init(hexString: self.subject.color!)
        yearSegment.selectedSegmentTintColor = settings!.colorfulCharts ? Util.getPastelColorByIndex(self.subject.name!) :UIColor.init(hexString: self.subject.color!)
    }
    
    func update(){
        self.settings = Util.getSettings()
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        let context = CoreDataStack.shared.managedObjectContext
        
        let name = gradeName.text?.count == 0 ? "Neue Note" : gradeName.text
        let newTest = UserTest(context: context)
        
        newTest.name =  name ?? "Neue Note"
        newTest.grade = Int16(pointSlider.value)
        newTest.date = gradeDate.date
        newTest.big = gradeTypeSegemnt.selectedSegmentIndex == 1
        newTest.year = Int16(yearSegment.selectedSegmentIndex + 1)
        
        context.delete(self.test)
        self.subject.addToSubjecttests(newTest)
        
        try! context.save()
        WidgetCenter.shared.reloadAllTimelines()
        self.test = newTest;
    
        dismiss(animated: true, completion: ({
            self.callback(self.subject);
        }))
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        CoreDataStack.shared.managedObjectContext.delete(self.test)
        
        dismiss(animated: true, completion: ({
            self.callback(self.subject);
        }))
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        sender.value =  round(sender.value)
        pointLabel.text = String(Int(pointSlider.value))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        gradeName.resignFirstResponder()
        return true
    }
    }
