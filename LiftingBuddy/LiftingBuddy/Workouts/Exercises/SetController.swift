//
//  SetController.swift
//  LiftingBuddy
//
//  Created by Logman on 6/2/19.
//  Copyright © 2019 Logman. All rights reserved.
//a

import UIKit
import CoreData

class SetController: UITableViewController {
    
    var exercise: Exercise?
       
    var allSets = [[Set]]()
    
    var volume: Int16?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weightTextField.keyboardType = UIKeyboardType.numberPad
        
        repsTextField.keyboardType = UIKeyboardType.numberPad
        
        tableView.backgroundColor = UIColor.darkBlue
        
        setupPlusButtonInNavBar(selector: #selector(createNewSet))

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        fetchSets()
        
        setupUI()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
//        print(allSets)
//        print(indexPath.section)
//        print(indexPath.row)
        
        let set = allSets[0][indexPath.row]
        let inpIndex = Int16(indexPath.row)
        
        set.exercise = exercise
        let volume = set.reps * set.weight
        
        let label = "weight: \(set.weight) x reps: \(set.reps) -- Total: \(volume) lbs"
        cell.textLabel?.text = label
        cell.backgroundColor = UIColor.tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        updateSetIndex(set: set, intIndex: inpIndex)
        
        return cell
    }
    
    func updateSetIndex(set: Set, intIndex: Int16) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        set.index = intIndex
        
        do {
            try context.save()
            // save succeeds
            
        } catch let err {
            print("Failed to update set:", err)
            
        }
    }
    
    let cellId = "cellId"
    
    private func fetchSets() {
        guard let workoutSets = exercise?.set?.allObjects as? [Set] else { return }
        
        allSets = []
        // let's use my array and loop to filter instead
        
        allSets.append(workoutSets)
        
        allSets[0].sort {
            $0.index < $1.index
        }
    }
    
    @objc private func createNewSet() {
        print("Trying to add a set")
        
//        let context = CoreDataManager.shared.persistentContainer.viewContext
//
//        let set = NSEntityDescription.insertNewObject(forEntityName: "Set", into: context)
        
        let intReps = Int16(repsTextField.text ?? "0")
        let intWeight = Int16(weightTextField.text ?? "0")
        
        let set = CoreDataManager.shared.createSet(setReps: intReps ?? 0, setWeight: intWeight ?? 0)
        
//        set.setValue(Int16(nameTextField.text ?? "-99"), forKey: "reps")
//        set.setValue(Int16(nameTextField.text ?? "-99"), forKey: "weight")

        if let error = set.1 {
            // is where you present an error modal of some kind
            // perhaps use a UIAlertController to show your error message
            print(error)
        } else {
            didAddSet(set: set.0!)
        }
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = exercise?.name
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
//        label.text = "employeeTypes[section]"
//        label.backgroundColor = UIColor.lightBlue
//        label.textColor = UIColor.darkBlue
//        label.font = UIFont.boldSystemFont(ofSize: 16)
//        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSets[section].count
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            let set = self.allSets[indexPath.section][indexPath.row]
            print("Attempting to delete set:")
            
            print(indexPath.row)
            self.allSets[indexPath.section].remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            //            self.tableView.deleteSections([indexPath.section], with: .automatic)
            
            // delete the set from Core Data
            let context = CoreDataManager.shared.persistentContainer.viewContext
            
            context.delete(set)
            self.setupUI()
            do {
                try context.save()
            } catch let saveErr {
                print("Failed to delete exercise:", saveErr)
            }
        }
        deleteAction.backgroundColor = UIColor.lightRed
        
        return [deleteAction]
    }
    
    func didAddSet(set: Set) {
        let section = 0
        allSets[section].append(set)
        let row = allSets[section].count
        let newIndexPath = IndexPath(row: row - 1, section: section)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    let weightTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.placeholder = "Weight"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let repsTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.placeholder = "Reps"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var sum : Int16?
    
    func getVolume() -> Int16 {
        var volArray = [Int16]()
        print(allSets[0])
        for set in allSets[0] {
            let vol = (set.reps * set.weight)
            volArray.append(vol)
        }
        let sum = volArray.reduce(0, +)
        return sum
    }
  
    
    let totalVolume: UILabel = {
        let displayString = UILabel()
        displayString.textColor = .black
//        displayString.text = "test"
        displayString.translatesAutoresizingMaskIntoConstraints = false
        return displayString
    }()
    
    func setupUI() {
        view.addSubview(weightTextField)
        weightTextField.backgroundColor = .white
        weightTextField.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        weightTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        weightTextField.widthAnchor.constraint(equalToConstant: 100).isActive = true
        weightTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(repsTextField)
        repsTextField.backgroundColor = .white
        repsTextField.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        repsTextField.leftAnchor.constraint(equalTo: weightTextField.rightAnchor, constant: 30).isActive = true
        repsTextField.widthAnchor.constraint(equalToConstant: 100).isActive = true
        repsTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(totalVolume)
        totalVolume.backgroundColor = .white
        totalVolume.topAnchor.constraint(equalTo: weightTextField.bottomAnchor).isActive = true
        totalVolume.leftAnchor.constraint(equalTo: weightTextField.leftAnchor).isActive = true
        totalVolume.widthAnchor.constraint(equalToConstant: 100).isActive = true
        totalVolume.heightAnchor.constraint(equalToConstant: 50).isActive = true
        let volume = getVolume()
        totalVolume.text = "\(volume)"
    }
    
}
