//
//  SalesPitchViewController.swift
//  mfadvisor
//
//  Created by Apple on 04/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import CoreData

/**
 SalesPitchViewController displays salespitch qa data with expand/collapse view
 It is shown as tab of FundDetailViewController
 */
class SalesPitchViewController: UIViewController,IndicatorInfoProvider,UITableViewDelegate, UITableViewDataSource {

    /// TableView cell identofiers
    let fundQuestionCellIdentifier = "fundQuestionCell"
    let fundAnswerImageCellIdentifier = "fundAnswerImageCell"
    let fundAnswerCellIdentifier = "fundAnswerCell"
    let fundAnswerHeaderCellIdentifier = "fundAnswerHeaderCell"
    
    @IBOutlet weak var fundNameLabel: UILabel!
    @IBOutlet weak var salesPitchTableView: UITableView!
    
    var moduleBundle:Bundle? = nil
    var salesPitchDataArray = [SalesPitchData]()
    var questionLabelWidth:CGFloat = 199
    public var tabTitle: String?
    
    public var managedObjectContext:NSManagedObjectContext?
    public var fundId:String!
    public var fundName:String?
    var salesPitchPresenter: SalesPitchPresenter!
    var lastSelectedCellPath:IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moduleBundle = BundleManager().loadResourceBundle(coder: self.classForCoder)
        questionLabelWidth = UIScreen.main.bounds.size.width - 121
        salesPitchPresenter = SalesPitchPresenter.init(salesPitchViewController: self)
        self.view.backgroundColor = MFColors.VIEW_BACKGROUND_COLOR
        configTableView()
        fundSalesPitchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFundName()
        if #available(iOS 9.0, *)  {
        }
        else {
            salesPitchTableView.reloadData()
        }
        if let parentVC = self.parent as? FundDetailViewController {
            parentVC.fundDetailTitleLabel.text = fundName ?? ""
        }
    }
    
    func updateFundName() {
        if fundName == nil {
            fundName = salesPitchPresenter.fundNameFrom(fundId: fundId, managedObjectContext: managedObjectContext!)
        }
        fundNameLabel.text = fundName ?? ""
    }
    
    func configTableView() {
        salesPitchTableView.delegate = self
        salesPitchTableView.dataSource = self
        registerTableViewCell()
    }
    
    func fundSalesPitchData() {
        salesPitchDataArray = salesPitchPresenter.getFundSalesPitchData(fundId:fundId , managedObjectContext: managedObjectContext!)
        salesPitchTableView.reloadData()
    }
    
    /**
     Register tableview view cell.
     */
    func registerTableViewCell() {
        if let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) {
            salesPitchTableView.register(UINib(nibName: "FundQuestionTableViewCell", bundle: bundle), forCellReuseIdentifier: fundQuestionCellIdentifier)
            salesPitchTableView.register(UINib(nibName: "AnswerImageTableViewCell", bundle: bundle), forCellReuseIdentifier: fundAnswerImageCellIdentifier)
            salesPitchTableView.register(UINib(nibName: "FundAnswerTableViewCell", bundle: bundle), forCellReuseIdentifier: fundAnswerCellIdentifier)
            salesPitchTableView.register(UINib(nibName: "AnswerHeaderTableViewCell", bundle: bundle), forCellReuseIdentifier: fundAnswerHeaderCellIdentifier)
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        if let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) {
            if tabTitle == nil{
                tabTitle = NSLocalizedString("SALES_PITCH", tableName: nil, bundle: bundle, value: "", comment: "")
            }
            return IndicatorInfo(title: tabTitle ?? "")
        }
        return IndicatorInfo(title: "")
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = salesPitchDataArray.count
        for fundDataItems in salesPitchDataArray {
            count += fundDataItems.answerCount
        }
        return count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = salesPitchPresenter.getSectionIndex(row: indexPath.row, dataArray: salesPitchDataArray)
        let row = salesPitchPresenter.getRowIndex(row: indexPath.row, dataArray: salesPitchDataArray)
        let salesPitchData = salesPitchDataArray[section]
        
        switch row {
        case 0:
            return salesPitchPresenter.questionHeight(question: salesPitchData.question, collapsed: salesPitchData.collapsed, questionLabelWidth: questionLabelWidth)
        case 1:
            return salesPitchPresenter.answerImageHeight(imageName: salesPitchData.answerImage, collapsed: salesPitchData.collapsed)
        case 2,7:
            return salesPitchPresenter.answerHeaderFooterHeight(message: row == 2 ? salesPitchData.answerTopline : salesPitchData.answerBottomline, collapsed: salesPitchData.collapsed)
        case 3,4,5,6:
            switch row {
            case 3:
                return salesPitchPresenter.answerHeight(answerData: salesPitchData.answer1, collapsed: salesPitchData.collapsed)
            case 4:
                return salesPitchPresenter.answerHeight(answerData: salesPitchData.answer2, collapsed: salesPitchData.collapsed)
            case 5:
                return salesPitchPresenter.answerHeight(answerData: salesPitchData.answer3, collapsed: salesPitchData.collapsed)
            case 6:
                return salesPitchPresenter.answerHeight(answerData: salesPitchData.answer4, collapsed: salesPitchData.collapsed)
            default:
                return 0
            }
        default:
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = salesPitchPresenter.getSectionIndex(row: indexPath.row, dataArray: salesPitchDataArray)
        let row = salesPitchPresenter.getRowIndex(row: indexPath.row, dataArray: salesPitchDataArray)
        let data = salesPitchDataArray[section]
        
        switch row {
        case 0:
            // Fund question cell
            let cell = tableView.dequeueReusableCell(withIdentifier: fundQuestionCellIdentifier) as! FundQuestionTableViewCell
            addTapGesture(cell: cell)
            cell.tag = section
            cell.setData(questionIcon: data.questionIcon, question: data.question, bundle: moduleBundle)
            data.collapsed ? cell.updateViewToCollapse() : cell.updateViewToExpand()
            return cell
        case 1:
            //  Answer image cell
            let cell = tableView.dequeueReusableCell(withIdentifier: fundAnswerImageCellIdentifier) as! AnswerImageTableViewCell
            cell.tag = section
            cell.setData(imageName: data.answerImage, bundle: moduleBundle)
            return cell
        case 2,7:
            // Answer header and footer cell
            let cell = tableView.dequeueReusableCell(withIdentifier: fundAnswerHeaderCellIdentifier) as! AnswerHeaderTableViewCell
            cell.tag = section
            cell.setData(message: row == 2 ? data.answerTopline : data.answerBottomline)
            return cell
        case 3,4,5,6:
            // Answer cell
            let cell = tableView.dequeueReusableCell(withIdentifier: fundAnswerCellIdentifier) as! FundAnswerTableViewCell
            cell.tag = section
            switch row {
            case 3:
                cell.setData(answerData: data.answer1, bundle: moduleBundle, isCollapsed:data.collapsed)
            case 4:
                cell.setData(answerData: data.answer2, bundle: moduleBundle, isCollapsed:data.collapsed)
            case 5:
                cell.setData(answerData: data.answer3, bundle: moduleBundle, isCollapsed:data.collapsed)
            case 6:
                cell.setData(answerData: data.answer4, bundle: moduleBundle, isCollapsed:data.collapsed)
            default:
                cell.setData(answerData: data.answer1, bundle: moduleBundle, isCollapsed:data.collapsed)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            print(#function)
        }
    }
    
    func addTapGesture(cell:UITableViewCell) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleCollapse(sender:)))
        tapGesture.numberOfTapsRequired = 1
        cell.addGestureRecognizer(tapGesture)
    }
    
    //
    // MARK: - Event Handlers
    //
    func toggleCollapse(sender: UITapGestureRecognizer) {
        
        guard let section = sender.view?.tag
            else {
                return
        }
        let data = salesPitchDataArray[section]
        if data.isExpandable {
            let collapsed = data.collapsed
            if collapsed {
                collapsePreviousCells()
                lastSelectedCellPath = IndexPath(row: section, section: 0)
            }
            else {
                lastSelectedCellPath = nil
            }
            // Toggle collapse
            data.collapsed = !collapsed
            
            let indices = salesPitchPresenter.getHeaderIndices(dataArray: salesPitchDataArray)
            
            let start = indices[section]
            let end = start + data.answerCount
            
            if #available(iOS 9.0, *) {
                salesPitchTableView.beginUpdates()
                for i in start ..< end + 1 {
                    salesPitchTableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
                }
                if !data.collapsed {
                    salesPitchTableView.scrollToNearestSelectedRow(at: .middle, animated: true)
                }
                salesPitchTableView.endUpdates()
            }
            else {
                salesPitchTableView.reloadData()
            }
        }
    }
    
    ///Collapse previous expanded cells
    func collapsePreviousCells() {
        if lastSelectedCellPath != nil {
            if let section = lastSelectedCellPath?.row {
                let data = salesPitchDataArray[section]
                data.collapsed = true
                salesPitchTableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
