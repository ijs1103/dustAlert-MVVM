//
//  LikeZoneViewModel.swift
//  dustAlert-MVVM
//
//  Created by 이주상 on 2023/04/14.
//

import Foundation
import Combine

final class LikeZoneViewModel {
    let network: NetworkService
    let dbManager: DBManager = DBManager.shared
    let likedDustArr: CurrentValueSubject<[Dust]?, Never>
    let fetchedDustArr: CurrentValueSubject<[Dust]?, Never>
    let sidoPickerViewTapped = PassthroughSubject<Int, Never>()
    let gunguPickerViewTapped = PassthroughSubject<Int, Never>()
    
    var subscriptions = Set<AnyCancellable>()
    
    init(network: NetworkService, likedDustArr: [Dust]?, fetchedDustArr: [Dust]?) {
        self.network = network
        self.likedDustArr = CurrentValueSubject(likedDustArr)
        self.fetchedDustArr = CurrentValueSubject(fetchedDustArr)
    }
    func fetchLikedDust() {
        var dustArr: [Dust] = []
        let likeLocations = dbManager.getLikeLocationFromDB()
        guard likeLocations.count > 0 else { return }
        likeLocations.forEach { location in
            let sidoName = location.components(separatedBy: " ")[0]
            fetchDust(sidoName: sidoName)
            let likedDust = fetchedDustArr.value?.first {
                $0.location == location
            }
            if let likedDust = likedDust {
                dustArr.append(likedDust)
            }
        }
        likedDustArr.send(dustArr)
    }
    private func fetchDust(sidoName: String) {
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

    func deleteLikeLocationFromDB(location: String) {
        dbManager.deleteLikeLocationFromDB(location: location)
    }
}
