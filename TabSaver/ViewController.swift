//
//  ViewController.swift
//  TabSaver
//
//  Created by Hyunchel Kim on 9/16/17.
//  Copyright © 2017 Hyunchel Kim. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var tabCountTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tabsInfo = getTabsInformation()
        updateTabsDisplay(tabsInfo: tabsInfo)
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
}
