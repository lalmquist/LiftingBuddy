//
//  SetController.swift
//  LiftingBuddy
//
//  Created by Logman on 6/2/19.
//  Copyright © 2019 Logman. All rights reserved.
//

import UIKit
import CoreData

class SetController: UITableViewController {
    
    var exercise: Exercise?
       
    var allSets = [[Set]]()
    
    var volume: Int16?
    
    var lastDate: Date?
    
    var lastResults: [Int16]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weightTextField.keyboardType = UIKeyboardType.numberPad
        
        repsTextField.keyboardType = UIKeyboardType.numberPad
        
        tableView.backgroundColor = UIColor.black
        
        setupPlusButtonInNavBar(selector: #selector(createNewSet))

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        fetchSets()
        
        var lastResults = getLastExerciseData()
        
        setupUI()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
            let set = allSets[0][indexPath.row]
            let inpIndex = Int16(indexPath.row)
        
            set.exercise = exercise
            let volume = Int64(set.reps) * Int64(set.weight)
        
            let label = "weight: \(set.weight) x reps: \(set.reps) -- Total: \(volume) lbs"
            cell.textLabel?.text = label
            cell.backgroundColor = UIColor.black
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
    
    func getLastExerciseData() -> [Int16] {
        
        var found = false
        var preWorkout = false
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Workout>(entityName: "Workout")
        do {
            
            let workouts = try context.fetch(fetchRequest)
            let sortedWorkouts = workouts.sorted(by: {$0.date!.compare($1.date!) == .orderedDescending})
            
            for lifts in sortedWorkouts {
                guard let workoutExercises = lifts.exercise?.allObjects as? [Exercise] else { return [0]}
                for exer in workoutExercises {
                    if lifts.date?.compare((exercise?.workout!.date)!) == .orderedAscending{
                        preWorkout = true
                        lastDate = lifts.date
                    }
                    if exer.name == exercise?.name && preWorkout == true && found == false {
                        found = true
                        print("++++++++++ FOUND ++++++++++")
                        guard let lookUpSets = exer.set?.allObjects as? [Set] else { return [0]}
                        var results = [Int16]()
                        for items in lookUpSets {
                            results.append(items.weight)
                            results.append(items.reps)
                        }
                        print("+++++++++++++++++++++++++++")
                        return results
                    }
                }
            }
            print("======= DONE =======")
            
        } catch let fetchErr {
            print("Failed to fetch workouts:", fetchErr)
            return [0]
        }
        return[0]
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
//        print("Trying to add a set")
        
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
//        label.text = "SECTION HEADER"
//        label.backgroundColor = UIColor.custBlue
//        label.textColor = UIColor.custBlue
//        label.font = UIFont.boldSystemFont(ofSize: 16)
//        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let footerTitle = UILabel()
        footerTitle.text = "The last time you did - \(exercise?.name ?? "Not Found") \n Date - \(String(describing: lastDate))\n\(String(describing: lastResults))"
        footerTitle.textColor = .black
        footerTitle.textAlignment = .center
        footerTitle.numberOfLines = 3
        footerTitle.lineBreakMode = .byWordWrapping
        footerTitle.backgroundColor = .white
        footerTitle.font = UIFont.boldSystemFont(ofSize: 16)

        return footerTitle
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSets[0].count
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            let set = self.allSets[indexPath.section][indexPath.row]
            print("Attempting to delete set:")
            
            print([indexPath])
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func didAddSet(set: Set) {
        allSets[0].append(set)
        let row = allSets[0].count
        let newIndexPath = IndexPath(row: row - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    let weightLabel: UILabel = {
        let textField = UILabel()
        textField.textColor = .white
        textField.text = "  Weight"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let repsLabel: UILabel = {
        let textField = UILabel()
        textField.textColor = .white
        textField.text = " Reps"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let fillLabel: UILabel = {
        let fill_Label = UILabel()
        fill_Label.backgroundColor = .custBlue
        fill_Label.translatesAutoresizingMaskIntoConstraints = false
        return fill_Label
    }()

    let weightTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.placeholder = "0"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let repsTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.placeholder = "0"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var sum : Int64?
    
    func getVolume() -> Int64 {
        var volArray = [Int64]()
        for set in allSets[0] {
            let vol = Int64(set.reps) * Int64(set.weight)
            volArray.append(Int64(vol))
        }
        let sum = volArray.reduce(0, +)
        return sum
    }
  
    
    let totalVolume: UILabel = {
        let displayString = UILabel()
        displayString.textColor = .white
        displayString.translatesAutoresizingMaskIntoConstraints = false
        return displayString
    }()
    
    func setupUI() {
        view.addSubview(weightLabel)
        weightLabel.backgroundColor = .custBlue
        weightLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        weightLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        weightLabel.widthAnchor.constraint(equalToConstant: 115).isActive = true
        weightLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        weightLabel.font = UIFont.boldSystemFont(ofSize: 30)
        
        view.addSubview(weightTextField)
        weightTextField.backgroundColor = .white
        weightTextField.topAnchor.constraint(equalTo: weightLabel.topAnchor).isActive = true
        weightTextField.leftAnchor.constraint(equalTo: weightLabel.rightAnchor).isActive = true
        weightTextField.widthAnchor.constraint(equalToConstant: 90).isActive = true
        weightTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        weightTextField.font = UIFont.boldSystemFont(ofSize: 45)
        
        view.addSubview(repsLabel)
        repsLabel.backgroundColor = .custBlue
        repsLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        repsLabel.leftAnchor.constraint(equalTo: weightTextField.rightAnchor, constant: 0).isActive = true
        repsLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        repsLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        repsLabel.font = UIFont.boldSystemFont(ofSize: 30)

        view.addSubview(repsTextField)
        repsTextField.backgroundColor = .white
        repsTextField.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        repsTextField.leftAnchor.constraint(equalTo: repsLabel.rightAnchor, constant: 0).isActive = true
        repsTextField.widthAnchor.constraint(equalToConstant: 65).isActive = true
        repsTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        repsTextField.font = UIFont.boldSystemFont(ofSize: 45)
        
        view.addSubview(fillLabel)
        fillLabel.backgroundColor = .custBlue
        fillLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        fillLabel.leftAnchor.constraint(equalTo: repsTextField.rightAnchor, constant: 0).isActive = true
        fillLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        fillLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(totalVolume)
        totalVolume.backgroundColor = .custBlue
        totalVolume.topAnchor.constraint(equalTo: weightLabel.bottomAnchor).isActive = true
        totalVolume.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        totalVolume.widthAnchor.constraint(equalToConstant: 400).isActive = true
        totalVolume.heightAnchor.constraint(equalToConstant: 50).isActive = true
        totalVolume.font = UIFont.boldSystemFont(ofSize: 30)
        totalVolume.textAlignment = .center
        let volume = getVolume()
        totalVolume.text = "Total Volume -- \(volume)"
        
    }
    
}
