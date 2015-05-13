//
//  MemeObject.swift
//  MemeMe
//
//  Created by Mark Zhang on 15/5/7.
//  Copyright (c) 2015年 Mark Zhang. All rights reserved.
//

import UIKit

class MemeObject {
    
    var topText: String
    var bottomText: String
    var originImage: UIImage?
    var memedImage: UIImage?
    
    init(text1: String, text2: String, image1: UIImage, image2: UIImage) {
        topText = text1
        bottomText = text2
        originImage = image1
        memedImage = image2
    }
    
   
}
