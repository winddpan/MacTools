//
//  PlistGeneratorApp.swift
//  PlistGenerator
//
//  Created by PAN on 2021/9/8.
//

import AppKit
import SwiftUI

extension NSApplication {
    func endEditing() {
        keyWindow?.resignFirstResponder()
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidBecomeActive(_ notification: Notification) {
        print(Bundle.main.bundlePath)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

@main
struct PlistGeneratorApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var hudState = HUDState()

    var body: some Scene {
        WindowGroup {
            ProjectView()
                .environmentObject(hudState)
                .hud(isPresented: $hudState.isPresented) {
                    Label(hudState.title, systemImage: hudState.systemImage)
                }
        }
    }
}
