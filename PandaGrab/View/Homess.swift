//
//  Homess.swift
//  PandaGrab
//
//  Created by Heng Tzemeng on 01/06/2021.
//Covid-19 Statistic View

import SwiftUI

//Variable for Covid-19 statistic
struct Homess : View {
    @ObservedObject var homeData:HomeViewModel
    @State var index = 0
    @State var main : MainData!
    @State var daily : [Daily] = []
    @State var last : Int = 0
    @State var country = "malaysia"
    @State var alert = false
    
    //View for Covid Update
    var body: some View{
        VStack{
            if self.main != nil && !self.daily.isEmpty{
                VStack{
                    VStack(spacing: 18){
                        VStack{
                            Text("Statistics")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical)
                            //Button to search available countries
                            //Default country is set to Malaysia, click Malaysia to search other countries
                            Button(action: {
                                self.Dialog()
                            }) {
                                Text(self.country.uppercased())
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 15)
                        
                        HStack{
                            Button(action: {
                                self.index = 0
                                self.main = nil
                                self.daily.removeAll()
                                self.getData()
                            }) {
                                Text("My Country")
                                    .foregroundColor(self.index == 0 ? .black : .white)
                                    .padding(.vertical, 12)
                                    .frame(width: (UIScreen.main.bounds.width / 2) - 30)
                            }
                            .background(self.index == 0 ? Color.white : Color.clear)
                            .clipShape(Capsule())
                            //To switch statistic view from Malaysia to Global
                            Button(action: {
                                self.index = 1
                                self.main = nil
                                self.daily.removeAll()
                                self.getData()
                            }) {
                                Text("Global")
                                    .foregroundColor(self.index == 1 ? .black : .white)
                                    .padding(.vertical, 12)
                                    .frame(width: (UIScreen.main.bounds.width / 2) - 30)
                            }
                            .background(self.index == 1 ? Color.white : Color.clear)
                            .clipShape(Capsule())
                        }
                        .background(Color.black.opacity(0.25))
                        .clipShape(Capsule())
                        .padding(.top, 10)
                        
                        HStack(spacing: 15){
                            VStack(spacing: 12){
                                Text("Affected")
                                    .fontWeight(.bold)
                                Text("\(self.main.cases)")
                                    .fontWeight(.bold)
                                    .font(.title)
                            }
                            .padding(.vertical)
                            .frame(width: (UIScreen.main.bounds.width / 2) - 30)
                            .background(Color("affected"))
                            .cornerRadius(12)
                            
                            VStack(spacing: 12){
                                Text("Deaths")
                                    .fontWeight(.bold)
                                Text("\(self.main.deaths)")
                                    .fontWeight(.bold)
                                    .font(.title)
                            }
                            .padding(.vertical)
                            .frame(width: (UIScreen.main.bounds.width / 2) - 30)
                            .background(Color("death"))
                            .cornerRadius(12)
                        }
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        
                        HStack(spacing: 15){
                            VStack(spacing: 12){
                                Text("Recovered")
                                    .fontWeight(.bold)
                                Text("\(self.main.recovered)")
                                    .fontWeight(.bold)
                            }
                            .padding(.vertical)
                            .frame(width: (UIScreen.main.bounds.width / 3) - 30)
                            .background(Color("recovered"))
                            .cornerRadius(12)
                            
                            VStack(spacing: 12){
                                Text("Active")
                                    .fontWeight(.bold)
                                Text("\(self.main.active)")
                                    .fontWeight(.bold)
                            }
                            .padding(.vertical)
                            .frame(width: (UIScreen.main.bounds.width / 3) - 30)
                            .background(Color("active"))
                            .cornerRadius(12)
                            
                            VStack(spacing: 12){
                                Text("ICU")
                                    .fontWeight(.bold)
                                Text("\(self.main.critical)")
                                    .fontWeight(.bold)
                            }
                            .padding(.vertical)
                            .frame(width: (UIScreen.main.bounds.width / 3) - 30)
                            .background(Color("serious"))
                            .cornerRadius(12)
                        }
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 45)
                    .background(Color.green)
                    
                    VStack(spacing: 15){
                        HStack{
                            Text("Last 7 Days")
                                .font(.title)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.top)
                        
                        HStack{
                            ForEach(self.daily){i in
                                VStack(spacing: 10){
                                    Text("\(i.cases / 1000)K")
                                        .lineLimit(1)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    GeometryReader{g in
                                        VStack{
                                            Spacer(minLength: 0)
                                            Rectangle()
                                            .fill(Color("death"))
                                                .frame(width: 15,height: self.getHeight(value: i.cases, height: g.frame(in: .global).height))
                                        }
                                    }
                                    Text(i.day)
                                        .lineLimit(1)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.bottom, -30)
                    .offset(y: -30)
                }
            }
            else{
                
                Indicator()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .alert(isPresented: self.$alert, content: {
            
            Alert(title: Text("Error"), message: Text("Invalid Country Name"), dismissButton: .destructive(Text("Ok")))
        })
        .onAppear {
            
            self.getData()
        }
    }
//Get API from NovelCovid API
    func getData(){
        var url = ""
        if self.index == 0{
            url = "https://corona.lmao.ninja/v2/countries/\(self.country)?yesterday=false"
        }
        else{
            url = "https://corona.lmao.ninja/v2/all?today"
        }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            let json = try! JSONDecoder().decode(MainData.self, from: data!)
            self.main = json
        }
        .resume()
        var url1 = ""
        if self.index == 0{
            url1 = "https://corona.lmao.ninja/v2/historical/\(self.country)?lastdays=7"
        }
        else{
            url1 = "https://corona.lmao.ninja/v2/historical/all?lastdays=7"
        }
        let session1 = URLSession(configuration: .default)
        session1.dataTask(with: URL(string: url1)!) { (data, _, err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            
            var count = 0
            var cases : [String : Int] = [:]
            if self.index == 0{
                let json = try! JSONDecoder().decode(MyCountry.self, from: data!)
                cases = json.timeline["cases"]!
            }
            else{
                let json = try! JSONDecoder().decode(Global.self, from: data!)
                cases = json.cases
            }
            
            for i in cases{
                self.daily.append(Daily(id: count, day: i.key, cases: i.value))
                count += 1
            }
            self.daily.sort { (t, t1) -> Bool in
                if t.day < t1.day{
                    return true
                }
                else{
                    return false
                }
            }
            self.last = self.daily.last!.cases
        }
        .resume()
    }
    //Safer side
    func getHeight(value : Int,height:CGFloat)->CGFloat{
        if self.last != 0{
            let converted = CGFloat(value) / CGFloat(self.last)
            return converted * height
        }
        else{
            return 0
        }
    }
    //Search function for availabe countries
    //Get country names from Countries.swift
    func Dialog(){
        let alert = UIAlertController(title: "Country", message: "Type A Country", preferredStyle: .alert)
        alert.addTextField { (_) in
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            
            for i in countryList{
                if i.lowercased() == alert.textFields![0].text!.lowercased(){
                    
                    self.country = alert.textFields![0].text!.lowercased()
                    self.main = nil
                    self.daily.removeAll()
                    self.getData()
                    return
                }
            }
            self.alert.toggle()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

class Host : UIHostingController<ContentView>{
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}


//Data Models For JSON Parsing

struct Daily: Identifiable{
    var id : Int
    var day : String
    var cases : Int
}

struct MainData : Decodable{
    var deaths : Int
    var recovered : Int
    var active : Int
    var critical : Int
    var cases : Int
}

struct MyCountry : Decodable {
    var timeline : [String : [String : Int]]
}

struct Global : Decodable {
    var cases : [String : Int]
   
}

struct Indicator : UIViewRepresentable {
    func makeUIView(context: Context) ->  UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView:  UIActivityIndicatorView, context: Context) {
    }
}
