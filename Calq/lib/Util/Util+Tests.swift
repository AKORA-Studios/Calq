//
//  Util+FetchTests.swift
//  Calq
//
//  Created by Kiara on 05.01.24.
//

import Foundation

public enum TestSortCriteria: CaseIterable {
    case none
    case name
    case grade
    case date
    case createdAt
    case lastEditedAt
    case onlyActiveHalfyears
    case isWritten
    case isNotWritten
    
    static var array = [
        (name: NSLocalizedString("sortName", comment: ""), type: name),
        (name: NSLocalizedString("sortGrade", comment: ""), type: grade),
        (name: NSLocalizedString("sortGradeDatum", comment: ""), type: date),
        (name: NSLocalizedString("sortCreatedAt", comment: ""), type: createdAt),
        (name: NSLocalizedString("sortLasteditedAt", comment: ""), type: lastEditedAt),
        // Add them here thx
        (name: NSLocalizedString("sortGradeIsWritten", comment: ""), type: isWritten),
        (name: NSLocalizedString("sortGradeIsNotWritten", comment: ""), type: isNotWritten)
        // Do not add criterias after these!
    ]
}

extension Util {
    static func deleteTest(_ test: UserTest) {
        getContext().delete(test)
        saveCoreData()
    }
    
    static func getSortingArray() -> [(name: String, type: TestSortCriteria)] {
        if getSettings().showGradeTypes { return TestSortCriteria.array }
        return TestSortCriteria.array.filter { $0.type != TestSortCriteria.isWritten && $0.type != TestSortCriteria.isNotWritten }
    }
    
    /// Returns all Tests sorted By Criteria
    static func getAllSubjectTests(_ subject: UserSubject, _ sortedBy: TestSortCriteria = .none) -> [UserTest] {
        let tests = subject.getAllTests()
        
        switch sortedBy {
        case .none:
            return tests
        case .name:
            return tests.sorted(by: {$0.name < $1.name})
        case .grade:
            return tests.sorted(by: {$0.grade < $1.grade})
        case .date:
            return tests.sorted(by: {$0.date < $1.date})
        case .createdAt:
            return tests.sorted(by: {$0.createdAt < $1.createdAt})
        case .lastEditedAt:
            return tests.sorted(by: {$0.lastEditedAt < $1.lastEditedAt})
        case .onlyActiveHalfyears:
            return filterTests(tests, subject)
        case .isWritten:
            return tests.filter { $0.isWrittenGrade }
        case .isNotWritten:
            return tests.filter { !$0.isWrittenGrade }
        }
    }
    
    /// Filters out every inactive Halfyear Grades for subject grade calculations
    private static func filterTests(_ tests: [UserTest], _ subject: UserSubject) -> [UserTest] {
        var filteredTests = tests
        
        for year in [1, 2, 3, 4] {
            if !checkinactiveYears(getinactiveYears(subject), year) {
                filteredTests = filteredTests.filter { $0.year != year }
            }
        }
        return tests
    }
}
