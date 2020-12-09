//
//  NewsListCell.swift
//  DRCSysPractical
//
//  Created by Mac Mini on 09/12/20.
//

import UIKit

class NewsListCell: UITableViewCell {

    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var lblNewsTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
