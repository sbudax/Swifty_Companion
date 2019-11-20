//
//  ProjectsTableViewCell.swift
//  Companion
//
//  Created by Sbusiso XABA on 2019/11/08.
//  Copyright © 2019 Sbusiso XABA. All rights reserved.
//

import UIKit

class ProjectsTableViewCell: UITableViewCell {


    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var projectPercentageLabel: UILabel!

      
      var project : (Projects_users)?
      {
          didSet{
              if let s = project {
                  projectLabel.text = s.project?.name
                  projectPercentageLabel.text = String(s.final_mark)
              }
          }
      }

}
