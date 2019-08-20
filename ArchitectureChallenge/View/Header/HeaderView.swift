//
//  HeaderView.swift
//  ArchitectureChallenge
//
//  Created by Rovane Moura on 16/08/19.
//  Copyright © 2019 Vitor Demenighi. All rights reserved.
//

import UIKit

protocol HeaderDelegate {
    func seeAllButtonTouched()
}

class HeaderView : UITableViewHeaderFooterView {
    
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    public var delegate: HeaderDelegate?
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        xibInit()
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        xibInit()
//    }
    
//    func xibInit() {
//        
//        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
//        addSubview(contentView)
//        // self.backgroundColor = .red
//        // self.contentView.backgroundColor = .cyan
//        self.contentView.bounds = self.bounds
//        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        
//    }
    
    @IBAction func seeAllAction(_ sender: Any) {
        delegate?.seeAllButtonTouched()
    }
    
    
}
