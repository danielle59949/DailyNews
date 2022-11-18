//
//  BaseViewController.swift
//  Base
//
//  Created by Daniel Le on 18/11/2022.
//

import Foundation
import Base

open class BaseViewController: UIViewController {
    open func showError(error: Error, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
