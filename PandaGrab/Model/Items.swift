//
//  Items.swift
//  PandaGrab
//
//  Created by Heng Tzemeng on 18/05/2021.
//

import SwiftUI
//A class of types whose instances hold the value of an entity with stable identity.
//Important part for firestore databases
struct Items: Identifiable {
    var id: String
    var item_name: String
    var item_cost: NSNumber
    var item_details: String
    var item_image: String
    var item_ratings: String
    //To check whether the item is added to the cart
    var isAdded: Bool=false
}


