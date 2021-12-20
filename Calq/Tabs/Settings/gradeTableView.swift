import UIKit
import CoreData
import WidgetKit

class gradeTableView: ViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(GradeCell.self, forCellReuseIdentifier: GradeCell.identifier)
        table.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
        return table
    }()
    
    var models = [Section]()
    var subject: UserSubject!
    var showOptions: Bool = true
    
    let deleteAlert = UIAlertController(title: "Bist du dir sicher?", message: "ALLE Noten werden unwiderruflich gelöscht", preferredStyle: .alert)
    
    var settings: AppSettings?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    }
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        super.viewDidLoad()
        self.settings = Util.getSettings()
        self.models = []
        configure();
        self.tableView.reloadData();
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        self.navigationItem.title = "Notenübersicht"
        
        deleteAlert.addAction(UIAlertAction(title: "Nein", style: .default, handler: nil))
        deleteAlert.addAction(UIAlertAction(title: "Löschen", style: .destructive, handler: {action in
            self.subject.subjecttests = []
            try! CoreDataStack.shared.managedObjectContext.save()
            WidgetCenter.shared.reloadAllTimelines()
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popToRootViewController(animated: true)
            
        }))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func update() {
        self.settings = Util.getSettings()
        self.models = []
        self.subject = Util.getSubject(self.subject.objectID)
        configure();
        self.tableView.reloadData();
    }
    
    //MARK: Table Config
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    { return models[section].options.count}
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexpath: IndexPath) -> UITableViewCell{
        let model = models[indexpath.section].options[indexpath.row]
        
        switch model.self{
        case .staticCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier, for: indexpath) as? SettingsCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
            
        case .switchCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchSettingsCell.identifier, for: indexpath) as? SwitchSettingsCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
            
        case .gradeCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GradeCell.identifier, for: indexpath) as? GradeCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = models[indexPath.section].options[indexPath.row]
        
        switch type.self{
        case .staticCell(let model):
            model.selectHandler()
        case .switchCell(let model):
            model.selectHandler()
        case .gradeCell(let model):
            model.selectHandler()
        }
    }
    
    func navigateGrade(_ test: UserTest){
        let newView = storyboard?.getView("editGradeView") as! editGradeView
        
        newView.title = test.name
        newView.subject = test.testtosubbject
        newView.test = test;
        newView.callback = { (sub) in
            self.subject = sub;
            self.update();
            let newView = self.storyboard?.getView("SettingsView") as! SettingsView
            newView.navigationItem.setHidesBackButton(true, animated: true)
            self.navigationController!.pushViewController(newView, animated: true)
        }
        self.present(newView, animated: true)
    }
    
    func configure(){
        
        if(self.showOptions) {
            models.append(Section(title: "", options: [
                .staticCell(model: SettingsOption(
                    title: "Alle löschen", subtitle: "",
                    icon: UIImage(systemName: "archivebox"),
                    iconBackgroundColor: .systemRed )
                            {
                                self.present(self.deleteAlert, animated: true)
                            }),
              /*  .staticCell(model: SettingsOption(
                    title: "Neue Note hinzufügen", subtitle: "",
                    icon: UIImage(systemName: "doc.badge.plus"), iconBackgroundColor: .systemGreen )
                            {
                                let addView = self.storyboard?.getView("AddViewController") as! AddViewController;
                           //     addView.title = self.subject.name;
                                addView.subject = self.subject
                                addView.update()
                                
                                UserDefaults.resetStandardUserDefaults()
                                UserDefaults.standard.set(self.subject.objectID.uriRepresentation().absoluteString, forKey: "sub")
                                
                                
                                self.present(addView, animated: true)
                            })*/
            ]))
        }

        if(self.subject.subjecttests == nil){return}
        
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let Alltests = self.subject.subjecttests!.allObjects as! [UserTest]
        
        for i in 1...4 {
            var name = "";
            switch i {
            case 1: name = "Erstes";
            case 2: name = "Zweites";
            case 3: name = "Drittes";
            case 4: name = "Viertes";
            default:name = "Letztes";
            }
            
            let tests =  Alltests.filter{$0.year == i};
            if (tests.count < 1) {continue;}
            
            models.append(
                Section(title: name + " Halbjahr",
                        options: tests.enumerated().map(
                            {(ind, t) in
                               
                                
                                    return .gradeCell(
                                        model:
                                            GradeOption(
                                                title: t.name ?? "Unknown Name",
                                                subtitle: dateFormatter.string(from: t.date!),
                                                points: String(t.grade),
                                    
                                                iconBackgroundColor:settings!.colorfulCharts ? Util.getPastelColorByIndex(self.subject.name!) :
                                                    UIColor.init(hexString: self.subject.color!),
                                                hideIcon: t.big,
                                                hideArrow: !self.showOptions
                                            ){
                                                if(self.showOptions)  { self.navigateGrade(t)}
                                                
                                            }
                                        
                                    )
                                
                             }
                        )
                       )
            )
        }
        
    }
}
