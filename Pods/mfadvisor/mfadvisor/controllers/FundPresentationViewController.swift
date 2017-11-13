//
//  FundPresentationViewController.swift
//  mfadvisor
//
//  Created by Anurag Dake on 08/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import Core
import CoreData
import PDFGenerator

/**
 Displays pages for generating PDF
 Also handles PDF generationand sharing
 */
class FundPresentationViewController: UIViewController,UIDocumentInteractionControllerDelegate {
    
    @IBOutlet weak var actionBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fundPresentationScrollView: UIScrollView!
    @IBOutlet weak var fundPresentationScrollContentView: UIView!
    @IBOutlet weak var scrollContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var floatingShareButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    
    
    var fundPresentationPresenter: FundPresentationPresenter!
    var managedObjectContext: NSManagedObjectContext?
    var mFSelectionItem: MFSelectionItem?
    var customerName: String?
    
    var controller : UIDocumentInteractionController?
    var pdfPages = [UIView]()
    var isFromPagerView = false
    
    private let pdfDirectory = "SmartSell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fundPresentationPresenter = FundPresentationPresenter(fundPresentationViewController: self)
        fundPresentationPresenter.makeViewCircular(view: floatingShareButton)
        if isFromPagerView {
            statusBarHeightConstraint.constant = 0
            actionBarHeightConstraint.constant = 0
            closeButton.isHidden = false
        }
        initialiseUI()
    }
    
    func initialiseUI(){
        guard let selectionItem = mFSelectionItem else {
            return
        }
        let screenWidth = UIScreen.main.bounds.width
        let scrollViewHeight = UIScreen.main.bounds.maxY - fundPresentationScrollView.frame.origin.y
        scrollContentViewHeight.constant = 0
        var pageNumber = 1
        
        let page1 = fundPresentationPresenter.page1View(mFSelectionItem: selectionItem, scrollView: fundPresentationScrollView, pageWidth: screenWidth, pageHeight: scrollViewHeight, customerName: customerName)
        fundPresentationScrollContentView.addSubview(page1)
        pdfPages.append(page1)
        
        let seperator1 = fundPresentationPresenter.seperatorView(x: 0, y: page1.frame.maxY, width: screenWidth)
        fundPresentationScrollContentView.addSubview(seperator1)
        
        var lastFundSeperatorView: UIView = seperator1
        for (index, fund) in (mFSelectionItem?.fundItems ?? []).enumerated() {
            if fund.lumpSum != nil || fund.sip != nil{
                pageNumber = pageNumber + 1
                let fundPage = fundPresentationPresenter.pageFundView(fundItem: fund, scrollView: fundPresentationScrollView, pageWidth: screenWidth, pageHeight: scrollViewHeight, pageNumber: pageNumber)
                fundPage.frame = CGRect(x: 0, y: index == 0 ? seperator1.frame.maxY : lastFundSeperatorView.frame.maxY, width: screenWidth, height: scrollViewHeight)
                
                fundPresentationScrollContentView.addSubview(fundPage)
                pdfPages.append(fundPage)
                
                let seperator1 = fundPresentationPresenter.seperatorView(x: 0, y: fundPage.frame.maxY, width: screenWidth)
                fundPresentationScrollContentView.addSubview(seperator1)
                
                pageNumber = pageNumber + 1
                let investmentStrategyPage = fundPresentationPresenter.investmentStrategyPage(fundId: fund.fundId ?? "0", fundName: fund.fundName ?? "", scrollView: fundPresentationScrollView, pageWidth: screenWidth, pageHeight: scrollViewHeight, pageNumber: pageNumber, managedObjectContext: managedObjectContext!)
                investmentStrategyPage.frame = CGRect(x: 0, y: seperator1.frame.maxY, width: screenWidth, height: scrollViewHeight)
                fundPresentationScrollContentView.addSubview(investmentStrategyPage)
                pdfPages.append(investmentStrategyPage)
                
                let seperator2 = fundPresentationPresenter.seperatorView(x: 0, y: investmentStrategyPage.frame.maxY, width: screenWidth)
                fundPresentationScrollContentView.addSubview(seperator2)
                
                pageNumber = pageNumber + 1
                let portfolioAllocationPage = fundPresentationPresenter.portfolioAllocationPage(fundId: fund.fundId ?? "0", fundName: fund.fundName ?? "", scrollView: fundPresentationScrollView, pageWidth: screenWidth, pageHeight: scrollViewHeight, pageNumber: pageNumber, managedObjectContext: managedObjectContext!)
                portfolioAllocationPage.frame = CGRect(x: 0, y: seperator2.frame.maxY, width: screenWidth, height: scrollViewHeight)
                fundPresentationScrollContentView.addSubview(portfolioAllocationPage)
                pdfPages.append(portfolioAllocationPage)
                
                let seperator3 = fundPresentationPresenter.seperatorView(x: 0, y: portfolioAllocationPage.frame.maxY, width: screenWidth)
                fundPresentationScrollContentView.addSubview(seperator3)
                
                scrollContentViewHeight.constant = scrollContentViewHeight.constant + (fundPage.frame.height * 3) + (seperator1.frame.height * 3)
                lastFundSeperatorView = seperator3
            }
        }
        pageNumber = pageNumber + 1
        let tenureAndLiquidityPage = fundPresentationPresenter.tenureAndLiquidityPageView(mFSelectionItem: selectionItem, scrollView: fundPresentationScrollView, pageWidth: screenWidth, pageHeight: scrollViewHeight, pageNumber: pageNumber)
        tenureAndLiquidityPage.frame = CGRect(x: 0, y: lastFundSeperatorView.frame.maxY, width: screenWidth, height: tenureAndLiquidityPage.frame.height)
        fundPresentationScrollContentView.addSubview(tenureAndLiquidityPage)
        pdfPages.append(tenureAndLiquidityPage)
        
        scrollContentViewHeight.constant = scrollContentViewHeight.constant + page1.frame.height + seperator1.frame.height + tenureAndLiquidityPage.frame.height
        
        if (mFSelectionItem?.fundItems ?? []).count > 1{
            let seperator2 = fundPresentationPresenter.seperatorView(x: 0, y: tenureAndLiquidityPage.frame.maxY, width: screenWidth)
            fundPresentationScrollContentView.addSubview(seperator2)
            
            pageNumber = pageNumber + 1
            let riskometerPage = fundPresentationPresenter.riskometerPageView(mFSelectionItem: selectionItem, scrollView: fundPresentationScrollView, pageWidth: screenWidth, pageHeight: scrollViewHeight, pageNumber: pageNumber)
            riskometerPage.frame = CGRect(x: 0, y: seperator2.frame.maxY, width: screenWidth, height: scrollViewHeight)
            fundPresentationScrollContentView.addSubview(riskometerPage)
            pdfPages.append(riskometerPage)
            
            scrollContentViewHeight.constant = scrollContentViewHeight.constant + seperator2.frame.height + riskometerPage.frame.height
        }
        
    }
    
    @IBAction func onHomeButtonTap(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func onFloatingShareTap(_ sender: UIButton) {
        showChangePdfNameDialog()
    }
    
    ///Shows alert to change pdf file name
    func showChangePdfNameDialog(){
        let date = Date()
        let calender = Calendar.current
        let defaultFileName = "Presentation For\(" \(customerName ?? "")") \(calender.component(.day, from: date))-\(calender.component(.month, from: date))"
        
        let alertController = UIAlertController(title: "Change File Name?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField {(textfield) in
            textfield.text = defaultFileName
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler:{[weak self] (alertAction) in
            if let textField = alertController.textFields?[0] {
                self?.generateAndSharePdf(fileName: textField.text ?? "")
            }
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func generateAndSharePdf(fileName: String){
        guard !fileName.isEmpty, let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) else {
            return
        }
        
        do{
            try FileManager.default.createDirectory(atPath: NSTemporaryDirectory().appending(pdfDirectory), withIntermediateDirectories: true, attributes: nil)
            clearTmpDirectory()
            
            let filePath = URL(fileURLWithPath: NSTemporaryDirectory().appending("\(pdfDirectory)/\(fileName).pdf"))
            print(filePath)
            
            let loadingController = AlertViewHelper(alertViewCallbackProtocol: nil).loadingAlertViewController(title: NSLocalizedString("CREATE_PDF_FILE", tableName: nil, bundle: bundle, value: "", comment: ""), message: "\n\n")
            present(loadingController, animated: true, completion: nil)
            try PDFGenerator.generate(pdfPages, to: filePath)
            loadingController.dismiss(animated: false, completion: {[weak self] in
                self?.controller = UIDocumentInteractionController.init(url: filePath)
                self?.controller?.delegate = self
                self?.controller?.presentOptionsMenu(from: CGRect.zero, in: self?.view ?? UIView(), animated: true)
            })
            
            if !NetworkChecker().isConnectedToNetwork(){
                Toast(with: NSLocalizedString("INTERNET_ERROR_MSG", tableName: nil, bundle: bundle, value: "", comment: "")).show()
            }
            fundPresentationPresenter.updateShareCount()
        } catch (let error) {
            print(error)
        }
    }
    
    func documentInteractionControllerDidDismissOptionsMenu(_ controller: UIDocumentInteractionController) {
        self.controller = nil
    }
    
    func clearTmpDirectory() {
        do {
            let tmpDirectory = try FileManager.default.contentsOfDirectory(atPath: NSTemporaryDirectory().appending(pdfDirectory))
            
            for i in 0..<tmpDirectory.count{
                let path = String.init(format: "%@/%@", NSTemporaryDirectory().appending(pdfDirectory), tmpDirectory[i])
                if path.contains(".pdf"){
                    try FileManager.default.removeItem(atPath: path)
                }
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onCloseButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
