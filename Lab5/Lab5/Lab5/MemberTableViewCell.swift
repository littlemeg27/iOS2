//
//  MemberTableViewCell.swift
//  Lab5
//
//  Created by Brenna Pavlinchak on 11/18/24.
//

import UIKit

class MemberTableViewCell: UITableViewCell
{
    @IBOutlet weak var titleLabel: UILabel!  // Label for post title

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
