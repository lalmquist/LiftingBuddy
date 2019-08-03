//
//  DetailDataView.swift
//  LiftingBuddy
//
//  Created by Logman on 7/30/19.
//  Copyright © 2019 Logman. All rights reserved.
//

import UIKit
import CoreData

class DetailDataController: UIViewController {
    
    var exerciseStr: String?
    
    var lastDate: Date?
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        navigationItem.title = exerciseStr
        
        setupCancelButton()
        
        let dataset = getLastExerciseData()
        
        findBestSet(dataSet: dataset)
        
        setupUI()
        
    }
    
    let bestSetLabel: UILabel = {
        let label = UILabel()
        label.text = "BEST SET HERE"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let best1RMLabel: UILabel = {
        let label = UILabel()
        label.text = "BEST 1 REP MAX HERE"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bestWorkoutLabel: UILabel = {
        let label = UILabel()
        label.text = "BEST WORKOUT HERE"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func getLastExerciseData() -> [Int64] {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        var results = [Int64]()
        
        let fetchRequest = NSFetchRequest<Workout>(entityName: "Workout")
        do {
            
            let workouts = try context.fetch(fetchRequest)
            let sortedWorkouts = workouts.sorted(by: {$0.date!.compare($1.date!) == .orderedDescending})
            
            for lifts in sortedWorkouts {

                guard let workoutExercises = lifts.exercise?.allObjects as? [Exercise] else { return [0]}

                for exer in workoutExercises {
                    if exer.name == exerciseStr {
//                        print("this")
                        
                        guard let lookUpSets = exer.set?.allObjects as? [Set] else { return [0]}
                        let sortedSets = lookUpSets.sorted(by: {$0.index < $1.index})
                        
                        for items in sortedSets {
                            results.append(items.weight)
                            results.append(items.reps)
                        }
                        
                    }
                }
            }
            
            print(results)

        } catch let fetchErr {
            print("Failed to fetch workouts:", fetchErr)
            return results
        }
        return results
    }
    
    func findBestSet (dataSet: [Int64]) -> [Int64] {
        
        var i = 0
        var setVolume = [Int64]()
        
        var returnResults = [Int64]()
        
        if dataSet.count > 1 {
            while i < dataSet.count {
                
                let volumeData = dataSet[i] * dataSet[i+1]
                setVolume.append(volumeData)
                
                i = i + 2
            }
        } else {
            
        }
        
        let maxVolume = setVolume.max()
        
        var j = 0
        
        for items in setVolume {
            
            if items == maxVolume {
                
            } else {
                j = j + 1
            }
        }
        
        let dataSetIndex = j*2
        
        returnResults.append(dataSet[dataSetIndex])
        returnResults.append(dataSet[dataSetIndex + 1])
        
        print(returnResults)
        
        return returnResults
        
    }
    
    private func setupUI() {
        
        view.addSubview(bestSetLabel)
        bestSetLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bestSetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(best1RMLabel)
        best1RMLabel.topAnchor.constraint(equalTo: bestSetLabel.bottomAnchor).isActive = true
        best1RMLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(bestWorkoutLabel)
        bestWorkoutLabel.topAnchor.constraint(equalTo: best1RMLabel.bottomAnchor).isActive = true
        bestWorkoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
}

