//
//  GeneratorAction.swift
//  PlistGenerator
//
//  Created by PAN on 2021/9/8.
//

import Cocoa
import Foundation

class Generator {
    let appName: String
    let bundleId: String
    let ipaUrl: String
    let iconUrl: String
    let fileName: String
    let startIndex: Int
    let endIndex: Int

    var onCompleted: ((Result<URL, Error>) -> Void)?

    init(appName: String,
         bundleId: String,
         ipaUrl: String,
         iconUrl: String,
         fileName: String,
         startIndex: Int,
         endIndex: Int)
    {
        self.appName = appName
        self.bundleId = bundleId
        self.ipaUrl = ipaUrl
        self.iconUrl = iconUrl
        self.fileName = fileName
        self.startIndex = startIndex
        self.endIndex = endIndex
    }

    func generate() {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true

        openPanel.begin { (result) -> Void in
            if result == .OK, let directory = openPanel.url {
                print(directory)
                self._generate(outputDir: directory)
                self.onCompleted?(.success(directory))
            }
        }
    }

    func _generate(outputDir: URL) {
        let df = DateFormatter()
        df.dateFormat = "MMdd_HHmm"
        let suffix = df.string(from: Date())

        let directory = outputDir.appendingPathComponent("\(appName)_\(suffix)")

        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)

            for i in startIndex ... endIndex {
                let ipaUrl = self.ipaUrl.replacingOccurrences(of: "*", with: "\(i)")
                let fileName = self.fileName.replacingOccurrences(of: "*", with: "\(i)")

                let text = """
                <?xml version="1.0" encoding="UTF-8"?>
                <plist version="1.0">
                  <dict>
                      <key>items</key>
                      <array>
                        <dict>
                           <key>assets</key>
                           <array>
                             <dict>
                               <key>kind</key>
                               <string>software-package</string>
                               <key>url</key>
                               <string><![CDATA[\(ipaUrl)]]></string>
                             </dict>
                             <dict>
                               <key>kind</key>
                               <string>display-image</string>
                               <key>needs-shine</key>
                               <integer>0</integer>
                               <key>url</key>
                               <string><![CDATA[\(iconUrl)]]></string>
                             </dict>
                             <dict>
                               <key>kind</key>
                               <string>full-size-image</string>
                               <key>needs-shine</key>
                               <true/>
                               <key>url</key>
                               <string><![CDATA[\(iconUrl)]]></string>
                             </dict>
                           </array>
                           <key>metadata</key>
                           <dict>
                             <key>bundle-identifier</key>
                             <string>\(bundleId)</string>
                             <key>bundle-version</key>
                             <string><![CDATA[1.0.0]]></string>
                             <key>kind</key>
                             <string>software</string>
                             <key>title</key>
                             <string><![CDATA[\(appName)]]></string>
                           </dict>
                        </dict>
                      </array>
                  </dict>
                </plist>
                """

                let filePath = directory.appendingPathComponent(fileName)
                try text.write(to: filePath, atomically: true, encoding: .utf8)
            }
        } catch {
            self.onCompleted?(.failure(error))
            print(error)
        }
    }
}
