//
//  NetworkDataFetcher.swift
//  Cocktail
//
//  Created by Adel Gainutdinov on 29.03.2022.
//

import Alamofire

protocol DataFetcher {
    func fetchDrinks(with filter: [String : String], completion: @escaping ([Drink]) -> ())
}

class NetworkDataFetcher: DataFetcher {
    func fetchDrinks(with filter: [String : String], completion: @escaping ([Drink]) -> ()) {
        let url = url(from: API.drinksFilter, params: filter)
        print(url)
        AF.request(url).validate().responseJSON { response in
            guard let data = response.data else { return }
            do {
                let drinksResponse = try JSONDecoder().decode(DrinksResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(drinksResponse.drinks)
                }
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }
    }
    
    private func url(from path: String, params: [String : String]) -> URL {
        var components = URLComponents()
        
        components.scheme = API.scheme
        components.host = API.host
        components.path = path
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        
        return components.url!
    }
}
