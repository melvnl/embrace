//
//  FilterViewController.swift
//  MC-2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 16/06/22.
//

import Foundation
import UIKit

class FilterViewController : JournalParentVC, UITableViewDelegate, UITableViewDataSource{
    
    public var filteredEntries : [FilterGroup] = []
    public var filterType: JournalFilterType?
    let cellReuseIdentifier = "FilterGroupCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove current vc stack
        if let rootVC = navigationController?.viewControllers.first {
                navigationController?.viewControllers = [rootVC, self]
            }
        
        table.isHidden = false
        table.delegate = self
        table.dataSource = self
        
        // create bar item buttons
        let addBarButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.didTapNewNote(_:)))
        let filterBarButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.didTapFilter(_:)))
        
        addBarButton.tintColor = .black
        filterBarButton.tintColor = .black
        
        addBarButton.image = UIImage(systemName: "plus")
        filterBarButton.image = UIImage(systemName: "line.3.horizontal.decrease")
        
        navigationItem.rightBarButtonItems = [filterBarButton, addBarButton]
        
        // disable back button
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        journalRepo.fetchJournals { (entries) -> Void in
            self.filteredEntries = []
            self.entries = entries
            self.filterEntries()
        }
    }
    
    func filterEntries(){
        
        var previousEntry : Entry?
        for currEntry in entries {
            
            // check if in same time range than previous entry
            if (previousEntry != nil && compareDates(previousEntry!.date, currEntry.date)){
                // append counter
                filteredEntries[filteredEntries.count-1].count += 1
                previousEntry = currEntry
                print("same range")
            }
            else{
                //make new group & append
                let dateInterval = getDateInterval(date: currEntry.date)
                var subHeaderText = ""
                
                if (filterType == .week){
                    subHeaderText = "\(dateInterval.start.toString("d"))-\(dateInterval.end.toString("d")) \(currEntry.date.toString("LLLL"))"
                }
                
                let filterGroup = FilterGroup(
                    subHeader: subHeaderText,
                    header: getHeaderText(date: currEntry.date),
                    count: 1,
                    startDate: dateInterval.start,
                    endDate: dateInterval.end)
                
                filteredEntries.append(filterGroup)
                

                print("added group")
            }
            previousEntry = currEntry
        }
        
        table.delegate = self
        table.dataSource = self
        table.reloadData()
    }
    
    func getHeaderText(date: Date)-> String{
        let calendar = Calendar.current
        
        switch (filterType){
        case .week:
            return "Minggu ke-\(calendar.component(.weekOfMonth, from: date))"
        case .month:
            return "\(date.toString("LLLL"))"
        case .year:
            return date.toString("YYYY")
        case .none:
            break
        }
        
        return ""
    }
    
    // change this to date later
    func getDateInterval(date: Date)-> DateInterval{
        
        switch (filterType){
        case .week:
            return Calendar.current.dateInterval(of: .weekOfMonth, for: date)!
        case .month:
            return Calendar.current.dateInterval(of: .month, for: date)!
        case .year:
            return Calendar.current.dateInterval(of: .year, for: date)!
        case .none:
            break
        }
        
        return Calendar.current.dateInterval(of: .day, for: date)!
    }
    
    func compareDates(_ lhsDate: Date, _ rhsDate: Date) -> Bool{
        switch (filterType){
        case .week:
            // week, within same week NOT within 7 days of each other & same week of month, not just same week
            return (lhsDate.isInSameWeek(as: rhsDate) && lhsDate.isInSameMonth(as: rhsDate)) ? true : false
        case .month: return lhsDate.isInSameMonth(as: rhsDate)
        case .year: return lhsDate.isInSameYear(as: rhsDate)
        case .none:
            break
        }
        
        return false
    }
    
    // MARK: - Table View delegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (filteredEntries.count > 0){
            return filteredEntries.count
        }
            
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if filterType == .year{
            return 0
        }
        
        let weekCondition = filterType == .week && section > 0 && !filteredEntries[section].startDate.isInSameMonth(as: filteredEntries[section-1].startDate) ? true : false
        
        let monthCondition = filterType == .month && section > 0 && !filteredEntries[section].startDate.isInSameYear(as: filteredEntries[section-1].startDate) ? true : false
        
        if section == 0 || weekCondition || monthCondition{
            return headerCellSpacingHeight
        }
        
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Check if the entry before is same day, else add section header
        let currDate = filteredEntries[section].startDate
        let prevDate = section == 0 ? nil : filteredEntries[section-1].startDate
        
        if filterType == .week || filterType == .month {
            // Disable sticky header
            let headerHeight = CGFloat(80)
            var headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: headerHeight*2))
            self.table.contentInset = UIEdgeInsets(top:-12, left: 0, bottom: 0, right: 0)
            
            // Adjust header if first index
            if(section == 0){
                headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: headerHeight*2))
            }
            
            // Create label
            let label = UILabel()
            label.frame = CGRect.init(x: 0, y: -40, width: headerView.frame.width-10, height: headerHeight)
            label.font = .systemFont(ofSize: 20, weight: .semibold)
            headerView.backgroundColor = UIColor.clear
            
            let blackColor = [NSAttributedString.Key.foregroundColor: UIColor.black]
            let greyColor = [NSAttributedString.Key.foregroundColor: UIColor(red: 171/255, green: 171/255, blue: 171/255, alpha: 1.0)]
            
            if filterType == .week && (section == 0 || !currDate.isInSameMonth(as: prevDate!)){
                let monthText = NSMutableAttributedString(string: currDate.toString("LLLL"), attributes: blackColor)
                let yearText = NSMutableAttributedString(string: currDate.toString(", YYYY"), attributes: greyColor)
                
                monthText.append(yearText)
                label.attributedText = monthText
                headerView.addSubview(label)
                
                return headerView
            }
            
            if filterType == .month && (section == 0 || !currDate.isInSameYear(as: prevDate!)){
                let yearText = NSMutableAttributedString(string: currDate.toString("YYYY"), attributes: blackColor)
                label.attributedText = yearText
                headerView.addSubview(label)
                
                return headerView
            }
        }
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: footerCellSpacingHeight))
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section < filteredEntries.count-1 {
            let weekCondition = filterType == .week && !filteredEntries[section].startDate.isInSameMonth(as: filteredEntries[section+1].startDate) ? true : false
            let monthCondition = filterType == .month && !filteredEntries[section].startDate.isInSameYear(as: filteredEntries[section+1].startDate) ? true : false
            
            if  weekCondition || monthCondition{
                return footerCellSpacingHeight
            }
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! FilterGroupCell
        
        // note that indexPath.section is used rather than indexPath.row
        let currGroup = filteredEntries[(indexPath as NSIndexPath).section]
        
        cell.topLabel.text = currGroup.subHeader
        if(filterType != .week){
            cell.topLabel.isHidden = true
        }
        
        cell.mainLabel.text = currGroup.header
        cell.journalNumberLabel.text = "\(currGroup.count) Jurnal"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // Show note controller
        guard let vc = storyboard?.instantiateViewController(identifier: "Journal") as? JournalViewController else {
            return
        }
        
        let currGroup = filteredEntries[indexPath.section]
        vc.isFiltered = true
        vc.filterInterval = DateInterval(start: currGroup.startDate, end: currGroup.endDate)
        setBackBarItem()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
