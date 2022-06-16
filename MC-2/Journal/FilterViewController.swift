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
        
        table.isHidden = false
        table.delegate = self
        table.dataSource = self
        
        // create bar item buttons
        let addBarButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.didTapNewNote(_:)))
        
        let filterBarButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.didTapFilter(_:)))
        
        let backBarButton = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(self.backToRootVC(_:)))
        
        addBarButton.tintColor = .black
        filterBarButton.tintColor = .black
        backBarButton.tintColor = UIColor.black
        
        addBarButton.image = UIImage(systemName: "plus")
        filterBarButton.image = UIImage(systemName: "line.3.horizontal.decrease")
        backBarButton.image = UIImage(systemName: "chevron.left")
        
        navigationItem.rightBarButtonItems = [filterBarButton, addBarButton]
        navigationItem.leftBarButtonItem = backBarButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        journalRepo.fetchJournals { (entries) -> Void in
            self.entries = entries
            self.filterEntries()
            print(self.filterType)
        }
    }
    
    @objc func backToRootVC(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
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
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "LLLL"
                    let nameOfMonth = dateFormatter.string(from: currEntry.date)
                    dateFormatter.dateFormat = "d"
                    subHeaderText = "\(dateFormatter.string(from: dateInterval.start))-\(dateFormatter.string(from: dateInterval.end)) \(nameOfMonth.uppercased())"
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
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        
        dateFormatter.dateFormat = "LLLL"
        let monthName = dateFormatter.string(from: date).capitalized
        dateFormatter.dateFormat = "YYYY"
        let yearName = dateFormatter.string(from: date)
        
        
        switch (filterType){
        case .week:
            return "Minggu ke-\(calendar.component(.weekOfMonth, from: date)), \(monthName) \(yearName)"
        case .month:
            return "\(monthName), \(yearName)"
        case .year:
            return yearName
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
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        
        return headerView
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
        //
    }
    
}
