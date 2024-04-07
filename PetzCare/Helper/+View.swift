//
//  +View.swift
//  PetzCare
//
//  Created by Talita Albuquerque Araújo on 07/04/24.
//

import Foundation
import SwiftUI

extension View {
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }

        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}
