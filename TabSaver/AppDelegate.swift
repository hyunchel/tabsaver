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
    
    // MARK: Outlets
    @IBOutlet weak var statusMenu: NSMenu!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    @IBOutlet weak var loadMenu: NSMenuItem!
    @IBOutlet weak var deleteMenu: NSMenuItem!
    
    // MARK: Class Variables
    var loadedTabsData: [TabsData] = []
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        // Initialize the tray icon.
        let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        // Load saved sessions into Load menus.
         populateSubMenus()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    // MARK: Custom Functions
    func populateSubMenus() {
        // Load up menu items.
        loadMenu.submenu!.removeAllItems()
        deleteMenu.submenu!.removeAllItems()
        if let savedTabs = loadAllTabsData() {
            self.loadedTabsData = savedTabs
            for tabsData in savedTabs {
                if let dict = convertToDictionary(text: tabsData.toString()) {
                    loadMenu.submenu!.addItem(withTitle: dict["name"] as! String, action: #selector(menuItemClicked), keyEquivalent: "")
                    deleteMenu.submenu!.addItem(withTitle: dict["name"] as! String, action: #selector(deleteMenuItemClicked), keyEquivalent: "")
                } else {
                    os_log("Loaded, but nothing in it.", log: OSLog.default, type: .debug)
                }
            }
        } else {
            os_log("Nothing is loaded.", log: OSLog.default, type: .debug)
        }
    }
    
    // MARK: Action Functions
    @objc
    func menuItemClicked(_ sender: NSMenuItem) {
        os_log("Load MenuItem is selected.", log: OSLog.default, type: .debug)
        searchAndOpenTabs(loadedTabsData: loadedTabsData, title: sender.title)
    }

    @objc
    func deleteMenuItemClicked(_ sender: NSMenuItem) {
        os_log("Delete MenuItem is selected.", log: OSLog.default, type: .debug)
        deleteSelectedMenuItem(loadedTabsData: &self.loadedTabsData, title: sender.title)
        populateSubMenus()
    }
    
    @IBAction func quitSelected(_ sender: NSMenuItem) {
        os_log("Quitting! Bye.", log: OSLog.default, type: .debug)
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func saveMenuItemSelected(_ sender: Any) {
        os_log("Save MenuItem is selected.", log: OSLog.default, type: .debug)
        saveCurrentSession()
        populateSubMenus()
    }
}
