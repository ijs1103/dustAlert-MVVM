//
//  Const.swift
//  dustAlert
//
//  Created by 이주상 on 2023/02/02.
//

import Foundation

struct Const {
    static let SIDO_DUST_URL = "http://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getCtprvnRltmMesureDnsty"
    static let DANGER_ZONE_DUST_URL = "http://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getUnityAirEnvrnIdexSnstiveAboveMsrstnList"
    static let SidoArr = [ "서울",
                    "부산",
                    "대구",
                    "인천",
                    "광주",
                    "대전",
                    "울산",
                    "경기",
                    "강원",
                    "충북",
                    "충남",
                    "전북",
                    "전남",
                    "경북",
                    "경남",
                    "제주",
                    "세종", ]
    private init() {}
}
