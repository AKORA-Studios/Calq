//
//  Models.swift
//  Calq
//
//  Created by Kiara on 03.09.23.
//

import Foundation

// Struct for importing from json
struct AppStructV3: Codable {
    var colorfulCharts: Bool
    var hasFiveExams: Bool
    var usersubjects: [SubjectStruct_Typed]
    var gradeTypes: [JSONTypes]
    var highlightedType: Int
    var formatVersion: Int
    
    struct JSONTypes: Codable {
        var name: String
        var weigth: Double
        var id: Int
    }
}

struct AppStructV1: Codable {
    var colorfulCharts: Bool
    var usersubjects: [SubjectStruct_Typed]
    var gradeTypes: [JSONTypes]
    var formatVersion: Int
    
    struct JSONTypes: Codable {
        var name: String
        var weigth: Int
        var id: Int
    }
}

struct SubjectStruct_Typed: Codable {
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
