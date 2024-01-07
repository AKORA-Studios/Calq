//
//  Models.swift
//  Calq
//
//  Created by Kiara on 03.09.23.
//

import Foundation

struct AppStructV3: Codable { // Model 4
    var colorfulCharts: Bool
    var hasFiveExams: Bool
    var showGradeTypes: Bool
    var usersubjects: [SubjectStruct]
    var gradeTypes: [JSONTypes]
    var highlightedType: Int
    var formatVersion: Int
    
    struct JSONTypes: Codable {
        var name: String
        var weigth: Int
        var id: Int
    }
    
    struct SubjectStruct: Codable {
        var name: String
        var lk: Bool
        var color: String
        var inactiveYears: String
        var lastEditedAt: Date
        var createdAt: Date
        var subjecttests: [JSONTest]
        
        struct JSONTest: Codable {
            var name: String
            var year: Int
            var grade: Int
            var date: String
            var type: Int
            var isWrittenGrade: Bool
            var lastEditedAt: Date
            var createdAt: Date
        }
    }
}


struct AppStructV2: Codable { // Model 3
    var colorfulCharts: Bool
    var hasFiveExams: Bool
    var usersubjects: [SubjectStruct]
    var gradeTypes: [JSONTypes]
    var highlightedType: Int
    var formatVersion: Int
    
    struct JSONTypes: Codable {
        var name: String
        var weigth: Int
        var id: Int
    }
    
    struct SubjectStruct: Codable {
        var name: String
        var lk: Bool
        var color: String
        var inactiveYears: String
        var subjecttests: [JSONTest]
        
        struct JSONTest: Codable {
            var name: String
            var year: Int
            var grade: Int
            var date: String
            var type: Int
        }
    }
}

struct AppStructV1: Codable {
    var colorfulCharts: Bool
    var usersubjects: [SubjectStruct]
    var gradeTypes: [JSONTypes]
    var formatVersion: Int
    
    struct JSONTypes: Codable {
        var name: String
        var weigth: Int
        var id: Int
    }
    
    struct SubjectStruct: Codable {
        var name: String
        var lk: Bool
        var color: String
        var inactiveYears: String
        var subjecttests: [JSONTest]
        
        struct JSONTest: Codable {
            var name: String
            var year: Int
            var grade: Int
            var date: String
            var type: Int
        }
    }
}

struct AppStruct: Codable {
    var colorfulCharts: Bool
    var usersubjects: [SubjectStruct]
    
    struct SubjectStruct: Codable {
        var name: String
        var lk: Bool
        var color: String
        var inactiveYears: String
        var subjecttests: [JSONTest]
        
        struct JSONTest: Codable {
            var name: String
            var year: Int
            var grade: Int
            var date: String
            var big: Bool
        }
    }
}
