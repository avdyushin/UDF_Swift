//
//  ProjectViewCell.swift
//  UDF_Swift
//
//  Created by Grigory Avdyushin on 19/07/2017.
//  Copyright © 2017 Grigory Avdyushin. All rights reserved.
//

import UIKit

class ProjectViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView?
    @IBOutlet weak var imageLabel: UILabel?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var subTitleLabel: UILabel?
    @IBOutlet weak var rightDetailsLabel: UILabel?

    var project: Project? {
        didSet {
            reloadData()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView?.layer.cornerRadius = (avatarImageView?.frame.width ?? 0) / 2
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
        titleLabel?.text = nil
        subTitleLabel?.text = nil
        rightDetailsLabel?.text = nil
        imageLabel?.text = nil
        avatarImageView?.backgroundColor = .lightGray
    }

    func reloadData() {
        guard let project = project else {
            clearData()
            return
        }

        titleLabel?.text = project.title.uppercased()
        subTitleLabel?.text = project.frequency.description
        rightDetailsLabel?.text =  project.totalAmountString
        imageLabel?.text = project.title.uppercased().characters.first?.description ?? nil
        avatarImageView?.backgroundColor = .lightGray
    }

}
