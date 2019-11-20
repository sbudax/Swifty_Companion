//
//  UserModel.swift
//  Companion
//
//  Created by Sbusiso XABA on 2019/11/05.
//  Copyright © 2019 Sbusiso XABA. All rights reserved.
//

import Foundation
import JSONParserSwift
import SwiftyJSON

struct BaseResponse {
    var image_url: String = ""
    var displayname: String = ""
    var login: String = ""
    var phone: Int = 0
    var wallet: Int = 0
    var correction_point: Int = 0
    var cursus_users: [Cursus_users]?
    var projects_users: [Projects_users]?
    var campus: String = ""
    
    init(_ json: JSON) {
           image_url = json["image_url"].stringValue
           displayname = json["displayname"].stringValue
           login = json["login"].stringValue
           phone = json["phone"].intValue
           wallet = json["wallet"].intValue
           correction_point = json["correction_point"].intValue
           cursus_users = json["cursus_users"].arrayValue.map { Cursus_users($0) }
           projects_users = json["projects_users"].arrayValue.map { Projects_users($0)}
           campus = json["campus"][0]["city"].stringValue
       }
}

struct Cursus_users {
    var level: Double = 0.0
    var skills: [Skills]?
    
    init(_ json: JSON) {
        level = json["level"].doubleValue
        skills = json["skills"].arrayValue.map { Skills($0) }
    }
}

struct Skills {
    var name: String = ""
    var level: Double = 0.0
    
    init(_ json: JSON) {
        name = json["name"].stringValue
        level = json["level"].doubleValue
    }
}

struct Projects_users {
    var final_mark: Int = 0
    var project: Project?
    
    init(_ json: JSON) {
        final_mark = json["final_mark"].intValue
        project = Project(json["project"])
    }
}

struct Project {
    var name: String = ""
    
    init(_ json: JSON) {
        name = json["name"].stringValue
    }
}
