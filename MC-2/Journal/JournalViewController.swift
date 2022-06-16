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
    let headerCellSpacingHeight: CGFloat = 30
    
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
            DispatchQueue.main.async {
                self.entries = entries
                self.table.dataSource = self
                self.table.delegate = self
                self.table.isHidden = false
                self.table.reloadData()
                
                self.emptyJournalView.isHidden = entries.count > 0 ? true : false
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
        if section == 0 || (section > 0 && !Calendar.current.isDate(entries[section].date, inSameDayAs:entries[section-1].date)){
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
            var headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: headerHeight))
            self.table.contentInset = UIEdgeInsets(top:-7, left: 0, bottom: 0, right: 0)
            
            // Adjust header if first index
            if(section == 0){
                headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: headerHeight*2))
            }
            
            // Insert date
            let label = UILabel()
    
            let blackColor = [NSAttributedString.Key.foregroundColor: UIColor.black]
            let greyColor = [NSAttributedString.Key.foregroundColor: UIColor(red: 171/255, green: 171/255, blue: 171/255, alpha: 1.0)]
            
            var todayText = NSMutableAttributedString(string: "")
            let greyComma = NSMutableAttributedString(string: ", ", attributes: greyColor)
            let dateText = NSMutableAttributedString(string: convertDateToString(date: entries[section].date, format: "d MMM"), attributes: greyColor)
            
            if (Calendar.current.isDateInToday(entries[section].date)){
                todayText = NSMutableAttributedString(string: "Hari ini", attributes: blackColor)
                todayText.append(greyComma)
            }
            
            todayText.append(dateText)
            label.attributedText = todayText
            
            // Label styling
            label.frame = CGRect.init(x: 0, y: -40, width: headerView.frame.width-10, height: headerHeight)
            label.font = .systemFont(ofSize: 20, weight: .semibold)
            headerView.backgroundColor = UIColor.clear
            
            headerView.addSubview(label)
            
            return headerView
        }
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        
        return headerView
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
        
        // Convert date to string
        cell.date.text = convertDateToString(date: currEntry.date, format: "hh.mm")
        
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




