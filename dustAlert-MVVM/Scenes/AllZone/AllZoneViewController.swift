//
//  AllZoneViewController.swift
//  dustAlert
//
//  Created by 이주상 on 2023/02/01.
//

import UIKit
import SnapKit
import Combine

final class AllZoneViewController: UIViewController {
    
    var viewModel: AllZoneViewModel = AllZoneViewModel(network: NetworkService(configuration: .default), fetchedDustArr: nil)
    var subscriptions = Set<AnyCancellable>()
    
    private lazy var dustTableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = .clear
        tableview.showsVerticalScrollIndicator = false
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(UINib(nibName: Const.Id.dustCell, bundle: nil), forCellReuseIdentifier: Const.Id.dustCell)
        
        return tableview
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: UIScreen.main.bounds.size.width * 0.5, y: UIScreen.main.bounds.size.height * 0.5, width: 0, height: 0)
        activityIndicator.style = .large
        activityIndicator.color = .systemRed
        activityIndicator.startAnimating()
        return activityIndicator
    }()

    private func hideActivityIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchDustArr()
    }
    private func setupUI() {
        [ dustTableView, activityIndicator ].forEach {
            view.addSubview($0)
        }
        setupNavigation()
        setupConstraints()
    }
    private func bind() {
        viewModel.fetchedDustArr
            .receive(on: RunLoop.main)
            .sink {[unowned self] _ in
                self.hideActivityIndicator()
                self.dustTableView.reloadData()
            }.store(in: &subscriptions)
    }

    private func setupNavigation() {
        self.navigationItem.title = Const.Title.allZone
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupConstraints() {
        dustTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }

}

extension AllZoneViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchedDustArr.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dustCell = dustTableView.dequeueReusableCell(withIdentifier: Const.Id.dustCell, for: indexPath) as! DustCell
        dustCell.selectionStyle = .none
        guard let dust = viewModel.fetchedDustArr.value?[indexPath.row] else { return UITableViewCell() }
        dustCell.dust = dust
        dustCell.handleLikeButtonTapped = { [weak self] (senderCell, isLiked) in
            guard let self = self else { return }
            if (!isLiked) {
                self.messageAlert(message: Const.Message.likeAddMessage) { okButtonTapped in
                    if okButtonTapped {
                        // 즐겨찾기 추가
                        self.viewModel.setLikeLocationToDB(location: dust.location!)
                        // 즐겨찾기 추가를 화면에 즉시 반영
                        senderCell.dust?.isLiked = true
                        senderCell.setupLikeButtonUI()
                    }
                }
            } else {
                self.messageAlert(message: Const.Message.likeRemoveMessage) { okButtonTapped in
                    if okButtonTapped {
                        // 즐겨찾기 해제
                        self.viewModel.deleteLikeLocationFromDB(location: dust.location!)
                        // 좋아요 해제를 화면에 즉시 반영
                        senderCell.dust?.isLiked = false
                        senderCell.setupLikeButtonUI()
                    }
                }
            }
        }
        return dustCell
    }
}

extension AllZoneViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
}
