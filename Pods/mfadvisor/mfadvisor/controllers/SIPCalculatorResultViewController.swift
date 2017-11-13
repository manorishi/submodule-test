//
//  SIPCalculatorResultViewController.swift
//  mfadvisor
//
//  Created by Anurag Dake on 16/09/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

public class SIPCalculatorResultViewController: UIViewController{
    
    @IBOutlet weak var calculatorResultView: UIView!
    @IBOutlet weak var illustrationForLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var monthlyAmountLabel: UILabel!
    @IBOutlet weak var tenureLabel: UILabel!
    @IBOutlet weak var expectedReturnsLabel: UILabel!
    @IBOutlet weak var totalInvestmentLabel: UILabel!
    @IBOutlet weak var totalReturnsLabel: UILabel!
    @IBOutlet weak var disclaimerLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    var customerName: String?
    var monthlyAmount: String?
    var tenure: String?
    var expectedReturns: String?
    var totalInvestment: String?
    var totalReturns: String?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        initialiseUI()
        displayResult()
    }
    
    func initialiseUI(){
        shareButton.layer.cornerRadius = shareButton.frame.height / 2
    }
    
    func displayResult(){
        if let name = customerName, name.trimmingCharacters(in: .whitespacesAndNewlines) != "Mr."{
            nameLabel.text = name
        }else{
            illustrationForLabel.text = ""
            nameLabel.text = ""
        }
        monthlyAmountLabel.text = monthlyAmount ?? ""
        tenureLabel.text = tenure ?? ""
        expectedReturnsLabel.text = expectedReturns ?? ""
        totalInvestmentLabel.text = totalInvestment ?? ""
        totalReturnsLabel.text = totalReturns ?? ""
        disclaimerLabel.text = disclaimerText()
    }
    
    func disclaimerText() -> String{
        let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) ?? Bundle.main
        return String(format: NSLocalizedString("disclaimer_text", tableName: nil, bundle: bundle, value: "", comment: ""), expectedReturns ?? "0")
    }
    
    
    @IBAction func onShareButtonTap(_ sender: UIButton) {
        if let image = createCalculatorResultImage(view: calculatorResultView) {
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: [])
            activityViewController.excludedActivityTypes = [.assignToContact]
            present(activityViewController, animated: true)
        }
    }
    
    func createCalculatorResultImage(view: UIView) -> UIImage?{
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let snapshotImageFromView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImageFromView
    }
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onHomeButtonTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
