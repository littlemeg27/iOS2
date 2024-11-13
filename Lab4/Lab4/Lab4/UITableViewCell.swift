//
//  UITableViewCell.swift
//  Lab4
//
//  Created by Brenna Pavlinchak on 11/13/24.
//

import UIKit

class PostTableViewCell: UITableViewCell
{
    @IBOutlet weak var titleLabel: UILabel!  // Label for post title
    @IBOutlet weak var thumbnailImageView: UIImageView!  // ImageView for post thumbnail

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
