//
//  ContentView.swift
//  PlistGenerator
//
//  Created by PAN on 2021/9/8.
//

import SwiftUI

let warningSymbol = "xmark.circle"

struct ContentView: View {
    @Binding var projectInfo: ProjectInfo
    @EnvironmentObject private var hud: HUDState

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("使用说明：“IPA下载地址”、“文件名”中用*代替数量").foregroundColor(.gray).font(.system(size: 13))
                Spacer()
            }
            .padding()

            Group {
                HStack {
                    Text("APP名称").frame(width: 100, alignment: .trailing)
                    MyTextField("例：花友", text: $projectInfo.appName)
                }

                HStack {
                    Text("包名").frame(width: 100, alignment: .trailing)
                    MyTextField("例：com.huayou.kaiqiappent", text: $projectInfo.bundleId)
                }

                HStack {
                    Text("IPA下载地址*").frame(width: 100, alignment: .trailing)
                    MyTextField("例：https://app.huayou.net/ios/ipa/huayou-v100-*.ipa", text: $projectInfo.ipaUrl)
                }

                HStack {
                    Text("ICON链接地址").frame(width: 100, alignment: .trailing)
                    MyTextField("例：https://app.huayou.net/ios/huayou.png", text: $projectInfo.iconUrl)
                }
            }

            Spacer().frame(height: 20)

            Group {
                HStack {
                    Text("文件名*").frame(width: 100, alignment: .trailing)
                    MyTextField("例：huayou-kaiqi-*.plist", text: $projectInfo.fileName)
                }

                HStack {
                    Text("数量").frame(width: 100, alignment: .trailing)
                    MyTextField("开始序号", text: $projectInfo.startIndex).multilineTextAlignment(.center).frame(width: 80)
                    Text("-")
                    MyTextField("结束序号", text: $projectInfo.endIndex).multilineTextAlignment(.center).frame(width: 80)
                    Text("例: 1-100").foregroundColor(.gray.opacity(0.5)).font(.system(size: 12)).padding()
                    Spacer()
                }
            }

            Spacer().frame(height: 20)

            HStack {
                Spacer()
                Button("生成") {
                    self.generateAction()
                }
                Spacer()
            }
        }
//        .frame(width: 500, height: 450)
        .onTapGesture {
            NSApplication.shared.endEditing()
        }
    }

    private func generateAction() {
        projectInfo.appName = projectInfo.appName.trimmingCharacters(in: .whitespacesAndNewlines)
        projectInfo.bundleId = projectInfo.bundleId.trimmingCharacters(in: .whitespacesAndNewlines)
        projectInfo.ipaUrl = projectInfo.ipaUrl.trimmingCharacters(in: .whitespacesAndNewlines)
        projectInfo.iconUrl = projectInfo.iconUrl.trimmingCharacters(in: .whitespacesAndNewlines)
        projectInfo.fileName = projectInfo.fileName.trimmingCharacters(in: .whitespacesAndNewlines)
        projectInfo.startIndex = projectInfo.startIndex.trimmingCharacters(in: .whitespacesAndNewlines)
        projectInfo.endIndex = projectInfo.endIndex.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !projectInfo.appName.isEmpty else {
            hud.show(title: "APP名称错误", systemImage: warningSymbol)
            return
        }
        guard !projectInfo.bundleId.isEmpty else {
            hud.show(title: "包名错误", systemImage: warningSymbol)
            return
        }
        guard projectInfo.ipaUrl.contains("*"), projectInfo.ipaUrl.hasPrefix("https://") else {
            hud.show(title: "ipa下载地址错误，必须https开头", systemImage: warningSymbol)
            return
        }
        guard !projectInfo.iconUrl.isEmpty, projectInfo.iconUrl.hasPrefix("https://") else {
            hud.show(title: "ICON地址错误，必须https开头", systemImage: warningSymbol)
            return
        }
        guard projectInfo.fileName.contains("*") else {
            hud.show(title: "文件名错误", systemImage: warningSymbol)
            return
        }
        guard let _startIndex = Int(projectInfo.startIndex), let _endIndex = Int(projectInfo.endIndex) else {
            hud.show(title: "数量错误", systemImage: warningSymbol)
            return
        }
        guard _endIndex >= _startIndex else {
            hud.show(title: "数量错误", systemImage: warningSymbol)
            return
        }

        let generator = Generator(appName: projectInfo.appName,
                                  bundleId: projectInfo.bundleId,
                                  ipaUrl: projectInfo.ipaUrl,
                                  iconUrl: projectInfo.iconUrl,
                                  fileName: projectInfo.fileName,
                                  startIndex: _startIndex,
                                  endIndex: _endIndex)
        generator.onCompleted = { result in
            switch result {
            case .success(let url):
                hud.show(title: "生成成功 -> \(url)", systemImage: "xmark.circle")
            case .failure(let error):
                hud.show(title: "生成失败\n\(error.localizedDescription)", systemImage: "checkmark.circle")
            }
        }
        generator.generate()
    }
}

struct MyTextField: View {
    private let _text: Binding<String>
    private let _title: String

    init(_ title: String, text: Binding<String>) {
        self._title = title
        self._text = text
    }

    var body: some View {
        HStack {
            TextField(_title, text: _text) {
                NSApplication.shared.endEditing()
            }
            .textFieldStyle(PlainTextFieldStyle()).frame(height: 26).padding(Edge.Set.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 5).foregroundColor(.white.opacity(0.1)).padding(0)
            )
            .padding(6)
            Spacer().frame(width: 20)
        }
    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        @State var test: ProjectInfo = ProjectInfo(id: "test")
        return ContentView(projectInfo: $test)
    }
}
