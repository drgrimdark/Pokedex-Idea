//
//  Data Service.swift
//  Pokedex
//
//  Created by Patrick on 8/28/16.
//  Copyright © 2016 Little Lujan LLC. All rights reserved.
//

import Foundation
import Firebase

let URLBASE = FIRDatabase.database().reference()


class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = URLBASE
    private var _REF_POKEMON = URLBASE.child("users").child("pokemon")
    private var _REF_USERS = URLBASE.child("users")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POKEMON: FIRDatabaseReference {
        return _REF_POKEMON
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let user = REF_USERS.child(uid)
        return user
    }
    
    
    func createFirebaseUser (uid: String, user: Dictionary<String, String>) {
        REF_USERS.child(uid).setValue(user)
    }
    
}