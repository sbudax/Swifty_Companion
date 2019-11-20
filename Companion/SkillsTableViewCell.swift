//
//  SkillsTableViewCell.swift
//  Companion
//
//  Created by Sbusiso XABA on 2019/11/06.
//  Copyright © 2019 Sbusiso XABA. All rights reserved.
//

import UIKit

class SkillsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var skillsPercentageLabel: UILabel!
    @IBOutlet weak var skillsProgressBar: UIProgressView!

   
    
 var skill : (Skills)? {
     didSet {
         if let s = skill {
             skillsLabel?.text = s.name
             skillsPercentageLabel?.text = String(s.level)
             skillsProgressBar?.progress = Float(s.level) - Float(Int(s.level))
         }
     }
 }

}
