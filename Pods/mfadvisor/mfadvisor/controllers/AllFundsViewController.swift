//
//  AllFundsViewController.swift
//  mfadvisor
//
//  Created by Apple on 02/05/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/**
 AllFundsScreenProtocol pass fund data to presenter on selecting one of the option for fund
 */
protocol AllFundsScreenProtocol {
    func selectedSalesPitchFundData(_ fundata:FundData, fundOptionType:FundOptionsType)
}

/**
 AllFundsViewController displays all funds list with categories.
 It also handles expand/collapse to show different options available for fund.
 */
public class AllFundsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var allFundsTableView: UITableView!
    
    var allFundsDataArray = [AllFundData]()
    let fundCollapsedCellIdentifier = "fundCollapsedCell"
    let fundOptionsCellIdentifier = "fundOptionsCell"
    var fundTitleWidth:CGFloat = 238 //Fund title width. Initialised with default value.
    public var managedObjectContext:NSManagedObjectContext?
    var allFundsPresenter: AllFundsPresenter!
    var eventHandler : AllFundsScreenProtocol!
    var lastSelectedCellPath:IndexPath? = nil
    public var isExpandable = true
    public var fundOptionType:FundOptionsType? = nil
    private var marketView: LiveMarketView?
    private var isTableHeaderAdded = false
    private let CORE_IDENTIFIER = "org.cocoapods.Core"
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        fundTitleWidth = UIScreen.main.bounds.size.width - 82
        configTableView()
        addBackgroundImage()
        allFundsPresenter = AllFundsPresenter.init(allFundsViewController: self)
        self.eventHandler = allFundsPresenter
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mfaData()
    }
    
    /// Configure table view
    func configTableView() {
        self.allFundsTableView.delegate = self
        self.allFundsTableView.dataSource = self
        self.allFundsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.allFundsTableView.frame.size.width, height: 0.1))
        registerTableViewCell()
        
    }
    
    func addTableViewHeader(){
        guard let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) else {
            return
        }
        marketView = bundle.loadNibNamed("LiveMarketView", owner: self, options: nil)?[0] as? LiveMarketView
        marketView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 260)
        allFundsTableView.tableHeaderView = marketView
        isTableHeaderAdded = true
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard fundOptionType == nil else{
            return
        }
        if !isTableHeaderAdded{
            addTableViewHeader()
        }
        marketView?.activityIndicator.startAnimating()
        allFundsPresenter.marketData { [weak self] (status, marketData) in
            DispatchQueue.main.async {
                self?.marketView?.activityIndicator.stopAnimating()
                guard marketData != nil else{
                    return
                }
                self?.marketView?.setMarketData(marketData: marketData!)
            }
        }
    }
    private func addBackgroundImage(){
        backgroundImageView.image = UIImage(named: "background", in: Bundle(identifier: CORE_IDENTIFIER), compatibleWith: nil)
        allFundsTableView.backgroundColor = UIColor.clear
    }
    
    /**
     Register tableview view cell.
     */
    func registerTableViewCell() {
        if let bundle = BundleManager().loadResourceBundle(coder: self.classForCoder) {
            allFundsTableView.register(UINib(nibName: "FundTableViewCell", bundle: bundle), forCellReuseIdentifier: fundCollapsedCellIdentifier)
            allFundsTableView.register(UINib(nibName: "FundOptionsTableViewCell", bundle: bundle), forCellReuseIdentifier: fundOptionsCellIdentifier)
        }
    }
    
    /// Get data from local database
    func mfaData() {
        allFundsDataArray = allFundsPresenter.fundsDataList(isExpandable: isExpandable)
        allFundsTableView.reloadData()
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return allFundsDataArray.count
    }
    
    /// Calculate label height for header in section
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let categoryName = allFundsDataArray[section].categoryName
        
        let nameHeight = categoryName?.heightWithConstrainedWidth(tableView.frame.size.width - 16, font: UIFont.systemFont(ofSize: 16)) ?? 25
        
        if section == 0 {
            return nameHeight <= 25 ? 43 : nameHeight + 26
        }
        return nameHeight <= 25 ? 39 : nameHeight + 22
    }
    
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0))
        let headerLabel = UILabel(frame: CGRect(x: 8, y: section == 0 ? 12 : 8, width: tableView.frame.size.width - 16, height: 0))
        let data = allFundsDataArray[section]
        headerLabel.text = data.categoryName
        let nameHeight = data.categoryName?.heightWithConstrainedWidth(tableView.frame.size.width - 16, font: UIFont.systemFont(ofSize: 16)) ?? 25
        headerLabel.frame.size.height = nameHeight <= 25 ? 25 : nameHeight
        view.frame.size.height = nameHeight + 32
        headerLabel.font = UIFont.systemFont(ofSize: 16)
        headerLabel.numberOfLines = 0
        headerLabel.backgroundColor = UIColor.clear
        headerLabel.textColor = UIColor.darkGray
        view.addSubview(headerLabel)
        return view
    }
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = allFundsDataArray[section]
        
        var count = data.fundData.count
        for fundDataItems in data.fundData {
            count += fundDataItems.items.count
        }
        
        return count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = allFundsDataArray[indexPath.section]
        
        // Calculate the real section index and row index
        let section = allFundsPresenter.getSectionIndex(row: indexPath.row, tableViewSection: indexPath.section, dataArray: data.fundData)
        let row = allFundsPresenter.getRowIndex(row: indexPath.row, tableViewSection: indexPath.section, dataArray: data.fundData)
        
        //Header
        if row == 0 {
            /*let fundName = data.fundData[section].name
            let nameHeight = fundName?.heightWithConstrainedWidth(data.fundData[section].collapsed ? fundTitleWidth : fundTitleWidth + 50, font: UIFont.systemFont(ofSize: 16)) ?? 24
            
            return nameHeight <= 24 ? 56 : nameHeight + 32*/
            return 56.0
        }
        
        //Header subview
