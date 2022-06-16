//
//  TopicViewController.swift
//  MC-2
//
//  Created by melvin on 15/06/22.
//

import UIKit
import Firebase
import FirebaseAuth

class TopicViewController: UIViewController {
    
    let db = Firestore.firestore()
    var categories : [Categories] = []
    
    @IBOutlet weak var table: UITableView!

    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        table.separatorColor = UIColor.clear
    
        self.table.tableFooterView = UIView.init(frame: .zero)
        
        let docRef = db.collection("forum")

        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                    for document in querySnapshot!.documents {

                        let currEntry = Categories(
                            category: document.get("category")! as! String,
                            thumbnail: document.get("thumbnail") as? String ?? "",
                            desc: document.get("desc")! as! String
                        )
                        self.categories.append(currEntry)
                    }
                self.table.delegate = self
                self.table.dataSource = self
                self.table.reloadData()
            
                    print(self.categories);
            }
            }
        }
    }

extension TopicViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height: CGFloat = 1
        
        return height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.section]
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        table.layer.cornerRadius = 10
        cell.title.text = category.category
        cell.desc.text = category.desc
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10

        let imgUrl = URL(string: category.thumbnail )!
        cell.thumbnail.load(url: imgUrl)
    
        return cell
    }
}

