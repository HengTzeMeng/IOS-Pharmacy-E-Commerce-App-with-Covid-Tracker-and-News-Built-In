//
//  Home.swift
//  PandaGrab
//
//  Created by Heng Tzemeng on 18/05/2021.
//

import SwiftUI

struct Home: View {
    @StateObject var HomeModel=HomeViewModel()
    
    var body: some View {
        ZStack{
        VStack(spacing:10){
            HStack(spacing:15){
                Button(action:{
                    withAnimation(.easeIn){
                        HomeModel.showMenu.toggle()
                    }
                },label:{
                    Image(systemName: "line.horizontal.3")
                        .font(.title)
                        .foregroundColor(.green)
                })
                
                Text(HomeModel.userLocation == nil ? "Locating..." : "Deliver To")
                    .foregroundColor(.black)
                
                Text(HomeModel.userAddress)
                    .font(.caption)
                    .fontWeight(.heavy)
                    .foregroundColor(.pink)
                
                Spacer(minLength: 0)
            }
            .padding([.horizontal,.top])
            Divider()
            HStack(spacing:15){
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundColor(.gray)
                TextField("Search",text:$HomeModel.search)

            }
            .padding(.horizontal)
            .padding(.top,10)
            Divider()
            if HomeModel.items.isEmpty{
                Spacer()
                ProgressView()
                Spacer()
            }
            else{
                //Item view section
                ScrollView(.vertical,showsIndicators:false,content:{
                    VStack(spacing:25){
                        ForEach(HomeModel.filtered){item in
                            
                            ZStack(alignment: Alignment(horizontal: .center,vertical: .top),content:{
                                ItemView(item:item)
                                HStack{
                                    Text("")
                                        .foregroundColor(.white)
                                        .padding(.vertical,10)
                                        .padding(.horizontal)
                                        //.background(Color.green)
                                    Spacer(minLength: 0)
                                    
                                    Button(action:{
                                        HomeModel.addToCart(item: item)
                                    },label:{
                                        Image(systemName:item.isAdded ? "checkmark":"plus")
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(item.isAdded ? Color.pink:Color.green)
                                            .clipShape(Circle())
                                    })
                                }
                                .padding(.trailing,10)
                                .padding(.top,10)
                            })
                            .frame(width:UIScreen.main.bounds.width - 30)
                        }
                    }
                    .padding(.top,10)
                })
            }
        }
            //Side menu UI
            //Movement effect from left
            HStack{
                Menu(homeData: HomeModel)
                    .offset(x:HomeModel.showMenu ? 0:-UIScreen.main.bounds.width / 1.6)
                Spacer(minLength: 0)
            }
            //Close taps when on outside
            .background(Color.black.opacity(HomeModel.showMenu ? 0.3:0).ignoresSafeArea()
                            .onTapGesture(perform:{
                                withAnimation(.easeIn){HomeModel.showMenu.toggle()}
                            })
            )
            //Alert user if location access denied
            if HomeModel.noLocation{
                Text("Enable Location Access In Setting!")
                    .foregroundColor(.black)
                    .frame(width:UIScreen.main.bounds.width-10,height:120)
                    .background(Color.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3).ignoresSafeArea())
            }
        }
        //Calling the location delegate
        .onAppear(perform: {
            HomeModel.locationManager.delegate=HomeModel
            
        })
        //To avoid continues search request
        .onChange(of: HomeModel.search, perform:{ value in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                //Search data section
                if value == HomeModel.search && HomeModel.search != ""{
                    HomeModel.filterData()
                }
            }
            //Reset all the data
            if HomeModel.search == ""{
                withAnimation(.linear){
                    HomeModel.filtered=HomeModel.items
                }
            }
        })
    }
}

struct Home_Previews: PreviewProvider {
static var previews: some View {
        Home()
    }
}
