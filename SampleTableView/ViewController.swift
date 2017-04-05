//
//  ViewController.swift
//  SampleTableView
//
//  Created by takopom on 2017/04/05.
//  Copyright © 2017年 takopom. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var arrayController: NSArrayController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContents()
    }

    private func setupContents() {
        arrayController.addObject(SampleModel.init(number: 1, title: "Hello!"))
        arrayController.addObject(SampleModel.init(number: 2, title: "Welcome!"))
        arrayController.addObject(SampleModel.init(number: 300, title: "Thank you!"))
    }

}

