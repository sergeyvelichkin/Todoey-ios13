//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift


class TodoListViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItem:Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory:Category? {
        didSet{
            loadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       tableView.delegate = self
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textToSave = UITextField()

        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Add new Item"
            textToSave=textField
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        let action = UIAlertAction(title: "Add", style: .default) { (action)  in
            
            if let newCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                    let newItem = Item()
                    newItem.title = textToSave.text!
                    newItem.dateCreated = Date()
                    newCategory.items.append(newItem)
                }
                }catch{
                    print("Error saving data to realm \(error)")
                }
                
            }
            self.tableView.reloadData()

        }

        alert.addAction(action)

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItem?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "TodoListCell")!
        
        if let item = todoItem?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items added"
        }

        return cell
        
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItem?[indexPath.row] {
            do {
            try realm.write {
                item.done = !item.done
            }
            }catch{
                print("Error updating done status \(error)")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
    }
    
    
   // MARK - Model Manipulation Methods
    
    
    func loadData() {
       
        
        todoItem = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
   

  }
}
    //MARK - SearchBar delegate methods

extension TodoListViewController : UISearchBarDelegate {


    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItem = todoItem?.filter("title CONTAINS %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()


    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }


}


