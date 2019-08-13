//
//  CoreDataManager.swift
//  LiftingBuddy
//
//  Created by Logman on 6/2/19.
//  Copyright © 2019 Logman. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
    
    func fetchWorkouts() -> [Workout] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Workout>(entityName: "Workout")
        do {
            let workouts = try context.fetch(fetchRequest)
            let sortedWorkouts = workouts.sorted(by: {$0.date!.compare($1.date!) == .orderedDescending})
            return sortedWorkouts
        } catch let fetchErr {
            print("Failed to fetch workouts:", fetchErr)
            return []
        }
    }
    func fetchExercises() -> [Exercise] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Exercise>(entityName: "Exercise")
        do {
            let exercises = try context.fetch(fetchRequest)
            return exercises
        } catch let fetchErr {
            print("Failed to fetch exercises:", fetchErr)
            return []
        }
    }
    
    func createSet(setReps: Int64, setWeight: Int64) -> (Set?, Error?) {
        let context = persistentContainer.viewContext
        let set = NSEntityDescription.insertNewObject(forEntityName: "Set", into: context) as! Set
        
        set.reps = setReps
        set.weight = setWeight
        set.setValue(setReps, forKey: "reps")
        set.setValue(setWeight, forKey: "weight")

        
        do {
            try context.save()
            return (set, nil)
        } catch let err {
            print("Failed to create set:", err)
            return (nil, err)
        }
    }
    
    
    func createExercise(exerciseName: String, inpIndex: Int16, workout: Workout) -> (Exercise?, Error?) {
        let context = persistentContainer.viewContext

        let exercise = NSEntityDescription.insertNewObject(forEntityName: "Exercise", into: context) as! Exercise
        
        exercise.workout = workout
        
        exercise.setValue(exerciseName, forKey: "name")
        exercise.setValue(inpIndex, forKey: "index")

        do {
            try context.save()

            return (exercise, nil)
        } catch let err {
            print("Failed to create exercise:", err)
            return (nil, err)
        }
        
    }
    
}
