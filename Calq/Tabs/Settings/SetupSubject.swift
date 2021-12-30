import UIKit
import CoreData
import WidgetKit

class SetupSubject: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var SubjectTitle: UITextField!
    @IBOutlet weak var editGradesButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var colorDisplay: UIButton!
    @IBOutlet weak var subjectTypeSegment: UISegmentedControl!
    
    @IBOutlet weak var colorChanger: UIButton!
    let colorPicker = UIColorPickerViewController()
    let deleteAlert = UIAlertController(title: "Möchtest du das Fach wirklich löschen?", message: "Auch alle Noten darin werden unwiederuflich gelöscht", preferredStyle: .alert)
    
    var subject: UserSubject!
    var deleted = false;
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        do {
            let items = try CoreDataStack.shared.managedObjectContext.fetch(AppSettings.fetchRequest())
            if(items[0].usersubjects == nil){return}
            
            let subs = items[0].usersubjects!.allObjects as! [UserSubject]
            
            for meal in subs {
                if(meal.name == self.subject.name) {self.subject = meal
                    return}
              }
        } catch{}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        if (!self.deleted) {self.saveValues();}
    }
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        super.viewDidLoad()
        SubjectTitle.text = self.title
        
        colorPicker.delegate =  self
        colorPicker.supportsAlpha = false
        SubjectTitle.delegate = self
        
        deleteAlert.addAction(UIAlertAction(title: "Nein", style: .default, handler: nil))
        deleteAlert.addAction(UIAlertAction(title: "Löschen", style: .destructive, handler: {action in
            CoreDataStack.shared.managedObjectContext.delete(self.subject)
            self.deleted = true;

            self.navigationController?.popViewController(animated: true)
        }))
        
        colorPicker.selectedColor = UIColor.init(hexString: subject.color!)
        colorDisplay.backgroundColor = UIColor.init(hexString: subject.color!)
        subjectTypeSegment.selectedSegmentIndex = self.subject.lk ? 0 : 1
        
        do {
            let items = try CoreDataStack.shared.managedObjectContext.fetch(AppSettings.fetchRequest())
            if(items[0].usersubjects == nil){return}
            
            let subs = items[0].usersubjects!.allObjects as! [UserSubject]
            
            for meal in subs {
                if(meal.name == self.subject.name) {self.subject = meal
                    return}
              }
        } catch{}
    }
    
    @IBAction func deleteSubject(_ sender: Any) {
        self.present(deleteAlert, animated: true)
    }
    
    @IBAction func colorPalette(_ sender: UIButton) {
        self.present(colorPicker, animated: true, completion: nil)
    }
    
    @IBAction func changeColor(_ sender: Any) {
        self.present(colorPicker, animated: true, completion: nil)
    }
    
    @IBAction func editGrades(_ sender: Any) {
        let newView = storyboard?.getView("gradeTableView") as! gradeTableView
        newView.subject = self.subject;
        self.navigationController?.pushViewController(newView, animated: true)
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) { self.saveValues();}
    func textFieldDidEndEditing(_ textField: UITextField) { self.saveValues();}
   
    @IBAction func typeChanged(_ sender: UISegmentedControl) { self.saveValues();}
    
    func saveValues() {
        let context = CoreDataStack.shared.managedObjectContext
        self.subject.color = self.colorPicker.selectedColor.toHexString()
        
        let sub = UserSubject(context: context)
        sub.name = self.SubjectTitle.text ?? self.title!
        sub.color = colorDisplay.backgroundColor?.toHexString() ?? "ffffff"
        sub.lk = subjectTypeSegment.selectedSegmentIndex == 1 ? false : true
        sub.subjecttests = self.subject.subjecttests
        
        do{
            let items = try context.fetch(AppSettings.fetchRequest())
            items[0].addToUsersubjects(sub)
        }catch{}
            
        context.delete(self.subject)
        try! context.save()
        WidgetCenter.shared.reloadAllTimelines()
        
        self.subject = sub
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SubjectTitle.resignFirstResponder()
        return true
    }
}

extension SetupSubject: UIColorPickerViewControllerDelegate{
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        colorDisplay.backgroundColor =  viewController.selectedColor
    }
}
