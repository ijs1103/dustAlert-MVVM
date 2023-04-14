//
//  MyZoneViewController.swift
//  dustAlert
//
//  Created by 이주상 on 2023/02/01.
//

import UIKit
import Combine
import SnapKit

final class MyZoneViewController: UIViewController {
    
    var viewModel: MyZoneViewModel = MyZoneViewModel(network: NetworkService(configuration: .default), fetchedDustArr: nil)
    var subscriptions = Set<AnyCancellable>()
    
    private let emptyLabelView = EmptyLabelView(text: Const.Label.myZoneEmptyLabel)

    private lazy var sidoTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        return textField
    }()
    
    private lazy var sidoTextView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.backgroundColor = UIColor.white.cgColor
        view.addSubview(sidoTextField)
        
        return view
    }()
    
    private lazy var gunguTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        return textField
    }()
    
    private lazy var gunguTextView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.backgroundColor = UIColor.white.cgColor
        view.addSubview(gunguTextField)
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [sidoTextView, gunguTextView])
        stview.spacing = 10
        stview.axis = .horizontal
        stview.distribution = .fillEqually
        stview.alignment = .fill
        return stview
    }()
    
    private lazy var sidoPickerView: UIPickerView = {
        let sidoPickerView = UIPickerView()
        sidoPickerView.delegate = self
        sidoPickerView.dataSource = self
        sidoPickerView.tag = 1
        
        return sidoPickerView
    }()
    private lazy var gunguPickerView: UIPickerView = {
        let gunguPickerView = UIPickerView()
        gunguPickerView.delegate = self
        gunguPickerView.dataSource = self
        gunguPickerView.tag = 2
        
        return gunguPickerView
    }()
    
    private lazy var dustTableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = .clear
        tableview.isHidden = (viewModel.selectedDust == nil) ? true : false
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(UINib(nibName: Const.Id.dustCell, bundle: nil), forCellReuseIdentifier: Const.Id.dustCell)
        
        return tableview
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.style = .large
        activityIndicator.color = .gray
        activityIndicator.isHidden = true
        return activityIndicator
    }()
    
    private func showActivityIndicator() {
        gunguTextField.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    private func hideActivityIndicator() {
        gunguTextField.isHidden = false
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupUI()
    }
    private func bind() {
        viewModel.sidoPickerViewTapped
            .receive(on: RunLoop.main)
            .sink { [unowned self] row in
                self.sidoTextField.text = Const.SidoArr[row]
                self.showActivityIndicator()
                self.gunguTextView.isUserInteractionEnabled = false
                self.viewModel.fetchDustArr(sidoName: Const.SidoArr[row])
            }.store(in: &subscriptions)
        
        viewModel.gunguPickerViewTapped
            .receive(on: RunLoop.main)
            .sink { [unowned self] row in
                self.gunguTextField.text = self.viewModel.fetchedDustArr.value?[row].gunguName
                if let myZoneDust = self.viewModel.fetchedDustArr.value?[row] {
                    self.viewModel.setMyZoneToDB(dust: myZoneDust)
                }
                self.emptyLabelView.isHidden = true
                self.dustTableView.isHidden = false
                self.dustTableView.reloadData()
                self.gunguTextField.resignFirstResponder()
            }.store(in: &subscriptions)
        
        viewModel.fetchedDustArr
            .receive(on: RunLoop.main)
            .sink { [unowned self] _ in
                self.gunguPickerView.reloadAllComponents()
                self.hideActivityIndicator()
                self.gunguTextField.text = "군/구"
                self.gunguTextView.isUserInteractionEnabled = true
                self.sidoTextField.resignFirstResponder()
            }.store(in: &subscriptions)
    }
    private func setupUI() {
        [  emptyLabelView, stackView, dustTableView, activityIndicator ].forEach {
            view.addSubview($0)
        }
        setupNavigation()
        setupPickerView()
        setUpConstraints()
        if viewModel.selectedDust != nil {
            emptyLabelView.isHidden = true
        }
    }
    private func setupNavigation() {
        self.navigationItem.title = Const.Title.myZone
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    private func setupPickerView() {
        sidoTextField.inputView = sidoPickerView
        gunguTextField.inputView = gunguPickerView
        sidoTextField.attributedPlaceholder = NSAttributedString(string: "시/도", attributes: [.foregroundColor: UIColor.systemGreen])
        gunguTextField.attributedPlaceholder = NSAttributedString(string: "군/구", attributes: [.foregroundColor: UIColor.systemGreen])
        [ sidoTextField, gunguTextField ].forEach {
            $0.textAlignment = .center
            $0.tintColor = .clear
        }
        
    }

    private func setUpConstraints() {
        emptyLabelView.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        sidoTextField.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        gunguTextField.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        dustTableView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
        }
        activityIndicator.snp.makeConstraints {
            $0.center.equalTo(gunguTextView.snp.center)
        }
    }
    
}

extension MyZoneViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel.selectedDust != nil) ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let selectedDust = viewModel.selectedDust else { return DustCell() }
        let dustCell = dustTableView.dequeueReusableCell(withIdentifier: Const.Id.dustCell, for: indexPath) as! DustCell
        dustCell.dust = selectedDust
        dustCell.selectionStyle = .none
        dustCell.handleLikeButtonTapped = { [weak self] (senderCell, isLiked) in
            guard let self = self else { return }
            if (!isLiked) {
                self.messageAlert(message: Const.Message.likeAddMessage) { okButtonTapped in
                    if okButtonTapped {
                        // 즐겨찾기 추가
                        self.viewModel.setLikeLocationToDB(location: selectedDust.location!)
                        // 즐겨찾기 추가를 화면에 즉시 반영
                        senderCell.dust?.isLiked = true
                        senderCell.setupLikeButtonUI()
                    }
                }
            } else {
                self.messageAlert(message: Const.Message.likeRemoveMessage) { okButtonTapped in
                    if okButtonTapped {
                        // 즐겨찾기 해제
                        self.viewModel.deleteLikeLocationFromDB(location: selectedDust.location!)
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

extension MyZoneViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
}

extension MyZoneViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return Const.SidoArr.count
        case 2:
            return viewModel.fetchedDustArr.value?.count ?? 0
        default:
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return Const.SidoArr[row]
        case 2:
            return viewModel.fetchedDustArr.value?[row].gunguName ?? ""
        default:
            return "empty data"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            viewModel.sidoPickerViewTapped.send(row)
        case 2:
            viewModel.gunguPickerViewTapped.send(row)
        default:
            return
        }
    }
}

