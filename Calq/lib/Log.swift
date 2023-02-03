//
//  Log.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import Foundation


func log(_ str: String){
    print(">>> ", str)
}


func coreDataError(_ str: String, _ err: Error?){
    print("❤️ Core Data Error \n ", str)
    if(err != nil){print(err as Any)}
}
