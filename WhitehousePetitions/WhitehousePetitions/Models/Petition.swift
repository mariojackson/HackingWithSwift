//
//  Petition.swift
//  WhitehousePetitions
//
//  Created by Mario Jackson on 8/6/22.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
