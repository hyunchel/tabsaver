//
//  Tabs.swift
//  TabSaver
//
//  Created by Hyunchel Kim on 9/16/17.
//  Copyright © 2017 Hyunchel Kim. All rights reserved.
//

import Foundation
import os.log

// MARK: Classes and Structs

struct PropertyKey {
    static let name = "name"
    static let url = "url"
    static let index = "index"
    
    static let jsonString = "jsonString"
}

class TabsData: NSObject, NSCoding {
    
    // MARK: Properties
    var jsonString: String
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("tabsData")

    // MARK: Initialization
    init?(jsonString: String) {
        // The only case where the initialization should fail.
        if jsonString.isEmpty {
            return nil
        }
        
        // Initialize properties here.
        self.jsonString = jsonString
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(jsonString, forKey: PropertyKey.jsonString)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required, if no "name", this initialization should fail.
        guard let jsonString = aDecoder.decodeObject(forKey: PropertyKey.jsonString) as? String
            else {
                os_log("Unable to decode a JSON string for TabsData", log: OSLog.default, type: .debug)
                return nil
        }
        // Must call designated initializer.
        self.init(jsonString: jsonString)
    }
    
    func toString() -> String {
        return self.jsonString
    }
    
    // MARK: Tab related functions.
    
    func openTabs() {
        if let dict = convertToDictionary(text: self.jsonString) {
            var urls: [String]
            urls = []
            for tab in dict["data"] as! [[String: Any]] {
                urls.append(tab["url"] as! String)
            }
            openSafariTabs(urls: urls)
        }
    }
}

// MARK: OSAScript functions

func openSafariTabs(urls: [String]) {
    let scriptContent = """
        function run(argv) {
            var app = Application("Safari");
            var newTabs = argv.map(url => app.Tab({ url: url }));
            app.Document().make();
            Array.prototype.push.apply(app.windows()[0].tabs, newTabs);
        };
    """
    var args = [scriptContent]
    args.append(contentsOf: urls)
    runOSAScriptMultipleArguments(args)
}

func getTabData(name: String = "") -> String {
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
            return JSON.stringify({
                name: "\(name)" === "" ? (new Date()).toJSON() : "\(name)",
                data: tabs,
            });
        };
    """
    return runOSAScriptMultipleArguments([scriptContent])
}

// MARK: TabsData Functions

func saveAllTabsData(newTabsData: [TabsData]) {
    // Load the previously saved data and re-save with new data added.
    os_log("Saving:", log: OSLog.default, type: .debug)
    let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(newTabsData, toFile: TabsData.ArchiveURL.path)
    if isSuccessfulSave {
        os_log("TabsData successfully replaced.", log: OSLog.default, type: .debug)
    } else {
        os_log("Failed to replace tabs data.", log:OSLog.default, type: .error)
    }
}

func appendTabsData(tabsData: TabsData) {
    // Load the previously saved data and re-save with new data added.
    var savedTabsData = loadAllTabsData()
    if savedTabsData == nil {
        savedTabsData = []
    }
    savedTabsData!.append(tabsData)
    os_log("Appending:", log: OSLog.default, type: .debug)
    let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(savedTabsData!, toFile: TabsData.ArchiveURL.path)
    if isSuccessfulSave {
        os_log("TabsData successfully saved.", log: OSLog.default, type: .debug)
    } else {
        os_log("Failed to save tabs data.", log:OSLog.default, type: .error)
    }
}

func loadAllTabsData() -> [TabsData]? {
    return NSKeyedUnarchiver.unarchiveObject(withFile: TabsData.ArchiveURL.path) as? [TabsData]
}

func deleteAllTabsData() {
    do {
        try FileManager.default.removeItem(at: TabsData.ArchiveURL)
        os_log("Successfully deleted TabsData.", log: OSLog.default, type: .debug)
    } catch {
        os_log("Failed to delete saved tabs data.", log: OSLog.default, type: .error)
    }
}

// MARK: Conversion Functions

func convertToDictionary(text: String) -> [String: Any]? {
    let data: Data
    data = text.data(using: .utf8)!
    let json = try? JSONSerialization.jsonObject(with: data, options: [])
    if let array = json as? [String: Any] {
        return array
    }
    return nil
}

// MARK: Shell Functions.

func runOSAScriptMultipleArguments(_ args: [String]) -> String {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    var osaArgs = ["osascript", "-l", "JavaScript", "-e"]
    osaArgs += args
    task.arguments = osaArgs
    
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

// MARK: Actions.

func searchAndOpenTabs(loadedTabsData: [TabsData], title: String) {
    // Search for the corresponding URL given a title.
    for tabsData in loadedTabsData {
        if let dict = convertToDictionary(text: tabsData.toString()) {
            if dict["name"] as! String == title {
                return tabsData.openTabs()
            }
        }
    }
}

func deleteSelectedMenuItem(loadedTabsData: inout [TabsData], title: String) {
    // Search for the corresponding URL given a title.
    var index = 0
    for tabsData in loadedTabsData {
        if let dict = convertToDictionary(text: tabsData.toString()) {
            if dict["name"] as! String == title {
                break
            }
        }
        index += 1
    }
    loadedTabsData.remove(at: index)
    saveAllTabsData(newTabsData: loadedTabsData)
}

func saveCurrentSession() {
    let tabsInfoJSONString = getTabData()
    appendTabsData(tabsData: TabsData(jsonString: tabsInfoJSONString)!)
}
