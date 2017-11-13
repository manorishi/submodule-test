//
//  LiveMarketView.swift
//  mfadvisor
//
//  Created by Anurag Dake on 11/09/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import Core

public class LiveMarketView: UIView{
    
    //BSE
    @IBOutlet weak var bseIndexLabel: UILabel!
    @IBOutlet weak var bseDaysChangeLabel: UILabel!
    @IBOutlet weak var bseChangeIndicatorLabel: UILabel!
    @IBOutlet weak var bseOpenLabel: UILabel!
    @IBOutlet weak var bsePrevCloseLabel: UILabel!
    
    //Nifty
    @IBOutlet weak var nseIndexLabel: UILabel!
    @IBOutlet weak var nseDaysChangeLabel: UILabel!
    @IBOutlet weak var nseChangeIndicatorLabel: UILabel!
    @IBOutlet weak var nseOpenLabel: UILabel!
    @IBOutlet weak var nsePrevCloseLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    let upArrowUnicode = "\u{25B2}"
    let downArrowUnicode = "\u{25BC}"
    
    
    public func setMarketData(marketData: MarketData){
        bseIndexLabel.text = marketData.bseIndex ?? ""
        bseDaysChangeLabel.text = marketData.bseDaysChange ?? ""
        bseOpenLabel.text = ": \(marketData.bseOpen ?? "")"
        bsePrevCloseLabel.text = ": \(marketData.bsePrevClose ?? "")"
        setIndicatorImageAndColor(changeIndicatorLabel: bseChangeIndicatorLabel, daysChangeLabel: bseDaysChangeLabel, change: marketData.bseDaysChange)
        
        nseIndexLabel.text = marketData.nseIndex ?? ""
        nseDaysChangeLabel.text = marketData.nseDaysChange ?? ""
        nseOpenLabel.text = ": \(marketData.nseOpen ?? "")"
        nsePrevCloseLabel.text = ": \(marketData.nsePrevClose ?? "")"
        setIndicatorImageAndColor(changeIndicatorLabel: nseChangeIndicatorLabel, daysChangeLabel: nseDaysChangeLabel, change: marketData.nseDaysChange)
        
        dateLabel.text = "Data as on: \(marketData.dataDate ?? "-")"
    }
    
    private func setIndicatorImageAndColor(changeIndicatorLabel: UILabel, daysChangeLabel: UILabel, change: String?){
        guard let marketChange = change, let changeValue = Float(marketChange) else {
            changeIndicatorLabel.text = ""
            return
        }
        changeIndicatorLabel.text = changeValue >= 0 ? upArrowUnicode : downArrowUnicode
        let textColor = hexStringToUIColor(hex: changeValue >= 0 ? MFColors.MARKET_GREEN : MFColors.MARKET_RED)
        changeIndicatorLabel.textColor = textColor
        daysChangeLabel.textColor = textColor
        
    }
    
    
    
}
