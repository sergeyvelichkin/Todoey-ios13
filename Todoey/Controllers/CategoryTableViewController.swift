//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by 1 on 8/13/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray:Results<Category>?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        
        tableView.rowHeight=80.0

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! SwipeTableViewCell

        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added yet"
        
        cell.delegate = self
        
        return cell
        
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        var textToSave = UITextField()
               
               //1. Create the alert controller.
               let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)

               //2. Add the text field. You can configure it however you need.
               alert.addTextField { (textField) in
                   textField.placeholder = "Add new Category"
                   textToSave=textField
               }

               // 3. Grab the value from the text field, and print it when the user clicks OK.
        let action = UIAlertAction(title: "Add", style: .default) { (action)  in
                   print(textToSave.text!)
                   
                  
                   let newCategory = Category()
                   newCategory.name = textToSave.text!
                   
                   self.saveData(category: newCategory)
                   
                }
            alert.addAction(action)
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        
        }
    
//MARK: - Tableview delegate Methods
    var selectedRow:Int=0
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destinationVC = segue.destination as! TodoListViewController

            destinationVC.selectedCategory = categoryArray?[selectedRow]
       
    }

// MARK: - Model Manipulation Methods
        
    func saveData(category:Category) {
            
            do {
                try realm.write{
                    realm.add(category)
                }
            }catch{
                print("Error saving data to an array,  \(error)")
            }
            tableView.reloadData()
        }
        
    func loadData() {
        
        categoryArray = realm.objects(Category.self)
        
        
        tableView.reloadData()
      
    }
}

extension CategoryTableViewController:SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            if let category = self.categoryArray?[indexPath.row] {
                do {
                    try self.realm.write{
                        self.realm.delete(category)
                    }
                }catch{
                    print("Error saving data to an array,  \(error)")
                }
            }
            
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}
