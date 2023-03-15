//
//  Home.swift
//  WeatherApp
//
//  Created by Devinely on 14.03.2023.
//

import SwiftUI
import Foundation

let API_key: String = "5207619dd5a2b9bc4ecc2e7459bf7e7c"
var DataList = [JSONModel]()

let components = Calendar.current.dateComponents([.hour], from: Date())
let hour = components.hour ?? 0

struct Home: View {
    
    @State private var City: String = ""
    @State var show: Bool = false
   
    var from: [String] = ["Ãœ", "Å", "Ä", "Ã‡", "Ä°", "Ã–", "Ã¼", "ÅŸ", "Ã§", "Ä±", "Ã¶", "ÄŸ","Ü", "Ş", "Ğ", "Ç", "İ", "Ö", "ü", "ş", "ç", "ı", "ö", "ğ","%u015F", "%E7", "%FC", "%u0131", "%F6", "%u015E", "%C7", "%DC", "%D6","%u0130", "%u011F", "%u011E"];
    
    var to: [String] = ["U", "S", "G", "C", "I", "O", "u", "s", "c", "i", "o","g","U","S", "G", "C", "I", "O", "u", "s", "c","i", "o", "g","s", "c", "u", "i", "o", "S", "C", "U", "O", "I", "g", "G"];
    
    
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "location.fill")
                    .padding(.leading, 30)
                TextField("Enter Your Location", text: $City, onEditingChanged: {_ in
                    self.City = self.City.lowercased()
                    
                    
                })
                .keyboardType(.default)
                .padding(.leading, 5)
                VStack{
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                        .frame(width: 36, height: 36)
                        .background(Color("Search"))
                        .clipShape(Circle())
                }
                .onTapGesture{
                    withAnimation{
                        from.indices.forEach{ index in
                            self.City = self.City.replacingOccurrences(of: from[index], with: to[index])
                        }
                        getCityWeatherData(name: City)
                        show = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                            show = true
                        }
                        
                    }
                }
                .padding(.trailing, 20)
            }
//            .padding(.top, show == true ? 0 : 0)
            if show {
                VStack{
                    ForEach(DataList, id: \.id){x in
                        ForEach(x.weather, id: \.id) { y in
                          
                            switch y.main  {
                            case "Clear":
                                Image(systemName: (hour<10 || hour > 19)  ? "moon.fill" : "sun.max.fill")
                                    .resizable()
                                    .frame(width: 155, height: 155)
                            case "Rain":
                                Image(systemName: "cloud.rain.fill")
                                    .resizable()
                                    .frame(width: 155, height: 155)
                            case "Snow":
                                Image(systemName: "cloud.snow.fill")
                                    .resizable()
                                    .frame(width: 155, height: 155)
                            case "Clouds":
                                Image(systemName: "cloud.fill")
                                    .resizable()
                                    .frame(width: 155, height: 155)
                            case "Haze":
                                Image(systemName: "cloud.fog.fill")
                                    .resizable()
                                    .frame(width: 155, height: 155)
                            default:
                                Image(systemName: "cloud.sun.rain.fill")
                                    .resizable()
                                    .frame(width: 155, height: 155)
                            }
                        }
                    }
                    
                    HStack{
                        ForEach(DataList, id: \.id){x in
                            Text("\(String(x.main.temp).subString(from: 0, to: 1))")
                                .font(.system(size: 55))
                                .fontWeight(Font.Weight.black)
                            
                        }
                        
                        Text("°C")
                            .font(.system(size: 25))
                            .fontWidth(Font.Width(0.02))
                            .padding(.bottom, 50)
                            .fontWeight(.bold)
                    }
                    
                    ForEach(DataList, id: \.id){x in
                        ForEach(x.weather, id: \.id) { y in
                          
                            switch y.main  {
                            case "Clear":
                                Text("Açık")
                                    .font(.system(size: 25))
                                    .fontWeight(.regular)
                                    .padding(.bottom, 35)
                            case "Rain":
                                Text("Yağmurlu")
                                    .font(.system(size: 25))
                                    .fontWeight(.regular)
                                    .padding(.bottom, 35)
                            case "Snow":
                                Text("Kar Yağışlı")
                                    .font(.system(size: 25))
                                    .fontWeight(.regular)
                                    .padding(.bottom, 35)
                            case "Clouds":
                                Text("Parçalı Bulutlu")
                                    .font(.system(size: 25))
                                    .fontWeight(.regular)
                                    .padding(.bottom, 35)
                            case "Haze":
                                Text("Sisli")
                                    .font(.system(size: 25))
                                    .fontWeight(.regular)
                                    .padding(.bottom, 35)
                            default:
                                Text("Parçalı Bulutlu")
                                    .font(.system(size: 25))
                                    .fontWeight(.regular)
                                    .padding(.bottom, 35)
                            }
                        }
                    }
                    
                    
                    HStack{
                        HStack{
                            Image("wave")
                                .resizable()
                                .frame(width: 36, height: 36)
                            VStack{
                                ForEach(DataList, id: \.id){x in
                                    Text("\(x.main.humidity)%")
                                }
                                
                                Text("Nem")
                            }
                        }
                        .padding(.trailing, 60)
                        
                        Image(systemName: "wind")
                        VStack{
                            ForEach(DataList, id: \.id){ x in
                                Text("\(String(x.wind.speed).subString(from: 0, to: 4)) Km/h \nRüzgar Hızı")
                                    .multilineTextAlignment(.leading)
                            }

                        }
                    }
                }
                .padding(.top, 40)
               
            }
        }
        .frame(width: 340, height: show == true ? 500 : 100)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 20))
    }
}

func getCityWeatherData(name: String){
    DataList = [JSONModel]()
    let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(name.lowercased())&units=metric&APPID=\(API_key)")!
            URLSession.shared.dataTask(with: url) {(data, response, error) in
                do {
                    if let todoData = data {
                        let decodedData = try JSONDecoder().decode(JSONModel.self, from: todoData)
                        DispatchQueue.main.async {
                            DataList = [decodedData]
                           
                        }
                    } else {
                        print("No Data")
                    }
                } catch {
                    print(error)
                }
            }.resume()
    
    for x in DataList {
        print("\(x.main.temp)")
    }
}

extension String {
    func subString(from: Int, to: Int) -> String {
       let startIndex = self.index(self.startIndex, offsetBy: from)
       let endIndex = self.index(self.startIndex, offsetBy: to)
       return String(self[startIndex..<endIndex])
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