//        if data.fundData[section]. {
//            
//        }
        if row == data.fundData[section].items.count {
            return data.fundData[section].collapsed ? 0 : 61.0
        }
        
        return data.fundData[section].collapsed ? 0 : 56.0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = allFundsDataArray[indexPath.section]
        
        let section = allFundsPresenter.getSectionIndex(row: indexPath.row,tableViewSection: indexPath.section, dataArray: data.fundData)
        let row = allFundsPresenter.getRowIndex(row: indexPath.row, tableViewSection: indexPath.section, dataArray: data.fundData)
        
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: fundCollapsedCellIdentifier) as! FundTableViewCell
            cell.fundTitleLabel.text = data.fundData[section].name
            cell.fundInitialLabel.text = data.fundData[section].fundInitial
            cell.fundNAVLabel.text = String(format: "NAV: %.2f", data.fundData[section].fundNav ?? 0)
            if data.fundData[section].collapsed {
                cell.updateViewToCollapse()
            }
            else {
                cell.updateViewToExpand()
            }
            cell.indexPath = indexPath
            cell.tag = section
            if isExpandable {
                addTapGesture(cell: cell)
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: fundOptionsCellIdentifier) as! FundOptionsTableViewCell
            cell.fundOptionTitleLabel?.text = data.fundData[section].items[row - 1]
            cell.addFundOptionImage(row: row)
            
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async{[weak self] in
            let data = self?.allFundsDataArray[indexPath.section]
            // Calculate the real section index and row index
            let section = self?.allFundsPresenter.getSectionIndex(row: indexPath.row, tableViewSection: indexPath.section, dataArray: data?.fundData ?? [])
            let row = self?.allFundsPresenter.getRowIndex(row: indexPath.row, tableViewSection: indexPath.section, dataArray: data?.fundData  ?? [])
            if self?.isExpandable == true {
                if let fundOptionType = FundOptionsType(rawValue: row!) {
                    tableView.isUserInteractionEnabled = false
                    self?.eventHandler.selectedSalesPitchFundData((data?.fundData[section!])!, fundOptionType: fundOptionType)
                    tableView.isUserInteractionEnabled = true
                }
            }
            else if row == 0 {
                if let fundOptionType = self?.fundOptionType {
                    self?.eventHandler.selectedSalesPitchFundData((data?.fundData[section!])!, fundOptionType: fundOptionType)
                }
            }
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
        
        guard let fundTableViewCell = sender.view as? FundTableViewCell,
            let section = sender.view?.tag,
            let tableViewSection = fundTableViewCell.indexPath?.section
            else {
                return
        }
        let data = allFundsDataArray[tableViewSection]
        if data.isExpandable {
            let collapsed = data.fundData[section].collapsed
            if collapsed {
                collapsePreviousCells()
                lastSelectedCellPath = IndexPath(row: section, section: tableViewSection)
            }
            else {
                lastSelectedCellPath = nil
            }
            // Toggle collapse
            data.fundData[section].collapsed = !collapsed
            
            let indices = allFundsPresenter.getHeaderIndices(tableViewSection: tableViewSection, dataArray: data.fundData)
            
            let start = indices[section]
            let end = start + data.fundData[section].items.count
            
            if #available(iOS 9.0, *) {
                allFundsTableView.beginUpdates()
                for i in start ..< end + 1 {
                    allFundsTableView.reloadRows(at: [IndexPath(row: i, section: tableViewSection)], with: .automatic)
                }
                if !data.fundData[section].collapsed {
                    allFundsTableView.scrollToNearestSelectedRow(at: .middle, animated: true)
                }
                allFundsTableView.endUpdates()
            }
            else {
                allFundsTableView.reloadData()
            }
        }
    }
    
    ///Collapse previous expanded cells
    func collapsePreviousCells() {
        if lastSelectedCellPath != nil {
            if let tableViewSection = lastSelectedCellPath?.section, let section = lastSelectedCellPath?.row {
                let data = allFundsDataArray[tableViewSection]
                data.fundData[section].collapsed = true
                allFundsTableView.reloadData()
            }
        }
    }
    
    func gotoViewController(_ viewController:UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
//        self.present(viewController, animated: true, completion: nil)
    }
    
}
