//
//  JournalParentVC.swift
//  MC-2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 16/06/22.
//

import Foundation
import UIKit

class JournalParentVC : UIViewController{
    
    @IBOutlet weak var table: UITableView!
    var entries: [Entry] = []
    let cellSpacingHeight: CGFloat = 3
    
    @IBAction func didTapNewNote(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "NewJournal") as? EntryViewController else {
            return
        }
        
        vc.completion = {
            newEntry in
            self.navigationController?.popToRootViewController(animated: true)
            journalRepo.createJournal(entry: newEntry)
                    
            self.table.isHidden = false
        }
        
        vc.currEntry = nil
        vc.isEditingEntry = false
        
        vc.title = "Buat jurnal"
        
        setBackBarItem()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapFilter(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Saring berdasarkan", preferredStyle: .actionSheet)
            
        alert.addAction(UIAlertAction(title: "Hari", style: .default , handler:{ (UIAlertAction)in
            self.navigationController?.popToRootViewController(animated: true)
            }))

        alert.addAction(UIAlertAction(title: "Minggu", style: .default , handler:{ (UIAlertAction)in
            self.goToFilteredJournals(.week)
            }))
        
        alert.addAction(UIAlertAction(title: "Bulan", style: .default , handler:{ (UIAlertAction)in
            self.goToFilteredJournals(.month)
            }))
            
        alert.addAction(UIAlertAction(title: "Tahun", style: .default, handler:{ (UIAlertAction)in
            self.goToFilteredJournals(.year)
            }))
        
        alert.addAction(UIAlertAction(title: "Batal", style: .cancel, handler:{ (UIAlertAction)in
            print("User click cancel button")
            }))

            
        //uncomment for iPad Support
        //alert.popoverPresentationController?.sourceView = self.view

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func goToFilteredJournals(_ filterType: JournalFilterType){
        guard let vc = storyboard?.instantiateViewController(identifier: "FilteredJournals") as? FilterViewController else {
            return
        }
        
        vc.filterType = filterType
        
        vc.title = "Jurnal"
        
        setBackBarItem()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func convertDateToString(date: Date, format: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
