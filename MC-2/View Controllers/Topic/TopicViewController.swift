//
//  TopicViewController.swift
//  MC-2
//
//  Created by melvin on 15/06/22.
//

import UIKit
import Firebase
import FirebaseAuth

class TopicViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let db = Firestore.firestore()
    
    // array of array
//    var categories: [Categories] = [];
    var categories : [Categories] = []
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
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
                
                
                print(self.categories);
            }
            }
        
        table.dataSource = self
        table.delegate = self
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.row]
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.title.text = category.category
        
        let imgUrl = URL(string: category.thumbnail )!
        cell.thumbnail.load(url: imgUrl)
        
        return cell

    }

        // Do any additional setup after loading the view.
    }
    

