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
        
        // Load JSON files here
        var tabs: [[String: Any]]
        tabs = []
        if let savedTabsData = loadTabsData() {
            for tabsData in savedTabsData {
                tabs += convertToArrayOfDictionary(text: tabsData.toString())!
            }
        }
        let tabsInfo = getTabData()
        let currentTabsData = convertToArrayOfDictionary(text: tabsInfo)
        let count = currentTabsData!.count
        updateTabsDisplay(tabsInfo: String(count))
        print(tabs.count)
        print(tabs[0])
        
        // Assuming the user hit save here.
        // saveTabsData(tabsData: TabsData(jsonString: tabsInfo)!)
        var tabNames = ""
        for tab in tabs {
            tabNames += tab["name"] as! String
            tabNames += "\n"
        }
        tabsDataLabel.stringValue = tabNames
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

extension ViewController {
    func updateTabsDisplay(tabsInfo: String) {
        tabCountTextField.stringValue = tabsInfo
    }
    
    // MARK: Private Methods
    private func saveTabsData(tabsData: TabsData) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject([tabsData], toFile: TabsData.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("TabsData successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save tabs data...", log:OSLog.default, type: .error)
        }
    }
    
    private func loadTabsData() -> [TabsData]? {
        // Return [[String: Any]] ?
        return NSKeyedUnarchiver.unarchiveObject(withFile: TabsData.ArchiveURL.path) as? [TabsData]
    }
}
