//
//  SpotCell.swift
//  JakDojadeRek
//
//  Created by Mikolaj Zawada on 09/05/2024.
//

import UIKit

class SpotCell: UITableViewCell {

    static let identifier = "SpotCell"
    @IBOutlet weak var spotNameLabel: UILabel!
    @IBOutlet weak var cellStack: UIStackView!
    @IBOutlet weak var distanceAdressStack: UIStackView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var bikesAvailableLabel: UILabel!
    @IBOutlet weak var placesAvailableLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    private lazy var spotName = UILabel()
    
    static func nib() -> UINib {
        return UINib(nibName: "SpotCell", bundle: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellStack.setCustomSpacing(23, after: distanceAdressStack)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
