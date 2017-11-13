//
//  FundSelectionButtonManager.swift
//  mfadvisor
//
//  Created by Anurag Dake on 27/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

@objc protocol FundSelectionDelegate {
    @objc func didSelectButton(selectedButton: FundSelectionButton?)
}

/**
 FundSelectionButtonManager manages the group of FundSelectionButtons to operate as radio group
 */
class FundSelectionButtonManager: NSObject{
    
    private var buttonsArray = [FundSelectionButton]()
    weak var delegate : FundSelectionDelegate? = nil
    
    init(buttons: FundSelectionButton...) {
        super.init()
        for button in buttons {
            button.addTarget(self, action: #selector(FundSelectionButtonManager.pressed(_:)), for: UIControlEvents.touchUpInside)
        }
        self.buttonsArray = buttons
    }
    
    func pressed(_ sender: FundSelectionButton) {
        if(!sender.isSelected) {
            for button in buttonsArray {
                button.isSelected = false
            }
            sender.isSelected = true
        }
        delegate?.didSelectButton(selectedButton: sender)
    }
    
    func selectButton(button: FundSelectionButton){
        pressed(button)
    }
    
    func unselectAllButtons(){
        for button in buttonsArray {
            button.isSelected = false
        }
    }
    
    /**
     Get the currently selected button.
     */
    func selectedButton() -> FundSelectionButton? {
        guard let index = buttonsArray.index(where: { button in button.isSelected }) else { return nil }
        return buttonsArray[index]
    }
}
