//
//  SavedViewController.swift
//  MC-2
//
//  Created by Vendly on 20/06/22.
//

import UIKit

class SavedViewController: UIViewController {

    @IBOutlet weak var savedTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.savedTableView.delegate = self
//        self.savedTableView.dataSource = self
    }

}

//extension SavedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return UITableViewCell()
//    }
//
//}
