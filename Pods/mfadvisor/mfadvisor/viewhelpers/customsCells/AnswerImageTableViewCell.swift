//
//  AnswerImageTableViewCell.swift
//  mfadvisor
//
//  Created by Apple on 05/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import Core

/**
 AnswerImageTableViewCell is cell item for answer image item on salespitch screen
 */
class AnswerImageTableViewCell: UITableViewCell {

    @IBOutlet weak var answerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.clipsToBounds = true
    }

    func setData(imageName:String?,bundle:Bundle?) {
        if imageName != nil && bundle != nil {
            self.answerImageView.image = UIImage(named: imageName ?? "", in: bundle, compatibleWith: nil)
        }
        else {
            self.answerImageView.image = nil
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
