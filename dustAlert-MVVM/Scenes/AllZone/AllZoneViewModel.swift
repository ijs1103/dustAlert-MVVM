//
//  AllZoneViewModel.swift
//  dustAlert-MVVM
//
//  Created by 이주상 on 2023/04/14.
//

import Foundation
import Combine

final class AllZoneViewModel {
    let network: NetworkService
    let dbManager: DBManager = DBManager.shared
    let fetchedDustArr: CurrentValueSubject<[Dust]?, Never>
    var subscriptions = Set<AnyCancellable>()

    init(network: NetworkService, fetchedDustArr: [Dust]?) {
        self.network = network
        self.fetchedDustArr = CurrentValueSubject(fetchedDustArr)
    }
    
    func fetchDustArr() {
        let params = [
            "sidoName": "전국",
            "serviceKey": Env.apiKey,
            "returnType": "json",
            "numOfRows": "100",
            "pageNo": "1",
            "ver": "1.0",
        ]
        let resource = NetworkResource<DustData>(baseUrl: Const.SIDO_DUST_URL, params: params)
        network.load(resource)
            .receive(on: RunLoop.main)
            .sink { [unowned self] completion in
                switch completion {
                case .failure(let error):
                    self.fetchedDustArr.send(nil)
                    debugPrint("fetch error: \(error)")
                case .finished:
                    
                    break
                }
            } receiveValue: { result in
                let dustArr = result.response.body.items
                self.syncAllZoneDust(dustArr: dustArr)
                self.fetchedDustArr.send(dustArr)
            }.store(in: &subscriptions)
    }
    
    private func syncAllZoneDust(dustArr: [Dust]) {
        let likeLocations = dbManager.getLikeLocationFromDB()
        guard likeLocations.count > 0 else { return }
        dustArr.forEach {
            if (likeLocations.contains($0.location!)) {
                $0.isLiked = true
            }
        }
    }
    
    func setLikeLocationToDB(location: String) {
        dbManager.setLikeLocationToDB(location: location)
    }
    
    func deleteLikeLocationFromDB(location: String) {
        dbManager.deleteLikeLocationFromDB(location: location)
    }
}
