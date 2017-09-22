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
                if let dict = convertToDictionary(text: tabsData.toString()) {
                    loadMenu.submenu!.addItem(withTitle: dict["name"] as! String, action: #selector(menuItemClicked), keyEquivalent: "")
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
            if let dict = convertToDictionary(text: tabsData.toString()) {
                if dict["name"] as! String == sender.title {
                    var urls: [String]
                    urls = []
                    for tab in dict["data"] as! [[String: Any]] {
//                        let tabDict = tab as! [String: Any]
                        urls.append(tab["url"] as! String)
                    }
                    openSafariTabs(urls: urls)
                    return
                }
            }
        }
    }
}
