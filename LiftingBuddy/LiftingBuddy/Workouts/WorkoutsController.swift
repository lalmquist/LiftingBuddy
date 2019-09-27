//
//  WorkoutsController.swift
//  LiftingBuddy
//
//  Created by Logman on 6/2/19.
//  Copyright © 2019 Logman. All rights reserved.
//

import UIKit
import CoreData

class WorkoutsController: UITableViewController {
    
    var workouts = [Workout]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.workouts = CoreDataManager.shared.fetchWorkouts()
        
        view.backgroundColor = .white
        
        navigationItem.title = "Workouts"
        UINavigationBar.appearance().barTintColor = .darkPurple
        
        tableView.backgroundColor = UIColor.black
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        
        tableView.indicatorStyle = .white
        
        tableView.register(WorkoutCell.self, forCellReuseIdentifier: "cellId")
        
        setupPlusButtonInNavBar(selector: #selector(handleAddExercise))
        setupDataButtonInNavBar(selector: #selector(openData))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        workouts = self.workouts.sorted(by: {$0.date!.compare($1.date!) == .orderedDescending})
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    @objc func handleAddExercise() {
        print("Adding exercise..")
        
        let createWorkoutController = CreateWorkoutController()
        
        let navController = CustomNavigationController(rootViewController: createWorkoutController)
        
        createWorkoutController.delegate = self
        
        present(navController, animated: true, completion: nil)
        
    }
    
    @objc func openData() {
        print("OpeningData..")
        
        let dataController = DataController()
        
        let navController = UINavigationController(rootViewController: dataController)
        
        present(navController, animated: true, completion: nil)
        
    }
    
}

