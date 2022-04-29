//
//  ProjectInfo.swift
//  PlistGenerator
//
//  Created by PAN on 2022/3/22.
//

import Foundation

struct ProjectInfo: Codable, Identifiable, Equatable {
    var id: String
    var appName: String
    var bundleId: String
    var ipaUrl: String
    var iconUrl: String
    var fileName: String
    var startIndex: String
    var endIndex: String

    init(id: String) {
        self.id = id
        self.appName = ""
        self.bundleId = ""
        self.ipaUrl = ""
        self.iconUrl = ""
        self.fileName = ""
        self.startIndex = ""
        self.endIndex = ""
    }
}
