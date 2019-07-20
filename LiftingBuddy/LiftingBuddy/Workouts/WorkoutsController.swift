//
//  WorkoutsController.swift
//  LiftingBuddy
//
//  Created by Logman on 6/2/19.
//  Copyright © 2019 Logman. All rights reserved.
//a

import UIKit
import CoreData

class WorkoutsController: UITableViewController {
    
    var workouts = [Workout]()
//    var sortedWorkouts = [Workout]()
    
    @objc private func doWork() {
        print("Trying to do work...")
        
        CoreDataManager.shared.persistentContainer.performBackgroundTask({ (backgroundContext) in
            
            (0...5).forEach { (value) in
                print(value)
                let workout = Workout(context: backgroundContext)
                workout.name = String(value)
            }
            
            do {
                try backgroundContext.save()
                
                DispatchQueue.main.async {
                    self.workouts = CoreDataManager.shared.fetchWorkouts()
                    self.tableView.reloadData()
                }
                
            } catch let err {
                print("Failed to save:", err)
            }
            
        })
        
        // GCD - Grand Central Dispatch
        
        DispatchQueue.global(qos: .background).async {
            
            
            
            // creating some Company objects on a background thread
            
            //            let context = CoreDataManager.shared.persistentContainer.viewContext
            
            //NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        }
        
    }
    
    // let's do some tricky updates with core data
    @objc private func doUpdates() {
        print("Trying to update companies on a background context")
        
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            
            let request: NSFetchRequest<Workout> = Workout.fetchRequest()
            
            do {
                let workouts = try backgroundContext.fetch(request)
                
                workouts.forEach({ (workout) in
                    print(workout.name ?? "")
                    workout.name = "C: \(workout.name ?? "")"
                })
                
                do {
                    try backgroundContext.save()
                    
                    // let's try to update the UI after a save
                    DispatchQueue.main.async {
                        
                        // reset will forget all of the objects you've fetch before
                        CoreDataManager.shared.persistentContainer.viewContext.reset()
                        
                        // you don't want to refetch everything if you're just simply update one or two companies
                        
                        self.workouts = CoreDataManager.shared.fetchWorkouts()
                        
                        // is there a way to just merge the changes that you made onto the main view context?
                        
                        self.tableView.reloadData()
                    }
                    
                } catch let saveErr {
                    print("Failed to save on background:", saveErr)
                }
                
            } catch let err {
                print("Failed to fetch companies on background:", err)
            }
            
            
            
        }
    }
    
    @objc private func doNestedUpdates() {
        print("Trying to perform nested updates now...")
        
        DispatchQueue.global(qos: .background).async {
            // we'll try to perform our updates
            
            // we'll first construct a custom MOC
            
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            
            privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
            
            // execute updates on privateContext now
            
            let request: NSFetchRequest<Workout> = Workout.fetchRequest()
            request.fetchLimit = 1
            
            do {
                
                let workouts = try privateContext.fetch(request)
                
                workouts.forEach({ (workout) in
                    print(workout.name ?? "")
                    workout.name = "D: \(workout.name ?? "")"
                })
                
                do {
                    try privateContext.save()
                    
                    // after save succeeds
                    
                    DispatchQueue.main.async {
                        
                        do {
                            let context = CoreDataManager.shared.persistentContainer.viewContext
                            
                            if context.hasChanges {
                                try context.save()
                            }
                            self.tableView.reloadData()
                            
                        } catch let finalSaveErr {
                            print("Failed to save main context:", finalSaveErr)
                        }
                        
                    }
                    
                } catch let saveErr {
                    print("Failed to save on private context:", saveErr)
                }
                
                
            } catch let fetchErr {
                print("Failed to fetch on private context:", fetchErr)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.workouts = CoreDataManager.shared.fetchWorkouts()
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        
        view.backgroundColor = .white
        
        navigationItem.title = "Workouts"
        
        tableView.backgroundColor = UIColor.black
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView() // blank UIView
        
        tableView.indicatorStyle = .white
        
        tableView.register(WorkoutCell.self, forCellReuseIdentifier: "cellId")
        
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        workouts = self.workouts.sorted(by: {$0.date!.compare($1.date!) == .orderedDescending})
//        self.workouts = CoreDataManager.shared.fetchWorkouts()
//        tableView.register(WorkoutCell.self, forCellReuseIdentifier: "cellId")
    }
    
    @objc private func handleReset() {
        print("Attempting to delete all core data objects")
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Workout.fetchRequest())
        
        do {
            try context.execute(batchDeleteRequest)
            
            // upon deletion from core data succeeded
            
            var indexPathsToRemove = [IndexPath]()
            
            for (index, _) in workouts.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            workouts.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .left)
            
        } catch let delErr {
            print("Failed to delete objects from Core Data:", delErr)
        }
        
    }
    
    @objc func handleAddCompany() {
        print("Adding company..")
        
        let createWorkoutController = CreateWorkoutController()
        //        createCompanyController.view.backgroundColor = .green
        
        let navController = CustomNavigationController(rootViewController: createWorkoutController)
        
        createWorkoutController.delegate = self
        
        present(navController, animated: true, completion: nil)
        
    }
    
}

