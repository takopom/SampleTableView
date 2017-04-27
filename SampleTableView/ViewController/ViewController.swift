//
//  ViewController.swift
//  SampleTableView
//
//  Created by takopom on 2017/04/05.
//  Copyright © 2017年 takopom. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource {

    // MARK: Constants
    private let draggingUTIType = "public.data"
    
    // MARK: Properties
    private var sampleModels = Array<SampleModel>()
    
    // MARK: IB Outlets
    @IBOutlet var arrayController: NSArrayController!
    @IBOutlet weak var tableView: NSTableView!
    
    // MARK: Lifecycle events
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContents()
        setupTableView()
    }

    // MARK: Private methods
    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(forDraggedTypes: [draggingUTIType])
    }
    
    private func setupContents() {
        sampleModels.append(SampleModel.init(number: 1, title: "Hello!"))
        sampleModels.append(SampleModel.init(number: 2, title: "Welcome!"))
        sampleModels.append(SampleModel.init(number: 300, title: "Thank you!"))
        arrayController.content = sampleModels
    }

    // MARK: NSTableViewDataSource
    func tableView(_ tableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool {
        
        // Pasteboardにドラッグ元の行情報を記録
        let data = NSKeyedArchiver.archivedData(withRootObject: rowIndexes)
        let item = NSPasteboardItem.init()
        item.setData(data, forType: draggingUTIType)
        pboard.writeObjects([item])
        
        return true
    }
    
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {
        
        // 今回は、同じTableViewからのDropのみを受け付ける
        guard let source = info.draggingSource() as? NSTableView, source === tableView else {
            return []
        }
        
        return .move
    }
    
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
        
        // ドラッグされたアイテムのUTI typeを確認
        guard let item = info.draggingPasteboard().pasteboardItems?.first?.data(forType: draggingUTIType) else {
            return false
        }
        
        // Pasteboardに記録しておいたドラッグ元の行Noを取り出し
        guard let sourceRowIndexes = NSKeyedUnarchiver.unarchiveObject(with: item) as? IndexSet, let from = sourceRowIndexes.first else {
            return false
        }
        
        // ドラッグ先の行No
        var to = row
        
        // 上方から下方にドラッグする時、above(行間)の移動時に位置がずれる感覚がするので対応 (お好みで)
        if dropOperation == .above && from < to {
            to -= 1
        }
        
        // データの入れ替え
        swap(&sampleModels[from], &sampleModels[to])
        
        // TableViewの表示に反映する
        arrayController.content = sampleModels
        tableView.reloadData()
        
        // 移動先のrowを選択状態にしたい時は、selectRowIndexesをしておく。
        // (byExtendingSelectionは、以前の選択状態の保持をするかどうか。今回は「しない」方が自然な動きに見える)
        tableView.selectRowIndexes([to], byExtendingSelection: false)
        
        return true
    }
}

