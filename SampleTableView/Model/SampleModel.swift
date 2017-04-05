//
//  SampleModel.swift
//  SampleTableView
//
//  Created by takopom on 2017/04/05.
//  Copyright © 2017年 takopom. All rights reserved.
//

import Cocoa

class SampleModel: NSObject {
    var number = 0
    var title = ""
    
    init(number: Int, title: String) {
        self.number = number
        self.title = title
    }
}
