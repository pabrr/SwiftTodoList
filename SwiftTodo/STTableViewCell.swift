//
//  STTableViewCell.swift
//  SwiftTodo
//
//  Created by Полина Абросимова on 11.02.17.
//  Copyright © 2017 Полина Абросимова. All rights reserved.
//

import UIKit
import CoreData

protocol STDelegate {
    func doChanges(cell: STTableViewCell, becoming: Bool)
}

class STTableViewCell: UITableViewCell{
    
    var delegate: STDelegate?

    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func btnPressed(_ sender: Any) {
        // changing status
        
        let string = self.lbl.text
        var changing = false // need to become
        
        if btn.imageView?.image == UIImage(named: "done") {
            makeUndone(string: string!)
        }
        else {
            makeDone(string: string!)
            changing = true
        }
        
        delegate?.doChanges(cell: self, becoming: changing)
    }
    
    func cellConfiguration(lblText: String, isDone: Bool) {
        if isDone {
            self.makeDone(string: lblText)
        }
        else {
            self.makeUndone(string: lblText)
        }
    }
    
    func makeDone(string: String)  {
        btn.setImage(UIImage (named: "done"), for: .normal)
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: string)
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
        lbl.attributedText = attributeString
        lbl.textColor = UIColor.gray
    }
    
    func makeUndone (string: String) {
        btn.setImage(UIImage (named: "circle"), for: .normal)
        lbl.text = string
        lbl.textColor = UIColor.black
    }
}
