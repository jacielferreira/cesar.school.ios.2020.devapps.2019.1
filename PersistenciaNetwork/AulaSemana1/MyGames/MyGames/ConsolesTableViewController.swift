//
//  ConsolesTableViewController.swift
//  MyGames
//
//  Created by Douglas Frari on 16/05/20.
//  Copyright © 2020 Douglas Frari. All rights reserved.
//

import UIKit
import CoreData


class ConsolesTableViewController: UITableViewController {
    
    var fetchedResultController:NSFetchedResultsController<Console>!
    
    
    let searchController = UISearchController(searchResultsController: nil)

    var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Você não tem plataformas cadastradas"
        label.textAlignment = .center
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        
        navigationItem.searchController = searchController
        
        // usando extensions
      
        loadConsoles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func loadConsoles(filtering: String = "") {
        let fetchRequest: NSFetchRequest<Console> = Console.fetchRequest()
               let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
               fetchRequest.sortDescriptors = [sortDescriptor]
               
               if filtering.isEmpty == false {
                   // COMO SE FOSSE WHERE do SQL
                   // usando predicate: conjunto de regras para pesquisas
                   // contains [c] = search insensitive (nao considera letras identicas)
                   let predicate = NSPredicate(format: "name contains [c] %@", filtering)
                   fetchRequest.predicate = predicate
               }
               
               // possui
               fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self as? NSFetchedResultsControllerDelegate
               
               do {
                   try fetchedResultController.performFetch()
               } catch  {
                   print(error.localizedDescription)
               }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = fetchedResultController?.fetchedObjects?.count ?? 0
        
        tableView.backgroundView = count == 0 ? label : nil
        
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       guard let console = fetchedResultController.fetchedObjects?[indexPath.row] else {
        return cell
        }
        //ConsolesManager.shared.consoles[indexPath.row]
//        cell.textLabel?.text = console.name
        cell.textLabel?.text = console.name
  
        return cell
 
    }
    

//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let console = ConsolesManager.shared.consoles[indexPath.row]
////        showAlert(with: console)
//
//        // deselecionar atual cell
//        tableView.deselectRow(at: indexPath, animated: false)
//     }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        ConsolesManager.shared.deleteConsole(index: indexPath.row, context: context)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier! == "consoleSegue" {
            print("consoleSegue")
            
            let vc = segue.destination as! ConsoleViewController
            
            if let consoles = fetchedResultController
                .fetchedObjects {
                vc.console = consoles[
                    tableView
                        .indexPathForSelectedRow!.row
                ]
                
            }else if segue.identifier! ==
                "newConsoleSegue"
                {
                    print("newConsoleSegue")
                
            }
            
//            if let consoles = fetchedResultController.fetchedObjects {
//                vc.console = consoles[tableView.indexPathForSelectedRow!.row]
//            }
//
//        } else if segue.identifier! == "newConsoleSegue" {
//            print("newConsoleSegue")
//        }
    }
}
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

//    func showAlert(with console: Console?) {
//        let title = console == nil ? "Adicionar" : "Editar"
//        let alert = UIAlertController(title: title + " plataforma", message: nil, preferredStyle: .alert)
//
//        alert.addTextField(configurationHandler: { (textField) in
//            textField.placeholder = "Nome da plataforma"
//
//            if let name = console?.name {
//                textField.text = name
//            }
//        })
//
//        alert.addAction(UIAlertAction(title: title, style: .default, handler: {(action) in
//            let console = console ?? Console(context: self.context)
//            console.name = alert.textFields?.first?.text
//            do {
//                try self.context.save()
//                self.loadConsoles()
//            } catch {
//                print(error.localizedDescription)
//            }
//        }))
//
//        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
//        alert.view.tintColor = UIColor(named: "second")
//
//        present(alert, animated: true, completion: nil)
//    }
    
    
//    @IBAction func addConsole(_ sender: UIBarButtonItem) {
//        print("addConsole")
//
//        // nil indica que sera criado uma plataforma nova
////        showAlert(with: nil)
//    }
    
    
} // fim da classe
