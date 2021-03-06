//
//  ErrorView.swift
//  ArchitectureChallenge
//
//  Created by Vitor Demenighi on 20/08/19.
//  Copyright © 2019 Vitor Demenighi. All rights reserved.
//

import UIKit


protocol ErrorDelegate {
    func tryAgainButtonTouched()
}

class ErrorView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet weak var errorTitle: UILabel!
    @IBOutlet weak var errorDescription: UILabel!
    @IBOutlet weak var errorButton: UIButton!
    
    var delegate: ErrorDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibInit()
    }
    
    func xibInit() {
        Bundle.main.loadNibNamed("ErrorView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
    }
    
    @IBAction func tryAgainAction(_ sender: Any) {
        delegate?.tryAgainButtonTouched()
    }
}
