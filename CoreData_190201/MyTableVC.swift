//
//  ViewController.swift
//  CoreData_190201
//
//  Created by Joachim Vetter on 31.01.19.
//  Copyright © 2019 Joachim Vetter. All rights reserved.
//

import UIKit
import CoreData

class MyTableVC: UITableViewController {

    
    var myPuzzles = [Puzzles]() // Diese Variable ist ein Array, der als Elemente Instanzen der Klasse "Puzzles" beinhaltet (derzeit noch als leerer Array initialisiert); die Klasse "Puzzles" ist, um präzise zu sein, die in Core Data erstellte "Entity"
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var myFetching = NSFetchRequest<Puzzles>(entityName: "Puzzles")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPuzzles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        myCell.textLabel?.text = myPuzzles[indexPath.row].family
        myCell.detailTextLabel?.text = myPuzzles[indexPath.row].puzzleQuantity
        return myCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var finalTextField = UITextField() // Wir erstellen ein UITextField, dass innerhalb dieser Funktion überall zur Verfügung steht; im Closure etwas weiter unten "addTextField" wird das  TextFeld des AlertViewControllers dieser Variablen zugewiesen!
        
        let myAlertVC = UIAlertController(title: "Add Puzzle Request", message: "", preferredStyle: .alert)
        let myAction = UIAlertAction(title: "Done", style: .default) { (myAction) in
            let newPuzzleType = Puzzles(context: self.myContext)
            newPuzzleType.family = finalTextField.text!
            newPuzzleType.puzzleQuantity = "100/100"
            self.myPuzzles.append(newPuzzleType)
            self.save()
        }
        
        myAlertVC.addAction(myAction)
        myAlertVC.addTextField { (myTextField) in
            finalTextField = myTextField
        }
        
        present(myAlertVC, animated: true, completion: nil)
    }
    
    func save() {
        do {
            try myContext.save()
        }
        catch {
            print("there is an error \(error)")
        }
        tableView.reloadData()
    }
    
    func load() {
        do {
            myPuzzles = try myContext.fetch(myFetching)
        }
        catch {
            print("There is an error \(error)")
        }
        tableView.reloadData()
    }
}

