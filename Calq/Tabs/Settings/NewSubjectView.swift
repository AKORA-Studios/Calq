import UIKit
import CoreData
import WidgetKit

class NewSubjectView: UIViewController, UITextFieldDelegate, UIColorPickerViewControllerDelegate {
    @IBOutlet weak var SubjectTitle: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var colorDisplay: UIButton!
    @IBOutlet weak var subjectTypeSegment: UISegmentedControl!
    
    @IBOutlet weak var colorChanger: UIButton!
    let colorPicker = UIColorPickerViewController()

    let reservedAlert = UIAlertController(title: "Kurs bereits vorhanden", message: "Ein anderer Kurs trägt bereits diesen Namen. Wähle doch bitte einen anderen", preferredStyle: .alert)
    var callback: (() -> Void)!;
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        self.callback();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SubjectTitle.text = self.title
        SubjectTitle.delegate = self
        colorPicker.delegate =  self
        
        reservedAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        colorPicker.selectedColor = UIColor.accentColor
        colorDisplay.backgroundColor = UIColor.accentColor
        colorChanger.backgroundColor = UIColor.accentColor
        subjectTypeSegment.selectedSegmentIndex = 1
        
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "Zurück", style: .plain, target: self, action: #selector(backButtonPressed))
        self.navigationItem.title = "Neuer Kurs"
        
        if #available(iOS 15.0, *) {
            let appearence =  UINavigationBarAppearance()
            appearence.configureWithDefaultBackground()
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearence
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)) )
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        SubjectTitle.resignFirstResponder()
      }
    
    @objc func backButtonPressed(_ sender:UIButton) {
       self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeColor(_ sender: Any) {
        self.present(colorPicker, animated: true, completion: nil)
    }
    
    @IBAction func saveSubjectOwO(_ sender: UIButton) {
         createSubject()
        self.dismiss(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SubjectTitle.resignFirstResponder()
        return true
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        colorDisplay.backgroundColor =  viewController.selectedColor
    }
    
    func createSubject(){
        let sub = UserSubject(context: CoreDataStack.shared.managedObjectContext)
        
        sub.name = SubjectTitle.text == "" ?  "Neuer Kurs" : SubjectTitle.text
        sub.color = colorPicker.selectedColor.toHexString()
        sub.lk = subjectTypeSegment.selectedSegmentIndex == 1 ? false : true
        
        do{
            let items = try CoreDataStack.shared.managedObjectContext.fetch(AppSettings.fetchRequest())
            items[0].addToUsersubjects(sub)
        } catch{}
        
       try! CoreDataStack.shared.managedObjectContext.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
}
