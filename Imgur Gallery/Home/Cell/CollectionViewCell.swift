//
//  CollectionViewCell.swift
//  Imgur Gallery
//
//  Created by Mariana Brasil on 03/09/21.
//

import UIKit

class CustomCell: UICollectionViewCell {
    
    public var img: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(img)
        
        img.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        img.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        img.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        img.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var data: CustomData?{
        didSet{
            guard let data = data else { return }
            img.image = data.image
        }
    }

}
