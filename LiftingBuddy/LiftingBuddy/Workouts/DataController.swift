//
//  DataController.swift
//  LiftingBuddy
//
//  Created by Logman on 7/30/19.
//  Copyright © 2019 Logman. All rights reserved.
//

import UIKit
import CoreData

class DataController: UITableViewController {
    
    var workout: Workout?
    
    var allExerciseNames = [String]()
    
    func getAllExercises() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Workout>(entityName: "Workout")
        do {
            
            let workouts = try context.fetch(fetchRequest)
            
            for lifts in workouts {
                guard let workoutExercises = lifts.exercise?.allObjects as? [Exercise] else { return }
                for exer in workoutExercises {
                    
                    if (allExerciseNames.contains(exer.name ?? "")) {

                    } else {

                        allExerciseNames.append(exer.name ?? "")
                    }
                }
            }
        } catch let fetchErr {
            print("Failed to fetch exercises:", fetchErr)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAllExercises()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Previous Exercises"
        navigationController?.navigationBar.backgroundColor = .darkPurple
        
        setupCancelButton()
        
        getAllExercises()
        
        allExerciseNames = allExerciseNames.sorted{$0 < $1}
        
        tableView.backgroundColor = UIColor.black
        
        tableView.indicatorStyle = .white
        

        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
            
    }
    
    private func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        cell.textLabel?.text = allExerciseNames[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        return label
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allExerciseNames.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let exerciseStr = allExerciseNames[indexPath.row]
        
        let detailDataController = DetailDataController()
        
        detailDataController.exerciseStr = exerciseStr
        
        navigationController?.pushViewController(detailDataController, animated: true)

    }

    
}
