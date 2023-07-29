//
//  newApi.swift
//  PandaGrab
//
//  Created by Heng Tzemeng on 02/06/2021.
//This file view require SwiftyJSON in order to execute

import SwiftUI
import SDWebImageSwiftUI
import SwiftyJSON
import WebKit
//A class of types whose instances hold the value of an entity with stable identity.
struct newApi:Identifiable {
    var id:String
    var title:String
    var desc:String
    var url:String
    var image:String
}
struct NewsView: View {
    @ObservedObject var list = getApi()
    @ObservedObject var homeData:HomeViewModel

    var body: some View {
        NavigationView{
            List(list.datas){i in
                NavigationLink(destination:webView(url:i.url)
                                .navigationBarTitle("",displayMode:.inline)){
                    HStack(spacing:15){
                        VStack(alignment:.leading,spacing:10){
                            Text(i.title).fontWeight(.heavy)
                            Text(i.desc).lineLimit(2)
                        }
                        if i.image != ""{
                            WebImage(url:URL(string:i.image)!, options:.highPriority, context:nil)
                                
                                .frame(width:110, height:135)
                                .cornerRadius(20)
                        }
                        
                    }.padding(.vertical,15)
                }
                
            }.navigationBarTitle("Headlines")
        }
        
    }
}

//To generate an API key from newsapi.org (Malaysia News)
//User can also change the country //newsapi.org/v2/top-headlines?country="my"
class getApi:ObservableObject{
    @Published var datas=[newApi]()
    init() {
        let source = "https://newsapi.org/v2/top-headlines?country=my&apiKey=a941a5403dd34affabcf545f5437c00e"
        let url = URL(string: source)!
        let session = URLSession(configuration:.default)
        session.dataTask(with: url){
            (data,_,err)in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            let json=try! JSON(data:data!)
            for i in json["articles"]{
                let title=i.1["title"].stringValue
                let description=i.1["description"].stringValue
                let url=i.1["url"].stringValue
                let image=i.1["urlToImage"].stringValue
                let id=i.1["publishedAt"].stringValue
                DispatchQueue.main.async{
                self.datas.append(newApi(id:id,title:title,desc:description,url:url,image:image))
            }
            }
        }.resume()
       
    }
}
//View for NewsView
struct webView:UIViewRepresentable{
    var url:String
    func makeUIView(context:UIViewRepresentableContext<webView>)->WKWebView{
        let view=WKWebView()
        view.load(URLRequest(url:URL(string:url)!))
        return view
    }
    func updateUIView(_ uiView:WKWebView,context:UIViewRepresentableContext<webView>){
    }
}


