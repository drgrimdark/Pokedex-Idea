//
//  Constants.swift
//  Pokedex
//
//  Created by Patrick on 8/28/16.
//  Copyright © 2016 Little Lujan LLC. All rights reserved.
//

import Foundation
import UIKit

let URL_BASE = "http://pokeapi.co"
let URL_POKEMON = "/api/v1/pokemon/"

typealias DownloadComplete = () -> ()

let SHADOW_COLOR: CGFloat = 157.0/255.0

// Keys

let KEY_UID = "uid"

//Segues

let SEGUE_LOGGED_IN = "loggedIn"

// Status codes

let STATUS_ACCOUNT_NONEXIST = 17011