//
//  WorkoutController.swift
//  LiftingBuddy
//
//  Created by Logman on 6/2/19.
//  Copyright © 2019 Logman. All rights reserved.
//

import UIKit

class WorkoutCell: UITableViewCell {
    
    var workout: Workout? {
        didSet {
            
            let numExercises = workout?.exercise?.count
            
            var impCount = 0
            var doneBeforeCnt = 0
            
            for workoutExercises in workout!.exercise! {
                if (workoutExercises as! Exercise).improved == true {
                    impCount = impCount + 1
                }
                if (workoutExercises as! Exercise).donebefore == true {
                    doneBeforeCnt = doneBeforeCnt + 1
                }
            }
            
            if doneBeforeCnt > 0 {
                improvedLabel.text = "\(impCount)/\(doneBeforeCnt) ✅"
            } else {
                improvedLabel.text = ""
            }
            
            
            nameFoundedDateLabel.text = workout?.name
            
            if numExercises == 1 {
                NumExercisesLabel.text = "\(numExercises ?? 0) Exercise"
                NumExercisesLabel.textColor = .white
            } else if numExercises == 0 {
                NumExercisesLabel.text = "No Exercises"
                NumExercisesLabel.textColor = .orange
            } else {
                NumExercisesLabel.text = "\(numExercises ?? 0) Exercises"
                NumExercisesLabel.textColor = .white
            }
            
            if let name = workout?.name, let founded = workout?.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                let foundedDateString = dateFormatter.string(from: founded)
                let dateString = "\(name) - \(foundedDateString)"
                nameFoundedDateLabel.text = dateString
            } else {
                nameFoundedDateLabel.text = workout?.name
            }
        }
    }
    
    let NumExercisesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameFoundedDateLabel: UILabel = {
        let label = UILabel()
        label.text = "WORKOUT NAME"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let improvedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.black
        
        addSubview(nameFoundedDateLabel)
        nameFoundedDateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        nameFoundedDateLabel.topAnchor.constraint(equalTo: topAnchor, constant: -35).isActive = true
        nameFoundedDateLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        nameFoundedDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(NumExercisesLabel)
        NumExercisesLabel.leftAnchor.constraint(equalTo: nameFoundedDateLabel.leftAnchor).isActive = true
        NumExercisesLabel.topAnchor.constraint(equalTo: nameFoundedDateLabel.bottomAnchor, constant: -45).isActive = true
        
        addSubview(improvedLabel)
        improvedLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        improvedLabel.topAnchor.constraint(equalTo: nameFoundedDateLabel.bottomAnchor, constant: -45).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
