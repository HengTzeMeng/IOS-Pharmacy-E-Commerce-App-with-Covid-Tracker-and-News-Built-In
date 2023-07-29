//
//  CartView.swift
//  PandaGrab
//
//  Created by Heng Tzemeng on 19/05/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct CartView: View {
    @ObservedObject var homeData:HomeViewModel
    @Environment(\.presentationMode) var present
    var body: some View {
        //Go back to main menu
        VStack{
            
            HStack(spacing:20){
                
                Button(action:{present.wrappedValue.dismiss()}) {
                    
                    Image(systemName:"chevron.left")
                        .font(.system(size:26,weight: .heavy))
                        .foregroundColor(Color.green)
                }
                
                Text("Menu")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding()
            //Item details view and add/remove function
            ScrollView(.vertical,showsIndicators:false){
                LazyVStack(spacing:0){
                    ForEach(homeData.cartItems){cart in
                        HStack(spacing:15){
                            WebImage(url:URL(string:cart.item.item_image))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width:130,height:130)
                                .cornerRadius(15)
                            VStack(alignment: .leading,spacing:10){
                                Text(cart.item.item_name)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                Text(cart.item.item_details)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                HStack(spacing: 15){
                                    Text(homeData.getPrice(value:Float(truncating: cart.item.item_cost)))
                                        .font(.title2)
                                        .fontWeight(.heavy)
                                        .foregroundColor(.black)
                                    Spacer(minLength: 0)
                                    //Delete 1 item index
                                    Button(action:{
                                        if cart.quantity > 1{
                                            homeData.cartItems[homeData.getIndex(item: cart.item,isCartIndex: true)].quantity -= 1
                                        }
                                    }) {
                                        
                                        Image(systemName:"minus")
                                            .font(.system(size: 16, weight: .heavy))
                                            .foregroundColor(.black)
                                    }
                                    
                                    Text("\(cart.quantity)")
                                        .fontWeight(.heavy)
                                        .foregroundColor(.black)
                                        .padding(.vertical,5)
                                        .padding(.horizontal,10)
                                        .background(Color.black.opacity(0.06))
                                    //Add 1 index to item
                                    Button(action:{
                                        homeData.cartItems[homeData.getIndex(item: cart.item,isCartIndex: true)].quantity += 1
                                    }) {
                                        
                                        Image(systemName:"plus")
                                            .font(.system(size: 16, weight: .heavy))
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                        //To delete the order and items from cart
                        //Long hold selected item to delete
                        .padding()
                        .contentShape(RoundedRectangle(cornerRadius: 15))
                        .contextMenu{
                            Button(action: {
                                let index = homeData.getIndex(item: cart.item, isCartIndex:true)
                                let itemIndex = homeData.getIndex(item: cart.item, isCartIndex:false)
                                
                                let filterIndex = homeData.filtered.firstIndex { (item1) -> Bool in
                                    return cart.item.id == item1.id
                                } ?? 0
                                
                                homeData.items[itemIndex].isAdded=false
                                homeData.filtered[filterIndex].isAdded=false
                                
                                homeData.cartItems.remove(at:index)
                            }) {
                                
                                Text("Remove")
                            }
                        }
                    }
                }
            }
            //Bottom view section
            //To calculate the total price
            VStack{
                HStack{
                    Spacer()
                    Text("Note: After placing order, our team will arrive shortly.")
                        .fontWeight(.heavy)
                        .foregroundColor(.gray)
                    
                }.padding([.top,.horizontal])
                HStack{
                    Spacer()
                    Text("Free Delivery")
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                    
                }.padding([.top,.horizontal])
                HStack{
                    Text("Total")
                        .fontWeight(.heavy)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(homeData.calculateTotalPrice())
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                }
                .padding([.top,.horizontal])
                
                //Check out section
                //Cancel Order- Will remove order in Firebase
                //Check Out- Will send data to Firebase
                Button(action:homeData.updateOrder){
                    Text(homeData.ordered ? "Cancel Order":"Check out")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width:UIScreen.main.bounds.width - 30)
                        .background(
                            Color(.green)
                        )
                        .cornerRadius(15)
                    
                    
                }
                
            }
            .background(Color.white)
            
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

