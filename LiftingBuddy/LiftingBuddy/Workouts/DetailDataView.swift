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
    
    var found_index: Int?
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        navigationItem.title = exerciseStr
        
        setupCancelButton()
        
        setupUI()
        
    }
    
    let bestSetLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let setLine: UIView = {
        let label = UIView()
        label.backgroundColor = .orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bestWorkoutLabel: UILabel = {
        let label = UILabel()
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
                        
                        guard let lookUpSets = exer.set?.allObjects as? [Set] else { return [0]}
                        let sortedSets = lookUpSets.sorted(by: {$0.index < $1.index})
                        
                        for items in sortedSets {
                            results.append(items.weight)
                            results.append(items.reps)
                        }
                    }
                }
            }

        } catch let fetchErr {
            print("Failed to fetch workouts:", fetchErr)
            return results
        }
        return results
    }
    
    func getDate(findIndex: Int) -> String {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        var resultsDate = Date()
        var index : Int64 = 0
        
        let fetchRequest = NSFetchRequest<Workout>(entityName: "Workout")
        do {
            
            let workouts = try context.fetch(fetchRequest)
            let sortedWorkouts = workouts.sorted(by: {$0.date!.compare($1.date!) == .orderedDescending})
            
            for lifts in sortedWorkouts {
                
                guard let workoutExercises = lifts.exercise?.allObjects as? [Exercise] else { return ""}
                
                for exer in workoutExercises {
                    if exer.name == exerciseStr {
                        
                        guard let lookUpSets = exer.set?.allObjects as? [Set] else { return ""}
                        let sortedSets = lookUpSets.sorted(by: {$0.index < $1.index})
                        
                        for items in sortedSets {
                            if index == findIndex {
                                resultsDate = lifts.date!
                            } else {
                                
                            }
                        
                            index = index + 1
                            
                        }
                    }
                }
            }
            
        
            
        } catch let fetchErr {
            print("Failed to fetch workouts:", fetchErr)
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let formattedDatestring = dateFormatter.string(from: resultsDate)
        
        return formattedDatestring
    }
    
    func findBestSet (dataSet: [Int64]) -> String {
        
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
        var foundIndex = 0
        
        for items in setVolume {
            
            if items == maxVolume {
                foundIndex = j
                
            } else {
                j = j + 1
            }
        }
        
        let dataSetIndex = foundIndex * 2
        
        returnResults.append(dataSet[dataSetIndex])
        returnResults.append(dataSet[dataSetIndex + 1])
        
        let total = returnResults[0]*returnResults[1]
        
        let finalString = String(returnResults[0]) + " x " + String(returnResults[1]) + " -- Total: " + String(total) + " lbs"
        
        found_index = foundIndex
        
        return finalString
        
    }
    
    private func setupUI() {
        
        
        let dataset = getLastExerciseData()
        let bestSet = findBestSet(dataSet: dataset)
        let bestSetDate = getDate(findIndex: found_index!)

        view.addSubview(bestSetLabel)
        bestSetLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bestSetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bestSetLabel.textAlignment = .center
        bestSetLabel.text = "Your best set:\n\(bestSetDate)\n\(bestSet)"
        
        view.addSubview(setLine)
        setLine.topAnchor.constraint(equalTo: bestSetLabel.bottomAnchor, constant: 5).isActive = true
        setLine.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        setLine.widthAnchor.constraint(equalToConstant: view.frame.width/1.1).isActive = true
        setLine.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        view.addSubview(bestWorkoutLabel)
        bestWorkoutLabel.topAnchor.constraint(equalTo: setLine.bottomAnchor).isActive = true
        bestWorkoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bestWorkoutLabel.text = "Your best workout:\nDATA HERE"
        
    }
    
}

