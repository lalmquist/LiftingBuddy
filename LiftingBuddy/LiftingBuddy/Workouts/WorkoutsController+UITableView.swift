//
//  WorkoutsController+UITableView.swift
//  LiftingBuddy
//
//  Created by Logman on 6/2/19.
//  Copyright © 2019 Logman. All rights reserved.
//a

import UIKit

extension WorkoutsController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        sortedWorkouts = workouts.sorted(by: {$0.date!.compare($1.date!) == .orderedDescending})
        let workout = workouts[indexPath.row]
        let exercisesController = ExercisesController()
        exercisesController.workout = workout
        navigationController?.pushViewController(exercisesController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
//            self.Workouts = self.workouts.sorted(by: {$0.date!.compare($1.date!) == .orderedDescending})
            let workout = self.workouts[indexPath.row]
            print("Attempting to delete workout:", workout.name ?? "")
            
            self.workouts.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // delete the company from Core Data
            let context = CoreDataManager.shared.persistentContainer.viewContext
            
            context.delete(workout)
            
            do {
                try context.save()
            } catch let saveErr {
                print("Failed to delete workout:", saveErr)
            }
        }
        deleteAction.backgroundColor = UIColor.lightRed
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandlerFunction)
        editAction.backgroundColor = UIColor.darkBlue
        
        return [deleteAction, editAction]
    }
    
    private func editHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        print("Editing company in separate function")
        
        let editWorkoutController = CreateWorkoutController()
        editWorkoutController.delegate = self
        editWorkoutController.workout = workouts[indexPath.row]
        let navController = CustomNavigationController(rootViewController: editWorkoutController)
        present(navController, animated: true, completion: nil)
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
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView()
//        view.backgroundColor = .lightBlue
//        return view
//    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! WorkoutCell
//        sortedWorkouts = workouts.sorted(by: {$0.date!.compare($1.date!) == .orderedDescending})
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

