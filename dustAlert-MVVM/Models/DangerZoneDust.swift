//
//  DangerZoneDust.swift
//  dustAlert
//
//  Created by 이주상 on 2023/02/15.
//

import UIKit

struct DangerZoneDustData: Codable {
    let response: dzdResponse
}

struct dzdResponse: Codable {
    let body: dzdBody
    let header: dzdHeader
}

struct dzdBody: Codable {
    let totalCount: Int
    let items: [DangerZoneDust]
    let pageNo, numOfRows: Int
}

struct dzdHeader: Codable {
    let resultMsg, resultCode: String
}

final class DangerZoneDust: Codable {
    let location: String?
    let name: String?
    let time = ""
    
    enum CodingKeys: String, CodingKey {
        case time = "dataTime"
        case location = "addr"
        case name = "stationName"
    }
    
    var info: (grade: String, color: UIColor) {
        return ("나쁨", .systemGray)
    }

}

