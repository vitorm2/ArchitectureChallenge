//
//  MovieComponent.swift
//  ArchitectureChallenge
//
//  Created by Vitor Demenighi on 19/08/19.
//  Copyright © 2019 Vitor Demenighi. All rights reserved.
//

import UIKit


class MovieComponent: UIView {
    
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieVoteAverage: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibInit()
    }
    
    func xibInit() {
        Bundle.main.loadNibNamed("MovieComponent", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
    }
    
    
}

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        
        get{
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = borderColor?.cgColor
        }
    }
}
