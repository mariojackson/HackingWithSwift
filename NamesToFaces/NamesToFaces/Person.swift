//
//  Person.swift
//  NamesToFaces
//
//  Created by Mario Jackson on 8/22/22.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
