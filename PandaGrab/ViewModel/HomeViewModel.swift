//
//  HomeViewModel.swift
//  PandaGrab
//
//  Created by Heng Tzemeng on 18/05/2021.
//Firebase needed in order to execute program

import SwiftUI
import CoreLocation
import Firebase

//Fetching user lacation
class HomeViewModel:NSObject,ObservableObject,CLLocationManagerDelegate{
    @Published var locationManager=CLLocationManager()
    @Published var search=""
    //Variable for location details
    @Published var userLocation:CLLocation!
    @Published var userAddress=""
    @Published var noLocation=false
    //Variable for menu
    @Published var showMenu=false
    //Variable for item data
    @Published var items:[Items]=[]
    @Published var filtered:[Items]=[]
    //Variable for cart data
    @Published var cartItems:[Cart]=[]
    @Published var ordered=false
    
    //Checking the location access
    // If users did not allow location access, system will denied users for using it.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("authorized")
            self.noLocation=false
            manager.requestLocation()
        case .denied:
            print("denied")
            self.noLocation=true
        default:
            print("unknown")
            self.noLocation=false
            //Direct call and modifying Info.plist
            locationManager.requestWhenInUseAuthorization()
        }
    }
    //Get user location
    func locationManager(_ manager: CLLocationManager,didFailWithError error: Error){
        print(error.localizedDescription)
    }
        //Read user location and extract details
        func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]){
            self.userLocation=locations.last
            self.extractLocation()
            //Login after extracting location completed
            self.login()
        }
        
        func extractLocation(){
            CLGeocoder().reverseGeocodeLocation(self.userLocation) { (res, err) in
                
                guard let safeData = res else{return}
                //Get user address/area
                var address = ""
                
                address += safeData.first?.name ?? ""
                address += ", "
                address += safeData.first?.locality ?? ""
                
                self.userAddress = address
            }
        }
    //Anonymous login for reading database
    func login(){
        Auth.auth().signInAnonymously{
            (res,err)in
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            //Fetching data after logging in
            print("Success = \(res!.user.uid)")
            self.fetchData()
        }
        
    }
    
    //Fetching items data for firestore
    //Data of vaccine include item name, cost, rating, image, details
    func fetchData(){
        let db=Firestore.firestore()
        db.collection("Item").getDocuments{(snap, err) in
            guard let itemData = snap else{return}
            self.items=itemData.documents.compactMap({(doc) -> Items? in
                let id=doc.documentID
                let name=doc.get("item_name") as! String
                let cost=doc.get("item_cost") as! NSNumber
                let ratings=doc.get("item_ratings") as! String
                let image=doc.get("item_image") as! String
                let details=doc.get("item_details") as! String
                return Items(id: id, item_name: name, item_cost: cost, item_details: details, item_image: image, item_ratings: ratings)
            })
            self.filtered=self.items
        }
    }
    //Filter and search data
    func filterData(){
        withAnimation(.linear){
            self.filtered=self.items.filter{
                return $0.item_name.lowercased().contains(self.search.lowercased())
        }
        
        }
    }
    
    //Function for add to cart
    func addToCart(item:Items){
        //Checking whether the item is added
        self.items[getIndex(item:item,isCartIndex: false)].isAdded = !item.isAdded
        //Updating filtered array and for search bar result
        let filterIndex=self.filtered.firstIndex{(item1) -> Bool in
            return item.id == item1.id
        } ?? 0
        self.filtered[filterIndex].isAdded = !item.isAdded
        //Remove item from list, else add to item to list
        if item.isAdded{
            self.cartItems.remove(at: getIndex(item:item,isCartIndex: true))
            return
        }
        self.cartItems.append(Cart(item:item,quantity:1))
    }
    //Add or remove item index by 1
    func getIndex(item:Items,isCartIndex:Bool)->Int{
        let index=self.items.firstIndex{(item1) -> Bool in
            return item.id == item1.id
        } ?? 0
        let cartIndex=self.cartItems.firstIndex{(item1) -> Bool in
            return item.id == item1.item.id
        } ?? 0
        return isCartIndex ? cartIndex:index
    }
    
    //Calculate the total price for cart item.
    func calculateTotalPrice()->String{
        var price:Float = 0
        cartItems.forEach { (item) in
            price += Float(item.quantity) * Float(truncating: item.item.item_cost)
        }
        return getPrice(value:price)
    }
    //Get vaccine price from item_cost
    func getPrice(value:Float)->String{
        let format=NumberFormatter()
        format.numberStyle = .currency
        return format.string(from:NSNumber(value: value)) ?? ""
    }
    
    //Writing order data into Firestore
    func updateOrder(){
        let db=Firestore.firestore()
        //Auto create colection of vaccine details in Firebase
        if ordered{
            ordered=false
            db.collection("Users").document(Auth.auth().currentUser!.uid).delete{
                (err) in
                if err != nil{
                    self.ordered=true
                }
            }
        }
        var details:[[String:Any]]=[[:]]
        cartItems.forEach{(cart) in
            details.append([
                "item_name":cart.item.item_name,
                "item_quantity":cart.quantity,
                "item_cost":cart.item.item_cost
            ])
        }
        //After created Users in Firebase, it will create document and collection in Firebase
        //Item_name, item_cost, item_quantity will be categorize under orderes_item
        //User location will written in "location" in geopoint 
        ordered=true
        db.collection("Users").document(Auth.auth().currentUser!.uid).setData([
            "ordered_item":details,
            "total_cost":calculateTotalPrice(),
            "location":GeoPoint(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        ]){
            (err) in
            if err != nil{
                self.ordered=false
                return
            }
            print("success")
        }
    }
}
