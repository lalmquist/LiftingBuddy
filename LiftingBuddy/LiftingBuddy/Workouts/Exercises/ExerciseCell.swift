//
//  ExerciseCell.swift
//  LiftingBuddy
//
//  Created by Logman on 6/16/19.
//  Copyright © 2019 Logman. All rights reserved.
//

import UIKit

class ExerciseCell: UITableViewCell {
    
    var exercise: Exercise? {
        didSet {
            let numSets = exercise?.set?.count
            if numSets == 1 {
                nameFoundedDateLabel.text = "\(exercise?.name ?? "")"
                setLabel.text = "\(numSets ?? 0) Set"
                setLabel.textColor = .white
            } else if numSets == 0 {
                nameFoundedDateLabel.text = "\(exercise?.name ?? "")"
                setLabel.text = "No Sets"
                setLabel.textColor = .orange
            } else {
            nameFoundedDateLabel.text = "\(exercise?.name ?? "")"
            setLabel.text = "\(numSets ?? 0) Sets"
            setLabel.textColor = .white
            }
            improvedLabel.text = "✅"
            if exercise?.improved == true {
                improvedLabel.isHidden = false
            } else {
                improvedLabel.isHidden = true
            }
        }
        }
    
    let nameFoundedDateLabel: UILabel = {
        let label = UILabel()
//        label.text = "WORKOUT NAME"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
//        label.backgroundColor = .yellow
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let setLabel: UILabel = {
        let label = UILabel()
//        label.text = "WORKOUT NAME"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .white
//        label.backgroundColor = .yellow
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let improvedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
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
        
        addSubview(setLabel)
        setLabel.leftAnchor.constraint(equalTo: nameFoundedDateLabel.leftAnchor, constant: 0).isActive = true
        setLabel.topAnchor.constraint(equalTo: nameFoundedDateLabel.bottomAnchor, constant: -45).isActive = true
        setLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        setLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(improvedLabel)
        improvedLabel.topAnchor.constraint(equalTo: nameFoundedDateLabel.bottomAnchor, constant: -45).isActive = true
        improvedLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        improvedLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



