//
//  ListCellViewController.swift
//  DemoProject
//
//  Created by sachin on 28/05/24.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var body: UILabel!
    
    var post: Post = Post()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpData()
    }
    
    
    func setUpData(){
        self.userId.text = "User Id: \(post.userId ?? 0)"
        self.id.text = "Id: \(post.id ?? 0)"
        self.titleLbl.text = "Title : \(post.title ?? "")"
        self.body.text = "Body: \(post.body ?? "")"
    }

}
