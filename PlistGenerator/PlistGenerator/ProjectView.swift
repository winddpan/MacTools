//
//  ProjectView.swift
//  PlistGenerator
//
//  Created by PAN on 2022/3/21.
//

import SwiftUI

struct ProjectView: View {
    @ObservedObject var viewModel = ProjectViewModel()
    @State var selection: String?
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer(minLength: 10)
                HStack {
                    Button("增加") {
                        let new = ProjectInfo(id: UUID().uuidString)
                        viewModel.mainfests.append(new)
                        self.selection = new.id
                    }
                    Button("删除") {
                        showingAlert = true
                        
                        if let selection = selection {
                            viewModel.mainfests.removeAll(where: { $0.id == selection })
                        }
                        self.selection = viewModel.mainfests.last?.id
                        
                    }
//                    .alert("确认删除", isPresented: $showingAlert) {
//                        Button("取消", role: .cancel) {}
//                        Button("删除", role: .destructive) {
//                            if let selection = selection {
//                                viewModel.mainfests.removeAll(where: { $0.id == selection })
//                            }
//                            self.selection = viewModel.mainfests.last?.id
//                        }
//                    }
                }
                List(viewModel.mainfests) { info in
                    if let bd = self.viewModel.projectInfo(id: info.id) {
                        NavigationLink<Text, ContentView>(info.appName,
                                                          tag: info.id,
                                                          selection: $selection,
                                                          destination: {
                                                              ContentView(projectInfo: bd)

                                                          })
                    } else {
                        Text("发生了未知错误")
                    }
                }
            }
        }
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView()
    }
}
