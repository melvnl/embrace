//
//  JournalViewController.swift
//  MC-2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 09/06/22.
//

import Foundation
import UIKit

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import Firebase

@available(iOS 15.0, *)
class JournalViewController: JournalParentVC, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var emptyJournalView: UIView!
    
    let cellReuseIdentifier = "EntryCell"
    var isFiltered = false
    var filterInterval : DateInterval?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        table.isHidden = false
        table.delegate = self
        table.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fillTable()
    }
    
    func fillTable(){
        journalRepo.fetchJournals { (entries) -> Void in
            DispatchQueue.main.async { [self] in
                self.entries = entries
                
                if(isFiltered){
                    var filteredEntries : [Entry] = []
                    emptyJournalView.isHidden = true
                    for entry in entries {
                        if entry.date >= filterInterval!.start && entry.date <= filterInterval!.end {
                            filteredEntries.append(entry)
                        }
                    }
                    self.entries = filteredEntries
                }
                
                table.dataSource = self
                table.delegate = self
                table.isHidden = false
                table.reloadData()
                
                emptyJournalView.isHidden = entries.count > 0 ? true : false
            }
        }
    }


    // MARK: - Table View delegate methods
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.entries.count
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // if section has header text, bigger spacing
        if section == 0 || !Calendar.current.isDate(entries[section].date, inSameDayAs:entries[section-1].date){
            return headerCellSpacingHeight
        }
        return cellSpacingHeight
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Check if the entry before is same day, else add section header
        if section == 0 || (section > 0 && !Calendar.current.isDate(entries[section].date, inSameDayAs:entries[section-1].date)){
            
            // Disable sticky header
            let headerHeight = CGFloat(80)
            var headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: headerHeight*2))
            self.table.contentInset = UIEdgeInsets(top:-12, left: 0, bottom: 0, right: 0)
            
            // Adjust header if first index
            if(section == 0){
                headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: headerHeight*2))
            }
            
            // Insert date
            let label = UILabel()
            label.frame = CGRect.init(x: 0, y: -40, width: headerView.frame.width-10, height: headerHeight)
            label.font = .systemFont(ofSize: 20, weight: .semibold)
            headerView.backgroundColor = UIColor.clear
    
            let blackColor = [NSAttributedString.Key.foregroundColor: UIColor.black]
            let greyColor = [NSAttributedString.Key.foregroundColor: UIColor(red: 171/255, green: 171/255, blue: 171/255, alpha: 1.0)]
            
            var todayText = NSMutableAttributedString(string: "")
            let greyComma = NSMutableAttributedString(string: ", ", attributes: greyColor)
            let dateText = NSMutableAttributedString(string: entries[section].date.toString("d MMM"), attributes: greyColor)
            
            if (Calendar.current.isDateInToday(entries[section].date)){
                todayText = NSMutableAttributedString(string: "Hari ini", attributes: blackColor)
                todayText.append(greyComma)
            }
            
            todayText.append(dateText)
            label.attributedText = todayText
            
            headerView.addSubview(label)
            
            return headerView
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
        if section < entries.count-1 && !Calendar.current.isDate(entries[section].date, inSameDayAs:entries[section+1].date){
            return footerCellSpacingHeight
        }
        return 0
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! EntryCell
        
        // note that indexPath.section is used rather than indexPath.row
        let currEntry = entries[(indexPath as NSIndexPath).section]
        
        // Set cell data
        cell.title.text = currEntry.title
        cell.desc.text = currEntry.desc
        cell.moodImage.image = getEntryMoodImage(currEntry)
        cell.journalImage.isHidden = true
        
        if(currEntry.image != EMPTY_IMAGE){
            cell.journalImage.load(url: URL(string: currEntry.image)!)
            cell.journalImage.isHidden = false
        }     
        
        // Convert date to string
        cell.date.text = currEntry.date.toString("hh.mm")
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section is used rather than indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)

        // Show note controller
        guard let vc = storyboard?.instantiateViewController(identifier: "ViewJournal") as? EntryDetailViewController else {
            return
        }
        
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.currEntry = entries[indexPath.section]
        
        
        setBackBarItem()
        navigationController?.pushViewController(vc, animated: true)
    }
}




