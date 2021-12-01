import UIKit
import CoreData
import WidgetKit

class SettingsView: ViewController,  UITableViewDelegate, UITableViewDataSource {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.update();
    }
    
    func update() {
        self.settings = Util.getSettings()
        self.models = [];
        self.switches = []
        self.configure();
        self.tableView.reloadData();
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
            Util.loadDemoData()
            self.update()
        }))
        restoreAlert.addAction(UIAlertAction(title: "Nein", style: .cancel, handler: nil))
        restoreAlert.addAction(UIAlertAction(title: "Löschen", style: .destructive, handler: {action in
            self.settings =  Util.deleteSettings()
            self.update()
        }))
        
        if #available(iOS 15.0, *) {
            let appearence =  UITabBarAppearance()
            appearence.configureWithDefaultBackground()
            self.tabBarController?.tabBar.scrollEdgeAppearance = appearence
        }
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
    
    func navigateSubjectSettings(name: String){
        let newView = storyboard?.getView("SetupSubject") as! SetupSubject
        newView.title = name
        
        do {
            let items = try CoreDataStack.shared.managedObjectContext.fetch(AppSettings.fetchRequest())
            if(items[0].usersubjects == nil){return}
            
            let subs = items[0].usersubjects!.allObjects as! [UserSubject]
            
            for meal in subs {
                if(meal.name == name) {newView.subject = meal
                    self.navigationController?.pushViewController(newView, animated: true)
                    return}
            }
        } catch{}
    }
    
    func navigateAddSubject(){
        let newView = storyboard?.getView("NewSubjectView") as! NewSubjectView
        newView.callback = {
            self.update();
        }
        self.navigationController?.present(newView, animated: true)
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
                                self.navigateSubjectSettings(name: sub.name!)
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
            
            .switchCell(model: SettingsSwitchOption(
                title: "Dynamische Linien",
                icon: settings!.smoothGraphs ? UIImage(systemName: "scribble") : UIImage(systemName: "line.diagonal"),
                iconBackgroundColor: .systemPurple,
                isOn: settings!.smoothGraphs,
                selectHandler:{
                    
                },
                switchHandler: {
                    self.settings?.smoothGraphs =
                    !(self.settings!.smoothGraphs ? true : false) as Bool;
                    try! CoreDataStack.shared.managedObjectContext.save()
                    WidgetCenter.shared.reloadAllTimelines()
                    self.update();
                }
            )),
            
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
            
                .staticCell(model:SettingsOption(title: "Noten exportieren", subtitle: "", icon: UIImage(systemName: "folder.fill"), iconBackgroundColor: UIColor.init(hexString: "#2f4899"), selectHandler: {
                    
                    let data = Util.exportJSON()
                    let url = Util.writeJSON(data)
                    
                    let activity = UIActivityViewController(
                        activityItems: [ url],
                        applicationActivities: nil
                    )
                    self.present(activity, animated: true, completion: nil)
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
        
        models.append(Section(title: "Info Links", options: [
            .staticCell(model:SettingsOption(title: "Github", subtitle: "", icon: UIImage(systemName: "info.circle.fill"), iconBackgroundColor: UIColor.accentColor)
                        {
                            let url = URL(string: "https://github.com/AKORA-Studios/Calq-iOS")
                            UIApplication.shared.open(url!)
                            
                        }),
            .staticCell(model:SettingsOption(title: "Cocoapods: Charts", subtitle: "", icon: UIImage(systemName: "chart.bar.xaxis"), iconBackgroundColor: UIColor.init(hexString: "#63d3bd"))
                        {
                            let url = URL(string: "https://cocoapods.org/pods/Charts")
                            UIApplication.shared.open(url!)
                            
                        })
        ]))
        
        models.append(Section(title: "Kurse", options: arr))
    }
}
