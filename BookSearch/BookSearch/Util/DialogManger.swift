//
//  DialogManger.swift
//  BookSearch
//
//  Created by 강휘 on 2022/12/01.
//

import UIKit


final class DialogManager {
    static func getDialog(title: String, message: String, handler: @escaping () -> Void = {}) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionConfirm = UIAlertAction(title: "확인", style: .cancel) { _ in
            handler()
        }
        alert.addAction(actionConfirm)
        return alert
    }
}
