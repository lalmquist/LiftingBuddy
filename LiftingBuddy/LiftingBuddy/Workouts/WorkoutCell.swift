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
            nameFoundedDateLabel.text = workout?.name
            
//            if let imageData = company?.imageData {
//                companyImageView.image = UIImage(data: imageData)
//            }
            
            if let name = workout?.name, let founded = workout?.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                let foundedDateString = dateFormatter.string(from: founded)
                let dateString = "\(name) - \(foundedDateString)"
                nameFoundedDateLabel.text = dateString
            } else {
                nameFoundedDateLabel.text = workout?.name
                
//                nameFoundedDateLabel.text = "\(workout?.name ?? "") \(company?.numEmployees ?? "")"
            }
        }
    }
    //a
    // you cannot declare another image view using "imageView"
//    let companyImageView: UIImageView = {
//        let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
//        imageView.contentMode = .scaleAspectFill
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.layer.cornerRadius = 20
//        imageView.clipsToBounds = true
//        imageView.layer.borderColor = UIColor.darkBlue.cgColor
//        imageView.layer.borderWidth = 1
//        return imageView
//    }()
    
    let nameFoundedDateLabel: UILabel = {
        let label = UILabel()
        label.text = "WORKOUT NAME"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.black
        
//        addSubview(companyImageView)
//        companyImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        companyImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        companyImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
//        companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(nameFoundedDateLabel)
        nameFoundedDateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        nameFoundedDateLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameFoundedDateLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        nameFoundedDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
