//
//  AnswerHeaderTableViewCell.swift
//  mfadvisor
//
//  Created by Apple on 06/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import Core

/**
 AnswerHeaderTableViewCell is cell item for answer header item on salespitch screen to show text such as disclaimer
 */
class AnswerHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var disclaimerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disclaimerLabel.attributedText = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(message:String?) {
        if message != nil {
            self.disclaimerLabel.text = message ?? ""
        }
        else{
            self.disclaimerLabel.text = nil
            self.disclaimerLabel.attributedText = nil
        }
    }
    
}
