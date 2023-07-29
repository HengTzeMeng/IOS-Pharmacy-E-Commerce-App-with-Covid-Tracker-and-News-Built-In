//
//  Cart.swift
//  PandaGrab
//
//  Created by Heng Tzemeng on 19/05/2021.
//

import SwiftUI
//A class of types whose instances hold the value of an entity with stable identity.
struct Cart: Identifiable {
    var id=UUID().uuidString
    var item:Items
    var quantity:Int
}


