//
//  SiteTopTableViewCell.swift
//  FashionRecognition
//
//  Created by 安高慎也 on 2016/03/02.
//  Copyright © 2016年 aaddyy. All rights reserved.
//

import UIKit

class SiteTopTableViewCell: UITableViewCell {
    @IBOutlet weak var willRegister: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setSiteImageView()
    }
    
    func setSiteImageView(){
        self.willRegister.contentMode = UIViewContentMode.ScaleAspectFit
        self.willRegister.layer.masksToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
