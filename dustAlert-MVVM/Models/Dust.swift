//
//  Dust.swift
//  dustAlert
//
//  Created by 이주상 on 2023/02/03.
//

import UIKit

struct DustData: Codable {
    let response: Response
}

struct Response: Codable {
    let body: Body
    let header: Header
}

struct Body: Codable {
    let totalCount: Int
    let items: [Dust]
    let pageNo, numOfRows: Int
}

struct Header: Codable {
    let resultMsg, resultCode: String
}

final class Dust: Codable {
    private let pm10Grade: String?
    let time: String?
    let gunguName: String?
    private let sidoName: String?
    var isLiked: Bool = false
        
    enum CodingKeys: String, CodingKey {
        case pm10Grade
        case time = "dataTime"
        case gunguName = "stationName"
        case sidoName
    }
    
    var location: String? {
        guard let gunguName = gunguName else {
            return nil
        }
        guard let sidoName = sidoName else {
            return nil
        }
        return "\(sidoName) \(gunguName)"
    }
    var info: (grade: String, color: UIColor)? {
        guard let pm10Grade = pm10Grade else {
            return nil
        }
        switch pm10Grade {
        case "1":
            return ("좋음", .systemGreen)
        case "2":
            return ("보통", .systemBlue)
        case "3":
            return ("한때나쁨", .systemBrown)
        case "4":
            return ("나쁨", .systemGray)
        case "5":
            return ("매우나쁨", .systemRed)
        default:
            return nil
        }
    }

}
