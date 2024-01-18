//
//  Util+Sorting.swift
//  Calq
//
//  Created by Kiara on 14.01.24.
//

import Foundation

public enum TestSortCriteria: CaseIterable {
    case name
    case grade
    case date
    case onlyActiveHalfyears
    
    static var array = [
        (name: NSLocalizedString("sortName", comment: ""), type: name),
        (name: NSLocalizedString("sortGrade", comment: ""), type: grade),
        (name: NSLocalizedString("sortGradeDatum", comment: ""), type: date)
    ]
}

extension Util {
    static func getSortingArray() -> [(name: String, type: TestSortCriteria)] {
        return TestSortCriteria.array
    }
    
    /// Returns all Tests sorted By Criteria
    static func getAllSubjectTests(_ subject: UserSubject, _ sortedBy: TestSortCriteria = .date) -> [UserTest] {
        let tests = subject.getAllTests()
        switch sortedBy {
        case .name:
            return tests.sorted(by: {$0.name < $1.name})
        case .grade:
            return tests.sorted(by: {$0.grade < $1.grade})
        case .date:
            return tests.sorted(by: {$0.date < $1.date})
        case .onlyActiveHalfyears:
            return filterTests(tests, subject)
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
