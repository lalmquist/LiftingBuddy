//
//  ExercisesController.swift
//  LiftingBuddy
//
//  Created by Logman on 6/2/19.
//  Copyright © 2019 Logman. All rights reserved.
//

import UIKit
import CoreData

// lets create a UILabel subclass for custom text drawing
class IndentedLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = rect.inset(by: insets)
        super.drawText(in: customRect)
    }
    
}

class ExercisesController: UITableViewController, CreateExerciseControllerDelegate {
    
    // remember this is called when we dismiss employee creation
    func didAddExercise(exercise: Exercise) {
        //        fetchEmployees()
        //        tableView.reloadData()
        
        // what is the insertion index path?
        
//        guard let section = employeeTypes.index(of: employee.type!) else { return }
        
        // what is my row?
        let section = 0
        
        let row = allExercises[section].count
        
        let insertionIndexPath = IndexPath(row: row, section: section)
        
        allExercises[section].append(exercise)
        
        tableView.insertRows(at: [insertionIndexPath], with: .middle)
    }
    
    var workout: Workout?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = workout?.name
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        label.text = "employeeTypes[section]"
        label.backgroundColor = UIColor.lightBlue
        label.textColor = UIColor.darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    var allExercises = [[Exercise]]()
    
//    var employeeTypes = [
//        EmployeeType.Intern.rawValue,
//        EmployeeType.Executive.rawValue,
//        EmployeeType.SeniorManagement.rawValue,
//        EmployeeType.Staff.rawValue,
//    ]
    
    private func fetchExercises() {
        guard let workoutExercises = workout?.exercise?.allObjects as? [Exercise] else { return }
        
        allExercises = []
        // let's use my array and loop to filter instead
        
        allExercises.append(workoutExercises)
        
//        employeeTypes.forEach { (employeeType) in
        
            // somehow construct my allEmployees array
//            allExercises.append(workoutExercises)
//        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allExercises.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allExercises[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        print(indexPath.section)
        print(indexPath.row)
        print(allExercises)
        
        let exercise = allExercises[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = exercise.name
        
//        if let birthday = exercise.employeeInformation?.birthday {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "MMM dd, yyyy"
//
//            cell.textLabel?.text = "\(exercise.name ?? "")"
//        }
        
        //        if let taxId = employee.employeeInformation?.taxId {
        //            cell.textLabel?.text = "\(employee.name ?? "")    \(taxId)"
        //        }
        
        cell.backgroundColor = UIColor.tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let exercise = allExercises[indexPath.section][indexPath.row]
        let setController = SetController()
        setController.exercise = exercise
        navigationController?.pushViewController(setController, animated: true)
    }
    
    let cellId = "cellllllllllllId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchExercises()
        
        tableView.backgroundColor = UIColor.darkBlue
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        setupPlusButtonInNavBar(selector: #selector(handleAdd))

    }
    
    @objc private func handleAdd() {
        print("Trying to add an exercise..")
        
        let createExerciseController = CreateExerciseController()
        createExerciseController.delegate = self
        createExerciseController.workout = workout
        let navController = UINavigationController(rootViewController: createExerciseController)
        present(navController, animated: true, completion: nil)
    }
    
}







