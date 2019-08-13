//
//  WorkoutsController+CreateWorkout.swift
//  LiftingBuddy
//
//  Created by Logman on 6/2/19.
//  Copyright © 2019 Logman. All rights reserved.
//

import UIKit

extension WorkoutsController: CreateWorkoutControllerDelegate {
    
    func didEditWorkout(workout: Workout) {
        let row = workouts.firstIndex(of: workout)
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }
    
    
    func didAddWorkout(workout: Workout) {
        workouts.append(workout)
        let newIndexPath = IndexPath(row: workouts.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        
        tableView.reloadData()
        workouts = self.workouts.sorted(by: {$0.date!.compare($1.date!) == .orderedDescending})
    }

}
