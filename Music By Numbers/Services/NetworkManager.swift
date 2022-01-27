//
//  NetworkManager.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 1/26/22.
//

import Foundation

class NetworkManager {
    
    var listOfSets: ListSets?
    
    
    func parseJSON(completion: @escaping (ListSets) -> Void) {
        guard let path = Bundle.main.path(forResource: "SetClasses", ofType: "json") else { return }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            
            let response = (try? JSONDecoder().decode(ListSets.self, from: data))!
            DispatchQueue.main.async {
                completion(response)
            }
//            listOfSets = response
            //            print(listOfSets?.pcSets[0].primeForm)
        } catch {
            debugPrint(error)
        }
    }
    
}
