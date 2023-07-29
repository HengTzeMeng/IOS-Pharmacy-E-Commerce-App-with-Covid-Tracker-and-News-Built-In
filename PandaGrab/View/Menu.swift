//
//  Menu.swift
//  PandaGrab
//
//  Created by Heng Tzemeng on 18/05/2021.
//
//This is the sidebar section for PandaGrab
import SwiftUI

struct Menu: View {
    @ObservedObject var homeData:HomeViewModel
    var body: some View {
        VStack{
            //Navigation link for CartView (Cart section)
            NavigationLink(destination: CartView(homeData: homeData)) {
                
                HStack(spacing: 15){
                    
                    Image(systemName: "cart")
                        .font(.title)
                        .foregroundColor(.green)
                    
                    Text("Cart")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer(minLength: 0)
                }
                .padding()
            }
            //Navigation link for Homess (Covid Updates section)
            NavigationLink(destination: Homess(homeData: homeData)) {
                
                HStack(spacing: 15){
                    
                    Image(systemName: "star")
                        .font(.title)
                        .foregroundColor(.green)
                    
                    Text("Covid Update")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer(minLength: 0)
                }
                .padding()
            }
            //Navigation link for NewsView (News) in newApi
            NavigationLink(destination: NewsView(homeData: homeData)) {
                
                HStack(spacing: 15){
                    
                    Image(systemName: "star")
                        .font(.title)
                        .foregroundColor(.green)
                    
                    Text("News")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer(minLength: 0)
                }
                .padding()
            }
 
            Spacer()
            //Incase is admin wanted to update the app version
            HStack{
                Spacer()
                Text("Version 0.1")
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
            .padding(10)
        }

        .padding([.top,.trailing])
        .frame(width: UIScreen.main.bounds.width / 1.6)
        .background(Color.white.ignoresSafeArea())
    }
}


