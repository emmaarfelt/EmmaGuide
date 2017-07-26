//
//  Extensions.swift
//  
//
//  Created by Emma Arfelt Kock on 26/07/2017.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}





