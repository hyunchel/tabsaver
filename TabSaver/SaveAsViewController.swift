//
//  SaveAsViewController.swift
//  TabSaver
//
//  Created by Hyunchel Kim on 9/24/17.
//  Copyright © 2017 Hyunchel Kim. All rights reserved.
//

import Cocoa
import os.log

class SaveAsViewController: NSViewController {

    @IBOutlet weak var sessionTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        // Check for the length of text field.
        var tabsInfoJSONString: String
        if sessionTextField.stringValue == "" {
            tabsInfoJSONString = getTabData()
        } else {
            tabsInfoJSONString = getTabData(name: sessionTextField.stringValue)
        }
        saveTabsData(tabsData: TabsData(jsonString: tabsInfoJSONString)!)
        // How would you separate "populateSubMenus" function from AppDelegate.
//        populateSubMenus()
        dismiss(sender)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        // This dismiss function seems to work only with modal view.
        dismiss(sender)
    }
    
    @IBAction func loadMenuSelected(_ sender: NSMenuItem) {
        print("HELLO it is clicked.")
    }
}
