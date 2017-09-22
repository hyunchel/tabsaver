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
    
    @IBOutlet weak var statusMenu: NSMenu!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    @IBOutlet weak var loadMenu: NSMenuItem!
    
    var loadedTabsData: [TabsData] = []
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
        
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
                        urls.append(tab["url"] as! String)
                    }
                    openSafariTabs(urls: urls)
                    return
                }
            }
        }
    }
    
    @IBAction func quitSelected(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    @IBAction func saveMenuItemSelected(_ sender: Any) {
        os_log("Save MenuItem is selected.", log: OSLog.default, type: .debug)
        // Save the current tabs for now.
        let tabsInfoJSONString = getTabData()
        saveTabsData(tabsData: TabsData(jsonString: tabsInfoJSONString)!)
    }
    
}
