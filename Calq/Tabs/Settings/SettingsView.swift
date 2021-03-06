import UIKit
import CoreData
import WidgetKit

import UniformTypeIdentifiers
import MobileCoreServices

class SettingsView: ViewController,  UITableViewDelegate, UITableViewDataSource, UIDocumentPickerDelegate {
    private let tableView : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
        table.register(SwitchSettingsCell.self, forCellReuseIdentifier: SwitchSettingsCell.identifier)
        return table
    }()
    
    var settings: AppSettings?
    var models = [Section]()
    var switches = [SwitchSettingsCell]()
    
    let demoAlert = UIAlertController(title: "Bist du dir sicher?", message: "ALLE Daten werden unwiderruflich gelöscht", preferredStyle: .alert)
    let restoreAlert = UIAlertController(title: "Bist du dir sicher?", message: "ALLE Daten werden unwiderruflich gelöscht", preferredStyle: .alert)
    let importalert = UIAlertController(title: "Fehler beim Importieren", message: "Etwas in deiner Datei scheint falsch zu sein, die Daten können nicht importiert werden", preferredStyle: .alert)
    let versionAlert = UIAlertController(title: "Coming soon ...", message: "Hier gibt es noch nichts zu sehen UwU", preferredStyle: .alert)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.update();
    }
    
    func update() {
        self.settings = Util.getSettings()
        self.models = []
        self.switches = []
        self.configure()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update();
        self.navigationItem.title = "Einstellungen"
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        demoAlert.addAction(UIAlertAction(title: "Nein", style: .cancel, handler: nil))
        demoAlert.addAction(UIAlertAction(title: "Laden", style: .destructive, handler: {action in
            JSON.loadDemoData()
            self.update()
        }))
        restoreAlert.addAction(UIAlertAction(title: "Nein", style: .cancel, handler: nil))
        restoreAlert.addAction(UIAlertAction(title: "Löschen", style: .destructive, handler: {action in
            self.settings =  Util.deleteSettings()
            self.update()
        }))
        versionAlert.addAction(UIAlertAction(title: "Oki", style: .cancel, handler: nil))
        
        importalert.addAction(UIAlertAction(title: "Oki", style: .cancel, handler: nil))
        
        if #available(iOS 15.0, *) {
            let appearence =  UITabBarAppearance()
            appearence.configureWithDefaultBackground()
            self.tabBarController?.tabBar.scrollEdgeAppearance = appearence
            let appearence2 =  UINavigationBarAppearance()
            appearence2.configureWithDefaultBackground()
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearence2
        }
        
        // Add tableView footer
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let headerView = UIView(frame: CGRect(x: 0, y: 0,  width: self.tableView.frame.width, height: 17))
   
        let versionLabel = UILabel()
        versionLabel.frame = headerView.frame
        versionLabel.text = "Version: \(appVersion)"
        versionLabel.textColor = .systemGray3
        versionLabel.adjustsFontSizeToFitWidth = true
        versionLabel.textAlignment = .center

        headerView.addSubview(versionLabel)
        self.tableView.tableFooterView = headerView
    }
    
    //MARK: Table Setup
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    { return models[section].options.count}
    
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
            cell.settingsSwitch.addTarget(self, action: #selector(switched), for: .valueChanged)
            switches.append(cell)
            return cell
            
        case .gradeCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GradeCell.identifier, for: indexpath) as? GradeCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        }
    }
    
    @objc func switched(sender: UISwitch){
        if let cell = sender.superview?.superview as? SwitchSettingsCell {
            cell.callback?()
        } else {
            
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
    
    func navigateSubjectSettings(_ id: NSManagedObjectID){
       let subject = Util.getSubject(id)!
        let newView = self.storyboard?.getView("SetupSubject") as! SetupSubject
        newView.title = subject.name
        newView.subject = subject
        newView.callback = {
            self.update()
        }
        
        let navController = UINavigationController(rootViewController: newView)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func navigateAddSubject(){
        let newView = self.storyboard?.getView("NewSubjectView") as! NewSubjectView
        newView.callback = {
            self.update();
        }
        let navController = UINavigationController(rootViewController: newView)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func configure(){
        var arr: [SettingsOptionType] = []
        let subjects = Util.getAllSubjects()
        
        if(subjects.count != 0){
            
            for sub in subjects {
                arr.append(
                    .staticCell(
                        model:
                            SettingsOption(
                                title: sub.name!,
                                subtitle: "",
                                icon: sub.lk ? UIImage(systemName: "bookmark.fill") :  UIImage(systemName: "bookmark"),
                                iconBackgroundColor:  settings!.colorfulCharts ? Util.getPastelColorByIndex(sub.name!) : UIColor.init(hexString: sub.color!)
                            ){
                                self.navigateSubjectSettings(sub.objectID)
                            })
                )
            }
        }

        arr.append(
            .staticCell(
                model:
                    SettingsOption(
                        title: "Neuer Kurs",
                        subtitle: "",
                        icon: UIImage(systemName: "plus"),
                        iconBackgroundColor: .systemGreen
                    ){
                        self.navigateAddSubject()
                    })
        )
     
        models.append(Section(title: "Allgemein", options: [
            .staticCell(model:SettingsOption(title: "Github", subtitle: "", icon: UIImage(systemName: "info.circle.fill"), iconBackgroundColor: UIColor.init(hexString: "#63d3bd"))
                        {
                            let url = URL(string: "https://github.com/AKORA-Studios/Calq")
                            UIApplication.shared.open(url!)
                        }),
            
                .switchCell(model: SettingsSwitchOption(
                    title: "Automatische Farben",
                    icon: UIImage(systemName: "chart.bar.fill") ,
                    iconBackgroundColor: settings!.colorfulCharts ? .systemTeal : .systemGray2,
                    isOn: settings!.colorfulCharts,
                    selectHandler:{
                        
                    },
                    switchHandler: {
                        self.settings?.colorfulCharts = !(self.settings?.colorfulCharts ?? true) as Bool;
                        try! CoreDataStack.shared.managedObjectContext.save()
                        WidgetCenter.shared.reloadAllTimelines()
                        self.update();
                    }
                )),
                
                .staticCell(model:SettingsOption(title: "Noten importieren", subtitle: "", icon: UIImage(systemName: "folder.fill"), iconBackgroundColor: .accentColor, selectHandler: {
                   
                    let types = UTType.types(tag: "json", tagClass: UTTagClass.filenameExtension, conformingTo: nil)
                    let documentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: types)
                    documentPickerController.delegate = self
                    
                    self.present(documentPickerController, animated: true, completion: {})
                })),
            
                .staticCell(model:SettingsOption(title: "Noten exportieren", subtitle: "", icon: UIImage(systemName: "square.and.arrow.up.fill"), iconBackgroundColor: UIColor.init(hexString: "#2f4899"), selectHandler: {
                    
                    let data = JSON.exportJSON()
                    let url = JSON.writeJSON(data)
                    
                    let activity = UIActivityViewController(
                        activityItems: [ url],
                        applicationActivities: nil
                    )
                    self.present(activity, animated: true, completion: nil)
                })),
                
                    .staticCell(model:SettingsOption(title: "Wertung ändern", subtitle: "", icon: UIImage(systemName: "square.stack.3d.down.right.fill"), iconBackgroundColor: .systemYellow, selectHandler: {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "FirstLaunch", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FirstLaunch") as! FirstLaunch
                        return self.present(nextViewController, animated:true, completion: nil)
                    })),
            
                .staticCell(model:SettingsOption(title: "Demo Daten laden", subtitle: "", icon: UIImage(systemName: "exclamationmark.triangle.fill"), iconBackgroundColor: .systemOrange)
                            {
                                self.present(self.demoAlert, animated: true, completion: nil)
                            }),
            
                .staticCell(model:SettingsOption(title: "Daten löschen", subtitle: "", icon: UIImage(systemName: "trash.fill"), iconBackgroundColor: .systemRed)
                            {
                                self.present(self.restoreAlert, animated: true, completion: nil)
                            }),
        ] ))
        
        models.append(Section(title: "Kurse", options: arr))
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]){
        guard let fileURL = urls.first else {return}
                do {
            try JSON.importJSONfromDevice(fileURL)
                    self.update()
        }catch {
           self.present(self.importalert, animated: true, completion: nil)
        }
       
    }
 
}
