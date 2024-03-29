//
//  WorkoutsController+UITableView.swift
//  LiftingBuddy
//
//  Created by Logman on 6/2/19.
//  Copyright © 2019 Logman. All rights reserved.
//

import UIKit
import CoreData

extension WorkoutsController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let workout = workouts[indexPath.row]
        let exercisesController = ExercisesController()
        exercisesController.workout = workout
        navigationController?.pushViewController(exercisesController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in

            let deleteAlert = UIAlertController(title: "Delete Workout?", message: "", preferredStyle: UIAlertController.Style.alert)
            self.present(deleteAlert, animated: true, completion: nil)
            
            deleteAlert.addAction(UIAlertAction(title:"Ok", style: .destructive, handler: {(action: UIAlertAction!) in
                print("handle ok logic")
                
                let workout = self.workouts[indexPath.row]
                print("Attempting to delete workout:", workout.name ?? "")
                
                self.workouts.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .middle)
                
                // delete the company from Core Data
                let context = CoreDataManager.shared.persistentContainer.viewContext
                
                context.delete(workout)
                
                do {
                    try context.save()
                } catch let saveErr {
                    print("Failed to delete workout:", saveErr)
                }
            
            }))
            
            deleteAlert.addAction(UIAlertAction(title:"Cancel", style: .default, handler: {(action: UIAlertAction!) in
                print("handle cancel logic")
            }))
        }
        
        deleteAction.backgroundColor = UIColor.lightRed
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandlerFunction)
        editAction.backgroundColor = UIColor.darkBlue
        
        let copyAction = UITableViewRowAction(style: .normal, title: "Copy", handler: copyHandlerFunction)
        copyAction.backgroundColor = UIColor.blue
        
        return [deleteAction, editAction, copyAction]
    }
    
    private func editHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        print("Editing company in separate function")
        
        let editWorkoutController = CreateWorkoutController()
        editWorkoutController.delegate = self
        editWorkoutController.workout = workouts[indexPath.row]
        let navController = CustomNavigationController(rootViewController: editWorkoutController)
        present(navController, animated: true, completion: nil)
    }
    
    private func copyHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        print("copying")
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
            
        let workout = NSEntityDescription.insertNewObject(forEntityName: "Workout", into: context)
        
        let name = workouts[indexPath.row].name
            
        workout.setValue(name, forKey: "name")
        workout.setValue(Date(), forKey: "date")
        
        guard let workoutExercises = workouts[indexPath.row].exercise?.allObjects as? [Exercise] else { return }
        var allExercises = [] as [Exercise]
        
        allExercises = workoutExercises
        allExercises.sort {
            $0.index < $1.index
        }

        for lifts in allExercises {
            print(lifts.index)
            let exerciseName = lifts.name ?? "nil"

            let tuple = CoreDataManager.shared.createExercise(exerciseName: exerciseName, inpIndex: lifts.index, workout: workout as! Workout)

                if let error = tuple.1 {
                    print(error)
                } else {
                }
        }
        do {
            try context.save()
            didAddWorkout(workout: workout as! Workout)
            
        } catch let saveErr {
            print("Failed to save workout:", saveErr)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No workouts recorded..."
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return workouts.count == 0 ? 150 : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! WorkoutCell

        let workout = workouts[indexPath.row]
        cell.workout = workout
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
}

