import UIKit
import CoreData
import WidgetKit

class AddViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var subjectSelect: UIButton!
    @IBOutlet weak var impactView: UIView!
    @IBOutlet weak var gradeName: UITextField!
    @IBOutlet weak var gradeTypeSelect: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pointSlider: UISlider!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var pointViewer: UILabel!
    @IBOutlet weak var yearSegment: UISegmentedControl!
    
    var bigGrade: Bool = false
    var selectedYear: Int = 1
    var subject: UserSubject?
    
    let errorAlert = UIAlertController(title: "Fehler qwq", message: "Du hast keinen Kurs ausgewählt", preferredStyle: .alert)
    
    @IBAction func addNewGrade(_ sender: Any) {
        if(self.subject == nil) {  return  self.present(self.errorAlert, animated: true, completion: nil)}
        UserDefaults.standard.set(nil, forKey: "sub")
        let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
        
        let name = gradeName.text?.count == 0 ? "Neue Note" : gradeName.text
        let newTest = UserTest(context: CoreDataStack.shared.managedObjectContext)
        
        newTest.name = name ?? "Neue Note"
        newTest.grade =  Int16(pointSlider.value)
        newTest.date = datePicker.date
        newTest.big = bigGrade
        newTest.year = Int16(selectedYear)
        
        self.subject!.addToSubjecttests(newTest)
        try! CoreDataStack.shared.managedObjectContext.save()
        WidgetCenter.shared.reloadAllTimelines()
        
        UserDefaults.standard.set(nil, forKey: "sub")
        self.tabBarController?.selectedViewController = tabBarController?.viewControllers![0]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        UserDefaults.standard.set(nil, forKey: "sub")
        
        self.update()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        UserDefaults.standard.set(nil, forKey: "sub")
        
        self.navigationItem.title = "Note hinzufügen"
        errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        gradeName.delegate = self
        pointViewer.text = "9"
        pointSlider.value = 9.0
        
        update()
    }
    
    func update(){
        setImpactSegemnts()
        
        if(UserDefaults.standard.string(forKey: "sub") == nil) {
            addButton.backgroundColor = .systemGray4
            self.subject = nil
            gradeTypeSelect.selectedSegmentTintColor = .accentColor
             yearSegment.selectedSegmentTintColor = .accentColor
            pointSlider.tintColor = .accentColor
            subjectSelect.setTitle("Kurs wählen", for: .normal)
            subjectSelect.backgroundColor = .accentColor
            return  }
        
        let sub = UserDefaults.standard.string(forKey: "sub")
        if(sub == nil) {return}
        
        let ObjectURL = URL(string: sub!)
        if(ObjectURL == nil) {return}
        
        let coordinator = CoreDataStack.shared.managedObjectContext.persistentStoreCoordinator
        let id = coordinator?.managedObjectID(forURIRepresentation: ObjectURL!)
        
        self.subject = Util.getSubject(id!)
        addButton.backgroundColor = .accentColor
        subjectSelect.backgroundColor = .systemGray5
        
        
        if(self.subject != nil){
            subjectSelect.setTitle(self.subject!.name, for: .normal)
        }
        
        if(self.subject != nil) {
            gradeTypeSelect.selectedSegmentTintColor = UIColor.init(hexString: self.subject!.color!)
             yearSegment.selectedSegmentTintColor = UIColor.init(hexString: self.subject!.color!)
            pointSlider.tintColor = UIColor.init(hexString: self.subject!.color!)
        }
        if(Util.getSettings()!.colorfulCharts) {
             gradeTypeSelect.selectedSegmentTintColor = Util.getPastelColorByIndex(self.subject!.name!)
             yearSegment.selectedSegmentTintColor = Util.getPastelColorByIndex(self.subject!.name!)
            pointSlider.tintColor = Util.getPastelColorByIndex(self.subject!.name!)
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
        update()
    }
    
    @IBAction func gradeTypeChanged(_ sender: Any) {
        switch gradeTypeSelect.selectedSegmentIndex{
        case 0:
            bigGrade = false
        case 1:
            bigGrade = true
        default:
            bigGrade = false
        }
        update()
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        sender.value =  round(sender.value)
        pointViewer.text = String(Int(pointSlider.value))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
            let sub = UserDefaults.standard.string(forKey: "sub")
            if(sub == nil) {return}
            
            let ObjectURL = URL(string: sub!)
            if(ObjectURL == nil) {return}
            
            let coordinator = CoreDataStack.shared.managedObjectContext.persistentStoreCoordinator
            let id = coordinator?.managedObjectID(forURIRepresentation: ObjectURL!)
            
            self.subject = Util.getSubject(id!)
            var year: Int = 1
                
            if(self.subject != nil) {
                        if(self.subject?.subjecttests?.count != 0){
                            var tests = self.subject!.subjecttests!.allObjects as! [UserTest]
                            tests =  tests.sorted(by: ({$0.year > $1.year}))
                            
                            year = Int(tests[0].year)
                        }
                    }
       
                    self.selectedYear = year
            self.yearSegment.selectedSegmentIndex = year - 1
            
            self.update() }
        self.present(newView, animated: true)
    }
    
    func setImpactSegemnts(){
        let width = Int(impactView.frame.width / 15)
        impactView.frame = CGRect(x: impactView.frame.minX, y: impactView.frame.minY, width: CGFloat(width * 15), height: impactView.frame.height)
        var num: Int = 0
        let colors: [UIColor] = self.subject != nil ? generateColors() : []
        impactView.backgroundColor = .clear
        
        for i in 1...15 {
            let text = UILabel()
            let view = UIView()
            if(i == 1){
                view.layer.cornerRadius = 5.0
                view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            }
            if(i == 15) {
                view.layer.cornerRadius = 5.0
                view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            }
    
            
            if(self.subject == nil) { view.backgroundColor = .systemGray5} else { view.backgroundColor = colors[i - 1]}
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
            for _ in 1...15 {arr.append(.systemGray5)}
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
            
            if(gradeTypeSelect.selectedSegmentIndex == 0){ //small
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
                arr.append(.systemGray5)
            }
        }
        return  arr
    }
}
