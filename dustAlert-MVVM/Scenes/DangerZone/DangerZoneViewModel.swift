//
//  DangerZoneViewModel.swift
//  dustAlert-MVVM
//
//  Created by 이주상 on 2023/04/14.
//

import Foundation
import Combine

final class DangerZoneViewModel {
    let network: NetworkService
    let fetchedDustArr: CurrentValueSubject<[DangerZoneDust]?, Never>
    var subscriptions = Set<AnyCancellable>()
    
    init(network: NetworkService, fetchedDustArr: [DangerZoneDust]?) {
        self.network = network
        self.fetchedDustArr = CurrentValueSubject(fetchedDustArr)
    }
    
    func fetchDustArr() {
        let params = [
            "serviceKey": Env.apiKey,
            "returnType": "json",
            "numOfRows": "100",
            "pageNo": "1",
        ]
        let resource = NetworkResource<DangerZoneDustData>(baseUrl: Const.DANGER_ZONE_DUST_URL, params: params)
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
                self.fetchedDustArr.send(result.response.body.items)
            }.store(in: &subscriptions)
    }
}

