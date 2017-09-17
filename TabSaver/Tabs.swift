//
//  Tabs.swift
//  TabSaver
//
//  Created by Hyunchel Kim on 9/16/17.
//  Copyright © 2017 Hyunchel Kim. All rights reserved.
//

import Foundation
import Automator

func getTabsInformation() -> String {
    let scriptContent = """
        const getApplication = name => Application(name);
        const getRunningApp = app => app.running();
        const getWindows = app => app.windows();
        const getTabs = window => window.tabs();
        const makeData = tab => {
            return {
                name: tab.name(),
                url: tab.url(),
                index: tab.index()
            };
        };
        const spreadOut = (a, b) => a.concat(b);

        function run(argv) {
            const tabs = ["Safari"]
                .map(getApplication)
                .filter(getRunningApp)
                .map(getWindows)
                .reduce(spreadOut, [])
                .map(getTabs)
                .reduce(spreadOut, [])
                .map(makeData);
            return JSON.stringify(tabs);
        };
    """
    let output = runShell(args: "osascript", "-l", "JavaScript", "-e", scriptContent)
    return output
}

func runShell(args: String...) -> String {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    
    let pipe = Pipe()
    task.standardOutput = pipe
    
    task.launch()
    task.waitUntilExit()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    
    guard let output: String = String(data: data, encoding: .utf8) else {
        return ""
    }
    return output
}
