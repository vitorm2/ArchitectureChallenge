//
//  HeaderView.swift
//  ArchitectureChallenge
//
//  Created by Rovane Moura on 16/08/19.
//  Copyright © 2019 Vitor Demenighi. All rights reserved.
//

import UIKit

class HeaderView : UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibInit()
    }
    
    func xibInit() {
        
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        
    }
    
}
