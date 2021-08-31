//
//  ContentView.swift
//  WeatherFinal
//
//  Created by Edmond on 7/26/21.
//

import CoreLocation
import SDWebImageSwiftUI
import SwiftUI


struct ContentView: View {
    @State private var location: String = ""
    @State private var forecast: Forecast? = nil
    let dateFormatter = DateFormatter()
    init() {
        dateFormatter.dateFormat = "E, MMM, d"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()
                        .frame(height: 10)
                    HStack {
                        
                        TextField("Enter A City", text: $location)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button {
                            getWeatherForecast(for: location)
                        } label: {
                            Image(systemName: "paperplane")
                                .font(.title)
                        }
                    }
                    if let forecast = forecast {
                        
                        VStack {
                            HStack (alignment: .center) {
                                Text("\(forecast.current.dt)")
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                            }
                            Divider()
                                .background(Color.blue)
                            VStack{
                                Text("Outlook:")
                                    .fontWeight(.bold)
                                Spacer()
                                    .frame(height: 5)
                                Text("\(forecast.current.weather[0].description)")
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .textCase(.uppercase)
                                Spacer()
                                    .frame(height: 5)
                                
                                WebImage(url: forecast.current.weather[0].weatherIconURL)
                                
                                Spacer()
                                    .frame(height: 5)
                                Text("🌡\(forecast.current.temp, specifier: "%.0F")°")
                                    .fontWeight(.bold)
                                    .font(.largeTitle)
                                Divider()
                                    .background(Color.blue)
                                
                                VStack {
                                    Text("Feels like: \(forecast.current.feels_like, specifier: "%.0F")°")
                                        .fontWeight(.bold)
                                    Text("Humidity: \(forecast.current.humidity)%")
                                        .fontWeight(.bold)
                                    Divider()
                                        .background(Color.blue)
                                    HStack{
                                        Text("☀️UV Index: \(forecast.current.uvi)")
                                            .fontWeight(.bold)
                                        //Text("💨Wind Speed \(forecast.current.wind_speed) MPH")
                                    }
                                }
                                
                                
                            }
                        }
                        
                        Spacer()
                        
                    }else {
                        Spacer()
                    }
                    
                }
                .padding(.horizontal)
                .navigationTitle("In-Depth Weather")
                .background(Color.gray)
            }
            .background(Color.gray)
        }
        
    }
    
    func getWeatherForecast(for location: String) {
        let apiService = APIService.shared
        
        CLGeocoder().geocodeAddressString(location) { placemarks, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let lat = placemarks?.first?.location?.coordinate.latitude,
               let lon = placemarks?.first?.location?.coordinate.longitude {
                apiService.getJSON(urlString: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,hourly,alerts,daily&units=imperial&appid=", dateDecodingStrategy: .secondsSince1970) { (result: Result<Forecast,APIService.APIError>) in
                    switch result {
                    case .success(let forecast):
                        self.forecast = forecast
//                        print(dateFormatter.string(from: forecast.current.dt))
//                        print("    Temp: ", forecast.current.temp)
//                        print("    Humidity: ", forecast.current.humidity)
//                        print("    Description: ", forecast.current.weather[0].description)
//                        print("    IconURL: ", forecast.current.weather[0].weatherIconURL)
                    case .failure(let apiError):
                        switch apiError {
                        case .error(let errorString):
                            print(errorString)
                        }
                    }
                }
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
