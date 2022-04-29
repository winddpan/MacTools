//
//  ProjectViewModel.swift
//  PlistGenerator
//
//  Created by PAN on 2022/3/22.
//

import SwiftUI

class ProjectViewModel: ObservableObject {
    @AppStorage("mainfests") var mainfests: [ProjectInfo] = []
    
    init() {}
    
    func projectInfo(id: String) -> Binding<ProjectInfo>? {
        if let info = mainfests.first(where: { $0.id == id }) {
            return Binding<ProjectInfo>.init(get: {
                return self.mainfests.first(where: { $0.id == id }) ?? info
            }, set: { info, _ in
                if let idx = self.mainfests.firstIndex(where: { $0.id == id }) {
                    self.mainfests[idx] = info
                }
            })
        }
        return nil
    }
}
