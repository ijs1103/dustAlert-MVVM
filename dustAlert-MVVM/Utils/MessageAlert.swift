//
//  MessageAlert.swift
//  dustAlert
//
//  Created by 이주상 on 2023/02/17.
//

import UIKit

extension UIViewController {
    func messageAlert(message: String, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "메시지", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { okAction in
            completion(true)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { cancelAction in
            completion(false)
        }
        [ ok, cancel ].forEach {
            alert.addAction($0)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
