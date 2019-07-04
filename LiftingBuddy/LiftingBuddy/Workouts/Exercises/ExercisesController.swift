//
//  ExercisesController.swift
//  LiftingBuddy
//
//  Created by Logman on 6/2/19.
//  Copyright © 2019 Logman. All rights reserved.
//a

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
    
    func didAddExercise(exercise: Exercise) {

        let row = allExercises.count
        
        let insertionIndexPath = IndexPath(row: row, section: 0)
        
        allExercises.append(exercise)
        
        tableView.insertRows(at: [insertionIndexPath], with: .middle)
    }
    
    var workout: Workout?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = workout?.name
    }
    var allExercises = [Exercise]()
    
    private func fetchExercises() {
        guard let workoutExercises = workout?.exercise?.allObjects as? [Exercise] else { return }
        allExercises = []
        allExercises = workoutExercises
        allExercises.sort {
            $0.index < $1.index
        }

    }
    func updateExerciseIndex(exercise: Exercise, intIndex: Int16) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        exercise.index = intIndex
        
        do {
            try context.save()
            // save succeeds
            
        } catch let err {
            print("Failed to update exercise:", err)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ExerciseCell
        let exercise = allExercises[indexPath.row]
        let inpIndex = Int16(indexPath.row)
        
//        let numSets = exercise.set?.count
        
//        cell.textLabel?.text = "\(exercise.name ?? "") -- \(numSets ?? 0) Sets"
//        cell.backgroundColor = UIColor.black
//        cell.textLabel?.textColor = .white
//        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 35)
        
        updateExerciseIndex(exercise: exercise, intIndex: inpIndex)
        
        cell.exercise = exercise
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let exercise = allExercises[indexPath.row]
        let setController = SetController()
        setController.exercise = exercise
        navigationController?.pushViewController(setController, animated: true)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allExercises.count
    }
    
    let cellId = "cellllllllllllId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchExercises()
//        self.allExercises = CoreDataManager.shared.fetchExercises()
        
        tableView.backgroundColor = UIColor.black
        
        tableView.register(ExerciseCell.self, forCellReuseIdentifier: cellId)
        
        setupPlusButtonInNavBar(selector: #selector(handleAdd))

    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    @objc private func handleAdd() {
        print("Trying to add an exercise..")
        
        let createExerciseController = CreateExerciseController()
        createExerciseController.delegate = self
        createExerciseController.workout = workout
        let navController = UINavigationController(rootViewController: createExerciseController)
        present(navController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            let exercise = self.allExercises[indexPath.row]
            print("Attempting to delete exercise:", exercise.name ?? "")
            
            print(indexPath.row)
            self.allExercises.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
//            self.tableView.deleteSections([indexPath.section], with: .automatic)
            
            // delete the company from Core Data
            let context = CoreDataManager.shared.persistentContainer.viewContext
            
            context.delete(exercise)
            
            do {
                try context.save()
            } catch let saveErr {
                print("Failed to delete exercise:", saveErr)
            }
        }
        deleteAction.backgroundColor = UIColor.lightRed
    
        return [deleteAction]
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}







