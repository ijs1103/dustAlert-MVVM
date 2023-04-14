//
//  DangerZoneDustCell.swift
//  dustAlert
//
//  Created by 이주상 on 2023/02/15.
//

import UIKit

final class DangerZoneDustCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var dangerZoneDust: DangerZoneDust? {
        didSet {
            setUI()
        }
    }
    
    private func setUI() {
        guard let dangerZoneDust = dangerZoneDust else { return }
        nameLabel.text = dangerZoneDust.name
        addressLabel.text = dangerZoneDust.location
        self.backgroundColor = .clear
        self.contentView.layer.backgroundColor = UIColor.clear.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
