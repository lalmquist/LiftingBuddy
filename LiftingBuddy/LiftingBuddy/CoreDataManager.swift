//
//  CoreDataManager.swift
//  LiftingBuddy
//
//  Created by Logman on 6/2/19.
//  Copyright © 2019 Logman. All rights reserved.
//a

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager() // will live forever as long as your application is still alive, it's properties will too
    
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
            return workouts
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
    
//    func fetchSets() -> [Set] {
//        let context = persistentContainer.viewContext
//        
//        let fetchRequest = NSFetchRequest<Set>(entityName: "Set")
//        do {
//            let sets = try context.fetch(fetchRequest)
//            return sets
//        } catch let fetchErr {
//            print("Failed to fetch sets:", fetchErr)
//            return []
//        }
//    }
    
    func createSet(setReps: Int16, setWeight: Int16) -> (Set?, Error?) {
        let context = persistentContainer.viewContext
        let set = NSEntityDescription.insertNewObject(forEntityName: "Set", into: context) as! Set
        
        set.reps = setReps
        set.weight = setWeight
        set.setValue(setReps, forKey: "reps")
        set.setValue(setWeight, forKey: "weight")
        
        do {
            try context.save()
            // save succeeds
            return (set, nil)
        } catch let err {
            print("Failed to create set:", err)
            return (nil, err)
        }
    }
    
    func createExercise(exerciseName: String, workout: Workout) -> (Exercise?, Error?) {
        let context = persistentContainer.viewContext
        
        //create an exercise
        let exercise = NSEntityDescription.insertNewObject(forEntityName: "Exercise", into: context) as! Exercise
        
        exercise.workout = workout
//        exercise.set = set

//        employee.type = employeeType
        
        // lets check company is setup correctly
        //        let company = Company(context: context)
        //        company.employees
        //
        //        employee.company
        
        exercise.setValue(exerciseName, forKey: "name")
        
//        tuple = (exercise, set)
        
//        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
        
//        employeeInformation.taxId = "456"
//        employeeInformation.birthday = birthday
        
        //        employeeInformation.setValue("456", forKey: "taxId")
        
//        employee.employeeInformation = employeeInformation
        
        do {
            try context.save()
            // save succeeds
            return (exercise, nil)
        } catch let err {
            print("Failed to create exercise:", err)
            return (nil, err)
        }
        
    }
    
}









