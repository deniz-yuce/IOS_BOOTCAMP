//
//  HomePageInteractor.swift
//  AkisYemek
//
//  Created by Deniz Yüce on 28.05.2022.
//

import Foundation

class HomePageInteractor : PresenterToInteractorHomePageProtocol {
    var homePagePresenter: InteractorToPresenterHomePageProtocol?
    
    func getAllFoods() {
        let url = URL(string: "http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php")!
        
        URLSession.shared.dataTask(with: url){data,response,error in
            if error != nil || data == nil {
                print("Error")
                return
            }
            
            do{
                let answer = try JSONDecoder().decode(FoodsResponse.self, from: data!)
                if let list = answer.yemekler {
                    self.homePagePresenter?.sendDataToPresenter(foodsList: list)
                }
            }catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
