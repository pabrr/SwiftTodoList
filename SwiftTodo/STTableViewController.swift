//
//  STTableViewController.swift
//  SwiftTodo
//
//  Created by Полина Абросимова on 11.02.17.
//  Copyright © 2017 Полина Абросимова. All rights reserved.
//

import UIKit
import CoreData

class STTableViewController: UITableViewController, STDelegate{
    
    let coreData = CoreData.sharedInstance
    
    var myLists: [NSManagedObject] = []
    var thisIndexPath: NSInteger = 0
    
    func doChanges(cell: STTableViewCell, becoming: Bool) {
        guard let thisIndex = tableView.indexPath(for: cell) else {
            return
        }
        let newSave = myLists[thisIndex.row]
        
        coreData.saveChanges(becoming: becoming, forString: cell.lbl.text!, withIdentifier: newSave.value(forKey: "identifier") as! String)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateData()
        tableView.reloadData()
    }
    
    func updateData () {
        myLists = coreData.initing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // deleting
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            let some = myLists[indexPath.row]
            let string = some.value(forKeyPath: "todo") as? String
            let isDone = some.value(forKey: "isFinished") as? Bool
            let ident = some.value(forKey: "identifier")

            coreData.deleteTodo(todo: string!, isDone: isDone!, identifier: ident as! String)
            
            updateData()
            
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    // watching
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        thisIndexPath = indexPath.row
        self.performSegue(withIdentifier: "Cell", sender: self)
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        if identifier == "Cell" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let second = storyboard.instantiateViewController(withIdentifier: "STViewController") as! STViewController
            second.isEdit = false
            let some: NSManagedObject = myLists[thisIndexPath]
            second.thatText = some.value(forKey: "todo") as! String
            self.navigationController?.showDetailViewController(second, sender: self)
        }
        else {
            let second = STViewController ()
            second.isEdit = true
            self.navigationController?.pushViewController(second, animated: true)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SwiftTodo.STTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! STTableViewCell
        
        let thisList = myLists[indexPath.row]
        let thisText = thisList.value(forKeyPath: "todo") as! String
        let thisBool = thisList.value(forKey: "isFinished") as! Bool
        
        cell.delegate = self
        
        cell.cellConfiguration(lblText: thisText, isDone: thisBool)
        
        return cell
    }
}
