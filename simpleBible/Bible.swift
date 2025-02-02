//
//  Bible.swift
//  simpleBible
//
//  Created by shkim on 2/2/25.
//

import SwiftUI

struct Book: Identifiable {
    let id = UUID()
    let name: String
    let code: String
}

let genesis = Book(name: "창세기", code: "gen")


