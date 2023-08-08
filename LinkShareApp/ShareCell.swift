//
//  ShareCell.swift
//  LinkShareApp
//
//  Created by Faiz Ul Hassan on 08/08/2023.
//

import Foundation
import UIKit


struct CellModel {
    var image: UIImage?
    var url:URL?
}

class ImageCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgViewwidth: NSLayoutConstraint!
    @IBOutlet weak var imgViewHeight: NSLayoutConstraint!
    
    var item: CellModel? {
        didSet {
            self.configure(item)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ item: CellModel?) {
        if let model = item {
            self.imgView.image = model.image
        }
    }
    
}
