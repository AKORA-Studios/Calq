//
//  AccessibilityIdentifier.swift
//  Calq
//
//  Created by Kiara on 31.08.23.
//

import Foundation


struct Ident {
    struct Main {
        static let tabBar_overview = "Main/tabBar/overview"
        static let tabBar_subjects = "Main/tabBar/subjects"
        static let tabBar_addgrade = "Main/tabBar/addgrade"
        static let tabBar_exams = "Main/tabBar/exams"
        static let tabBar_settings = "Main/tabBar/settings"
    }
    struct Chart {
        static let idk = "Chart/idk" // test
    }
    
    struct Toast {
        static let cancelButton = "Toast/cancel"
    }
    
    struct ExamScreen {
        static let examSelectButton = "ExamScreen/cancel"
        static let contextMenuExamDeleteButton = "ExamScreen/deleteExam"
    }
    
    struct OverviewScreen {
        static let averageCircleChart = "OverviewScreen/averageCircleChart"
        static let examCircleChart = "OverviewScreen/examCircleChart"
    }
    
    struct SettingsScreen {
        static let contextMenuAddGradeButton = "SettingsScreen/addGrade"
        static let contextMenuAddExamButton = "SettingsScreen/addExam"
        static let contextMenuDeleteSubjectButton = "SettingsScreen/deleteSubject"
    }
    
    struct EditWeightScreen {
        static let saveButton = "EditWeightScreen/save"
    }
    
    struct EditSubjectScreen {
        static let deletSubjectButton = "EditSubjectScreen/deleteSubject"
    }
 
    struct NewSubject {
        static let saveButton = "NewSubject/save"
    }
    
    struct NewGradeView {
        static let addGradeButton = "NewGradeView/add"
    }
    
    struct EditGradeScreen {
        static let saveGradeButton = "EditGradeScreen/save"
        static let deleteGradeButton = "EditGradeScreen/delete"
    }
    
    struct FirstLaunchScreen {
        static let loadDemoButton = "FirstLaunchScreen/laod"
        static let GoButton = "FirstLaunchScreen/go"
    }
    
    struct WhatsNewScreen {
        static let okButton = "WhatsNewScreen/ok"
    }
    
    struct SubjectListScreen {
        static let showGradesTableButton = "SubjectListScreen/showGradesTable"
    }
    
    struct GradeTableOverviewScreen {
        static let gradeList = "GradeTableOverviewScreen/gradeList"
    }
}

//           .accessibilityIdentifier(Ident.EditWeightScreen.contextMenuAddGrade)
