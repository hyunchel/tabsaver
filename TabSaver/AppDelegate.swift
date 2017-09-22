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
