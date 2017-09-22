//
//  ViewController.swift
//  TabSaver
//
//  Created by Hyunchel Kim on 9/16/17.
//  Copyright © 2017 Hyunchel Kim. All rights reserved.
//

import Cocoa
import os.log

class ViewController: NSViewController {
    @IBOutlet weak var tabCountTextField: NSTextField!
    
    @IBOutlet weak var tabsDataLabel: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // MARK: ButtonClicked Implementations.
    
    @IBAction func loadButtonClicked(_ sender: Any) {
        var tabs: [[String: Any]]
        tabs = []
        if let savedTabsData = loadTabsData() {
            for tabsData in savedTabsData {
                tabs += convertToArrayOfDictionary(text: tabsData.toString())!
            }
        }
        var tabNames = ""
        for tab in tabs {
            tabNames += tab["name"] as! String
            tabNames += "\n"
        }
        tabsDataLabel.stringValue = tabNames
    }
    
    @IBAction func loadRecentButtonClicked(_ sender: Any) {
        print("Not implemented yet!")
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        // Save the current tabs for now.
        let tabsInfoJSONString = getTabData()
        saveTabsData(tabsData: TabsData(jsonString: tabsInfoJSONString)!)
        
    }
    
    @IBAction func saveAsButtonClicked(_ sender: Any) {
        print("Not implemented yet!")
    }
    
    @IBAction func clearButtonClicked(_ sender: Any) {
        tabsDataLabel.stringValue = "Cleared."
    }
    
    // MARK: MenuItemSelected Implementations.
    // These functions are for better logging.
    
    @IBAction func actionMenuSelected(_ sender: Any) {
        print("HELLO!")
    }
    
    @IBAction func loadMenuItemSelected(_ sender: Any) {
        print("loadMenuItemSelected")
//        loadButtonClicked(sender)
    }
    
    @IBAction func loadRecentMenuItemSelected(_ sender: Any) {
        print("loadRecentMenuItemSelected")
//        loadRecentButtonClicked(sender)
    }
    
    @IBAction func saveMenuItemSelected2(_ sender: Any) {
        os_log("Save MenuItem is selected.", log: OSLog.default, type: .debug)
        // Save the current tabs for now.
        let tabsInfoJSONString = getTabData()
        saveTabsData(tabsData: TabsData(jsonString: tabsInfoJSONString)!)
    }
    
    @IBAction func saveAsMenuItemSelected(_ sender: Any) {
        saveAsButtonClicked(sender)
    }
}

extension ViewController {
    
    // MARK: Helper functions
    
    func populateLoadSubMenus() {
        var tabs: [[String: Any]]
        tabs = []
        if let savedTabsData = loadTabsData() {
            // Load menu items.
            // How do you get access to that menu?
            
            for tabsData in savedTabsData {
                
            }
        } else {
            // Load empty menu here.
        }
    }
    
    func populateLoadRecentSubMenus() {
        
    }
    
    // MARK: Update functions
    
    func updateTabsDisplay(tabsInfo: String) {
        tabCountTextField.stringValue = tabsInfo
    }
}
