//
//  MyZoneViewModel.swift
//  dustAlert-MVVM
//
//  Created by 이주상 on 2023/04/13.
//

import Foundation
import Combine

final class MyZoneViewModel {
    let network: NetworkService
    let dbManager: DBManager = DBManager.shared
    let selectedDust: Dust? = UserDefaults.standard.myZoneDust
    let fetchedDustArr: CurrentValueSubject<[Dust]?, Never>
    let sidoPickerViewTapped = PassthroughSubject<Int, Never>()
    let gunguPickerViewTapped = PassthroughSubject<Int, Never>()

    var subscriptions = Set<AnyCancellable>()
    
    init(network: NetworkService, fetchedDustArr: [Dust]?) {
        self.network = network
        self.fetchedDustArr = CurrentValueSubject(fetchedDustArr)
    }
    
    func fetchDustArr(sidoName: String) {
        let params = [
            "sidoName": sidoName,
            "serviceKey": Env.apiKey,
            "returnType": "json",
            "numOfRows": "100",
            "pageNo": "1",
            "ver": "1.0",
        ]
        let resource = NetworkResource<DustData>(baseUrl: Const.SIDO_DUST_URL, params: params)
        network.load(resource)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.fetchedDustArr.send(nil)
                    debugPrint("fetch error: \(error)")
                case .finished: break
                }
            } receiveValue: { result in
                self.fetchedDustArr.send(result.response.body.items)
            }.store(in: &subscriptions)
    }
    
    func setMyZoneToDB(dust: Dust) {
        UserDefaults.standard.myZoneDust = dust
    }
    
    func setLikeLocationToDB(location: String) {
        dbManager.setLikeLocationToDB(location: location)
    }
    
    func deleteLikeLocationFromDB(location: String) {
        dbManager.deleteLikeLocationFromDB(location: location)
    }
}
