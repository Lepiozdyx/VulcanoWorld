//
//  VolcanoCoordinate.swift
//  VolcanoWorld
//
//  Created by Алексей Авер on 16.10.2025.
//

import Foundation
import MapKit

struct VolcanoCoordinate: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
