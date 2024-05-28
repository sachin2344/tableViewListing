//
//  ListCell.swift
//  DemoProject
//
//  Created by sachin on 28/05/24.
//

import UIKit

class ListCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var idView: UIView!
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var post: Post = Post(){
        didSet{
            setUpData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpData(){
        self.idLabel.text = "\(post.id ?? 0)"
        self.titleLabel.text = post.title
    }
    
}
