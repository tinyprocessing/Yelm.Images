//
//  structures.swift
//  ImagesPicker
//
//  Created by Michael on 17.01.2021.
//

import Foundation
import Photos
import SwiftUI


struct images: Hashable {
    var id: Int
    var image_asset : PHAsset
}

struct selected_images: Hashable{
    var id: Int
    var image_asset : PHAsset
}
