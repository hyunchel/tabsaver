//
//  AppDelegate.swift
//  TabSaver
//
//  Created by Hyunchel Kim on 9/16/17.
//  Copyright © 2017 Hyunchel Kim. All rights reserved.
//

import Cocoa
import os.log

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var loadMenu: NSMenuItem!
    
    var loadedTabsData: [TabsData] = []
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        // Load up menu items.
        if let savedTabs = loadTabsData() {
            self.loadedTabsData = savedTabs
            for tabsData in savedTabs {
                if let arrOfDict = convertToArrayOfDictionary(text: tabsData.toString()) {
                    for dict in arrOfDict {
                        loadMenu.submenu!.addItem(withTitle: dict["name"] as! String, action: #selector(menuItemClicked), keyEquivalent: "")
                    }
                    os_log("Loaded, and menu items are populated.", log: OSLog.default, type: .debug)
                } else {
                    os_log("Loaded, but nothing in it.", log: OSLog.default, type: .debug)
                }
            }
        } else {
            os_log("Nothing is loaded.", log: OSLog.default, type: .debug)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    // MARK: Private Methods
    private func saveTabsData(tabsData: TabsData) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject([tabsData], toFile: TabsData.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("TabsData successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save tabs data.", log:OSLog.default, type: .error)
        }
    }
    
    private func loadTabsData() -> [TabsData]? {
        // Return [[String: Any]] ?
        return NSKeyedUnarchiver.unarchiveObject(withFile: TabsData.ArchiveURL.path) as? [TabsData]
    }

    @objc
    func menuItemClicked(_ sender: NSMenuItem) {
        // Search for the corresponding URL given a title.
        for tabsData in self.loadedTabsData {
            if let arrOfDict = convertToArrayOfDictionary(text: tabsData.toString()) {
                for tab in arrOfDict {
                    if tab["name"] as! String == sender.title {
                        openSafariTab(url: tab["url"] as! String)
                        return
                    }
                }
            }
        }
    }
}

