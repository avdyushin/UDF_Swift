//
//  ItemViewCell.swift
//  UDF_Swift
//
//  Created by Grigory Avdyushin on 19/07/2017.
//  Copyright © 2017 Grigory Avdyushin. All rights reserved.
//

import UIKit

class ItemViewCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    var numberFormatter: NumberFormatter?
    var item: Item? {
        didSet {
            reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        reloadData()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        clearData()
    }

    func clearData() {
        amountLabel.text = nil
        dateLabel.text = nil
    }

    func reloadData() {
        guard let item = item else {
            clearData()
            return
        }

        amountLabel.text = numberFormatter?.string(from: NSNumber(value: item.amount))
        dateLabel.text = Item.dateFormatter.string(from: item.timestamp) + "" + item.sectionKey
    }
}
