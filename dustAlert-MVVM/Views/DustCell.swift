//
//  DustCell.swift
//  dustAlert-MVVM
//
//  Created by 이주상 on 2023/04/13.
//

import UIKit

final class DustCell: UITableViewCell {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dustConcentrationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var dust: Dust? {
        didSet {
            setupUI()
        }
    }
    
    var handleLikeButtonTapped: ((DustCell, Bool) -> ()) = { (sender, pressed) in }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        guard let dust = dust else { return }
        locationLabel.text = dust.location
        dustConcentrationLabel.text = dust.info?.grade ?? "관측 없음"
        self.backgroundColor = .clear
        self.contentView.layer.backgroundColor = dust.info?.color.cgColor ?? UIColor.gray.cgColor
        timeLabel.text = dust.time
        likeButton.contentHorizontalAlignment = .fill
        likeButton.contentVerticalAlignment = .fill
        likeButton.imageView?.contentMode = .scaleAspectFit
        setupLikeButtonUI()
    }
    
    func setupLikeButtonUI() {
        let isLiked = self.dust?.isLiked ?? false
        isLiked ? likeButton.setImage(UIImage(systemName: "star.fill"), for: .normal) : likeButton.setImage(UIImage(systemName: "star"), for: .normal)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setCornerRadius()
    }
    private func setCornerRadius() {
        self.contentView.layer.cornerRadius = 25
        self.contentView.layer.masksToBounds = true
    }
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        let isLiked = self.dust?.isLiked ?? false
        handleLikeButtonTapped(self, isLiked)
        setupLikeButtonUI()
    }
    // frame에 inset을 지정하여, 결과적으로 tableCell간의 spacing을 주는 효과
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0))
    }
    
}
