//
//  MyNftViewController.swift
//  FakeNFT
//
//  Created by MacBook on 01.06.2023.
//

import UIKit

enum SortDescriptor: String {
    case price
    case name
    case rating
}

class MyNftViewController: UIViewController {

    // MARK: - Properties
    private var viewModel: MyNftViewModel

    private lazy var nftTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(MyNftTableViewCell.self, forCellReuseIdentifier: MyNftTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    // MARK: - Initialiser
    init(viewModel: MyNftViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Мои NFT"
        view.backgroundColor = .systemBackground
        setNavBar()
        bind()
        layout()
    }

    // MARK: - Methods
    private func bind() {
        viewModel.myNftsDidChange = { [weak self] in
            self?.nftTableView.reloadData()
        }
        viewModel.likesDidChange = { [weak self] in
            self?.nftTableView.reloadData()
        }
        viewModel.showErrorAlertStateDidChange = { [weak self] in
            if let needShow = self?.viewModel.showErrorAlertState, needShow {
                self?.showErrorAlert {
                    self?.viewModel.initialization()
                }
            }
        }
    }

    private func setNavBar() {
        // Additional bar button items
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.topItem?.title = " "
        let sortButton = UIBarButtonItem(image: UIImage(named: "sortIcon"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(sortNft))
        navigationItem.setRightBarButtonItems([sortButton], animated: true)
    }

    @objc private func sortNft() {
        showAlert()
    }

    private func showAlert() {
        let alert = UIAlertController(
            title: nil,
            message: "Сортировка",
            preferredStyle: .actionSheet)

        let actionFirst = UIAlertAction(title: "По цене", style: .default) { [weak self] (_) in
            self?.viewModel.sort(by: .price)
        }
        alert.addAction(actionFirst)
        let actionSecond = UIAlertAction(title: "По Рейтингу", style: .default) { [weak self] (_) in
            self?.viewModel.sort(by: .rating)
        }
        alert.addAction(actionSecond)
        let actionThird = UIAlertAction(title: "По Названию", style: .default) { [weak self] (_) in
            self?.viewModel.sort(by: .name)
        }
        alert.addAction(actionThird)
        let actionCancel = UIAlertAction(title: "Закрыть", style: .cancel)
        alert.addAction(actionCancel)

        navigationController?.present(alert, animated: true, completion: nil)
    }

    private func showErrorAlert(action: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Ошибка загрузки данных",
            preferredStyle: .alert)

        let action = UIAlertAction(title: "Ок", style: .default) { _ in
            action()
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

    private func layout() {
        [nftTableView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }

        NSLayoutConstraint.activate([
            nftTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension MyNftViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.myNfts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MyNftTableViewCell.identifier,
            for: indexPath) as? MyNftTableViewCell else {
            assertionFailure("Could not cast cell to MyNftTableViewCell")

            return UITableViewCell()
        }
        let myNft = viewModel.myNfts[indexPath.row]
        let isLiked = viewModel.likes.contains(myNft.id)
        cell.setupCell(with: myNft, isLiked: isLiked)
        cell.likeButtonAction = { [weak self] in
            self?.viewModel.likeButtonHandle(indexPath: indexPath)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MyNftViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
