//
//  APIController.swift
//  Companion
//
//  Created by Sbusiso XABA on 2019/11/11.
//  Copyright © 2019 Sbusiso XABA. All rights reserved.
//

import Foundation
import JSONParserSwift
import SwiftyJSON

/* This class simply makes a request to the 42 API authentication endpoind and the users endpoind
 Having this functionaliy in its own class helps to avoid the situation of making a token request everytime we make a search.
 */

/* Struct to hold globals from this class */
struct Globals {
    static var token: String!
    static var jsonResponse: JSON!
}

var token_ = "?"

class APIController: NSObject {
    
    /* Request an access token
     - The token gets returend as a string
     */
    func RequestToken() {
        
        let UID = "13719467356dceeaed1c5222435da6447f797b19cd77cdb1522faefa890a2534"
        let SECRET = "e181347de9243efb846b6f77dfab9465a49473705d47e5dcf83affd3077375dd"
        let BEARER = ((UID + ":" + SECRET).data(using: String.Encoding.utf8, allowLossyConversion: true))!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        
        guard let url = URL(string: "https://api.intra.42.fr/oauth/token") else {return}
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic " + BEARER, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    if let token = json["access_token"]
                    {
                        print("1st token = \(token)")
                        Globals.token = (token as! String)
                        print(Globals.token!)
                        token_ = token as! String
                    }
                } catch {
                    print(error)
                }
            }
        })
        
        task.resume()
    }
    
    /*  Getting the user info */
    func getUserInfo(userlogin: String, token: String?, completionBlock: @escaping (JSON?, Error?) -> Void) -> (result: Bool, message: String?){
        print("Started connection")
        
        /* check for token valididty */
        guard let token_check = token else {
            print("Token problem!")
            return (false, "Token Problem!")
        }
        
        let authEndPoint: String = "https://api.intra.42.fr/v2/users/\(userlogin)"
        print(authEndPoint)
        
        guard let url = URL(string: authEndPoint) else {return (false, "Login not found!")}
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token_check)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        let requestGET = session.dataTask(with: request) { (data, response, error) in
           
            if let data = data {
                do {
                    
                    let json = try JSON(data: data)
                    Globals.jsonResponse = json /* save */
                    
                    /* check if user is available */
                    if userlogin == json["login"].stringValue {
                        
                        print(userlogin)
                        print(token_check)
                        
                        completionBlock(json, nil); /* return true if successful */
                    }
                    else {
                        completionBlock(nil, error)  /* return false if fail */
                    }
                    
                } catch {
                    print(error)
                }
            }
            else {
                print("Data is null")
            }
        }
        requestGET.resume()
        
        print("End token")
        return (true, "Success!")
    }
    
}
