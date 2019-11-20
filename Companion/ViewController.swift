//
//  ViewController.swift
//  Companion
//
//  Created by Sbusiso XABA on 2019/10/30.
//  Copyright © 2019 Sbusiso XABA. All rights reserved.
//

import UIKit
import JSONParserSwift
import SwiftyJSON


class ViewController: UIViewController {
    
    var baseRespons = [BaseResponse]()
    var cursusUsers = [Cursus_users]()
    var skills = [Skills]()
    var projectUsers = [Projects_users]()
    var projects = [Project]()
    
    var apiController: APIController = APIController()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var correctionLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var campusLabel: UILabel!
    @IBOutlet weak var mine: UIProgressView!
    
    
    var user: String?
    var deToken = ""
    var topicsBackup: [Dictionary<String,Any>]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.storeUserInfo()
        // Do any additional setup after loading the view.
    }
    
    func storeUserInfo(){
        print(" started saving user data")
        let json = Globals.jsonResponse!
        let skills = json["cursus_users"][0]["skills"]
        let projectUsers = json["project_users"]
        let cursusUsers = json["cursus_users"]
        
        /* Getting Cursus_users */
            for element in cursusUsers.arrayValue {
                self.cursusUsers.append(Cursus_users(element))
            }
            
            /* Getting Project_users */
            for element in projectUsers.arrayValue {
                self.projectUsers.append(Projects_users(element))
            }
            
            /* Getting the BaseResponds */
            self.baseRespons.append(BaseResponse(json))
            
            /* Getting Skills */
            for element in skills.arrayValue {
                self.skills.append(Skills(element))
            }
            
            DispatchQueue.main.async {
                _ = self.displayUserInfo (baseResbonse: self.baseRespons, cursusUsers: self.cursusUsers, skills: self.skills, projectUsers: self.projectUsers, project: self.projects)
            }
            
        }
        
        /* Display user info */
        func displayUserInfo(baseResbonse: [BaseResponse], cursusUsers: [Cursus_users], skills: [Skills], projectUsers: [Projects_users], project: [Project]) {
            
            /* Monkey tricks to chop off the 0 from '0.XX' */
            let str = String(Float((self.cursusUsers[0].level)) - Float(Int(self.cursusUsers[0].level)))
            let index = str.index(str.startIndex, offsetBy: 1) /* Start at index 1 '.XX' */
            let suffix = str[index...]
            
            DispatchQueue.main.async {
                self.userNameLabel.text = self.baseRespons[0].login
                self.phoneLabel.text = "0\(String(self.baseRespons[0].phone))"
                self.walletLabel.text = "Wallet: " + String(self.baseRespons[0].wallet)
                self.correctionLabel.text = "CPoints: " + String(self.baseRespons[0].correction_point)
                self.levelLabel.text = "Level: \(String(Int(self.cursusUsers[0].level)))\(suffix)%"
                self.mine.setProgress(Float((self.cursusUsers[0].level)) - Float(Int(self.cursusUsers[0].level)), animated: true)
                self.campusLabel.text = self.baseRespons[0].campus
                
                if let url = URL(string: self.baseRespons[0].image_url)
                {
                    self.imageView.layer.borderWidth = 2
                    self.imageView.layer.borderColor = UIColor.white.cgColor
                    self.imageView.layer.cornerRadius = self.imageView.layer.bounds.height / 2
                    self.imageView.clipsToBounds = true
                    self.downloadImage(from: url)
                    
                }
            }
    }
        

        func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
            URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
        }
        
        func downloadImage(from url: URL)
        {
            print("Download Started")
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                DispatchQueue.main.async() {
                    self.imageView.image = UIImage(data: data)
                }
                
            }
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "skills&projects" {
                let destination = segue.destination as? SecondViewController
                destination?.baseRespons = self.baseRespons
                destination?.cursusUsers = self.cursusUsers
                destination?.skills = self.skills
                destination?.projectUsers = self.projectUsers
                destination?.project = self.projects
            }
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
}
