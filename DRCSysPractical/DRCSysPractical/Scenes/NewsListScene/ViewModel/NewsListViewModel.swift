//
//  DemoViewModel.swift
//  DRCSysPractical
//
//  Created by Mac Mini on 09/12/20.
//  
//

import Foundation
import CoreData

class AudioListViewModel: BaseViewModel {
    var newsModel: [NewsModel] = []
    var elementName: String = String()
        
    func callNewsListAPI(completion: @escaping (Bool) -> ()) {
        let task = URLSession.shared.dataTask(with: URL(string: "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topsongs/limit=20/xml")!) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }
            
                print(self.newsModel.count)
                if self.newsModel.count == 20 {
                    completion(true)
                }
        }
        task.resume()
    }
}

