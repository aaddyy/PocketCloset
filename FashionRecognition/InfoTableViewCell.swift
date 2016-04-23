//
//  InfoTableViewCell.swift
//  FashionRecognition
//
//  Created by 安高慎也 on 2016/03/02.
//  Copyright © 2016年 aaddyy. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descript: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title.textColor = imageColor
        descript.textColor = UIColor.grayColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
