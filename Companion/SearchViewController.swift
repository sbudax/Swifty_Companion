//
//  SearchViewController.swift
//  Companion
//
//  Created by Sbusiso XABA on 2019/10/30.
//  Copyright © 2019 Sbusiso XABA. All rights reserved.
//

import UIKit
import SwiftyJSON
import JSONParserSwift

class SearchViewController: UIViewController {
    
    var apiController: APIController = APIController()
    
    @IBOutlet weak var SearchTextField: UITextField!
    
    @IBAction func SearchButton(_ sender: UIButton) {
        if self.SearchTextField.text?.isEmpty ?? true {
            DispatchQueue.main.async {
                            self.popUp()
            }
            print("Text field can't be empty")
        }
        else {
                    
                    let returned = self.apiController.getUserInfo(userlogin: (SearchTextField.text!.trimmingCharacters(in: .whitespaces)).lowercased(), token: Globals.token) {
                        (output, error) in
                        if let data = output {
                            DispatchQueue.main.async {
                                print(data)
                                self.performSegue(withIdentifier: "mySegue", sender: self)
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                self.popUp() /* pop-up an alert message */
                            }
                        }
                    }
                    
                    if !returned.result {
                        self.apiController.RequestToken() /* follow up request */
                        print("Fails")
                    }
                }
            }
            
            override func viewDidLoad() {
                super.viewDidLoad()

                self.apiController.RequestToken() /* first request */
            }

            override func didReceiveMemoryWarning() {
                super.didReceiveMemoryWarning()
                // Dispose of any resources that can be recreated.
            }
            
            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "mySegue" {
                    let destination = segue.destination as? ViewController
                    destination?.user = SearchTextField.text!
                }
            }
            
            func popUp()
            {
                var alert = UIAlertController()
                let message = "The username:  " + self.SearchTextField.text! + " was not found. Please try again..."
                if self.SearchTextField.text?.isEmpty ?? true
                {
                    alert = UIAlertController(title: "No Username", message: "Username text field can't be empty!", preferredStyle: .alert)
                }
                else
                {
                    alert = UIAlertController(title: "Username Error", message: message, preferredStyle: .alert)
                }
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            

        }

