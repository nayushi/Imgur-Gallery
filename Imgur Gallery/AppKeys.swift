//
//  AppKeys.swift
//  Imgur Gallery
//
//  Created by Mariana Brasil on 03/09/21.
//

import Foundation

class AppKeys {
    static let sharedInfo = AppKeys()
    
    var clientId = ""
    var clientSecret = ""
    var accessToken = ""
    
    init(){
        guard let path = Bundle.main.path(forResource: "AppKeys", ofType: "plist") else {
            fatalError("This file don't exist")
        }
        
        let plist = NSDictionary(contentsOfFile: path)
        
        clientId = plist?["clientId"] as! String
        clientSecret = plist?["clientSecret"] as! String
        accessToken = plist?["accessToken"] as! String
    }
    
}
