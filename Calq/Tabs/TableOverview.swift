//
//  TableOverview.swift
//  Calq
//
//  Created by Kiara on 10.02.22.
//

import UIKit

class TableOverview: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(TableCell.self, forCellReuseIdentifier: TableCell.identifier)
        return table
    }()
    
    var models = [Section3]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update();
        self.navigationItem.title = "Notentabelle"
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "《 Zurück", style: .plain, target: self, action: #selector(backButtonPressed))
        
        if #available(iOS 15.0, *) {
            let appearence2 =  UINavigationBarAppearance()
            appearence2.configureWithDefaultBackground()
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearence2
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.update()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
    
    func update() {
        self.models = []
        self.configure()
        self.tableView.reloadData()
    }
    
    @objc func backButtonPressed(_ sender:UIButton) {
       self.dismiss(animated: true, completion: nil)
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
        case .tableCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.identifier, for: indexpath) as? TableCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        }
    }
    

    func configure(){
        var arr: [TableSectionOption] = []
        let subjects = Util.getAllSubjects()

            for sub in subjects {
                let str = (averageString(sub))
                    
                arr.append(
                    .tableCell(model:
                            TableOption(title: sub.name!, subtitle: str)
                        )
                )
            }
        models.append(Section3(title: "", options: arr))
    }
    
    /// Generates a convient String that shows the grades of the subject.
    private func averageString(_ subject: UserSubject) -> String{
        var str: String = ""
        if(subject.subjecttests == nil) {return str}
        let tests = subject.subjecttests!.allObjects as! [UserTest]
        
        for i in 1...4 {
            let arr = tests.filter({$0.year == i});
            if(arr.count == 0) {str += "-- ";continue}
            
            if(!Util.checkinactiveYears(Util.getinactiveYears(subject), i)){ str += "/ ";continue}
            let points = Int(round(Util.testAverage(arr)))

            str += String(points)
            if(i != 4){ str += " "}
        }
        return str
    }
    
    

}

