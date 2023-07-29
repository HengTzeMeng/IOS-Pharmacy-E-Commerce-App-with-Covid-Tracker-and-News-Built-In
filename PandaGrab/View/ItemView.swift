//
//  ItemView.swift
//  PandaGrab
//
//  Created by Heng Tzemeng on 18/05/2021.
//

import SwiftUI
import SDWebImageSwiftUI
struct ItemView: View {
    var item:Items
    var body: some View {
        //Downloading images from website
        VStack{
            WebImage(url:URL(string:item.item_image))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width - 200,height: 250)
        
            HStack(spacing:8){
                Text(item.item_name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer(minLength: 0)
                //Ratings view section
                //Get rating through Firebase
                ForEach(1...5,id: \.self){index in
                    Image(systemName: "star.fill")
                        .foregroundColor(index <= Int(item.item_ratings) ?? 0 ? Color.orange : .gray)
                }
            }
            HStack{
                Text(item.item_details)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                Spacer(minLength: 0)
            }
        }
    }
}



