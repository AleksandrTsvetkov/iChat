//
//  ConversationsViewController.swift
//  iChat
//
//  Created by Александр Цветков on 21.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit
import SwiftUI

class ConversationsViewController: UIViewController {
    
    //MARK: PROPERTIES
    private var activeChatPreviews: Array<ChatModel> = []
    private var waitingChatPreviews: Array<ChatModel> = []
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, ChatModel>?
    private let titleView = UIView()
    private let contentView = UIView()
    private let searchBar = UISearchBar()
    private let currentUser: UserModel
    private var waitingChatsListener: ListenerRegistration?
    private var activeChatsListener: ListenerRegistration?
    
    //MARK: VIEW LIFCYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupSearchBar()
        createDataSource()
        reloadData()
        
        waitingChatsListener = ListenerService.shared.waitingChatsObserve(chats: waitingChatPreviews, completion: { result in
            switch result {
            case .success(let chatPreviews):
                if self.waitingChatPreviews != [], self.waitingChatPreviews.count <= chatPreviews.count {
                    let chatRequestVC = ChatRequestViewController(chat: chatPreviews.last!)
                    chatRequestVC.delegate = self
                    self.present(chatRequestVC, animated: true)
                }
                self.waitingChatPreviews = chatPreviews
                self.reloadData()
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        })
        activeChatsListener = ListenerService.shared.activeChatsObserve(chats: activeChatPreviews, completion: { result in
            switch result {
            case .success(let chatPreviews):
                self.activeChatPreviews = chatPreviews
                self.reloadData()
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    init(currentUser: UserModel) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        waitingChatsListener?.remove()
        activeChatsListener?.remove()
    }
    
    //MARK: SETUP
    private func setupSearchBar() {
        navigationController?.navigationBar.isHidden = true
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        titleView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleView)
        titleView.addSubview(searchBar)
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 80),
            
            searchBar.heightAnchor.constraint(equalToConstant: 60),
            searchBar.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: titleView.trailingAnchor)
        ])
        titleView.backgroundColor = .mainWhite()
        searchBar.backgroundImage = UIImage()
    }
    
    private func setupCollectionView() {
        contentView.frame = CGRect(x: 0, y: 0 + 80, width: view.frame.width, height: view.bounds.height)
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainWhite()
        view.addSubview(contentView)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseId)
        collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseId)
    }
    
    //MARK: COMPOSITIONAL LAYOUT METHODS
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex) else { fatalError("Unkown section")}
            switch section {
            case .activeChats:
                return self.createPreviewsForActiveChats()
            case .waitingChats:
                return self.createPreviewsForWaitingChats()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    private func createPreviewsForActiveChats() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(66))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 10)
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createPreviewsForWaitingChats() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(66),
                                               heightDimension: .absolute(66))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20)
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .topLeading)
        return sectionHeader
    }
    
    //MARK: DATA SOURCE METHODS
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, chatPreview) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unkown section")}
            switch section {
            case .activeChats:
                return self.configure(cellType: ActiveChatCell.self, with: chatPreview, for: indexPath)
            case .waitingChats:
                return self.configure(cellType: WaitingChatCell.self, with: chatPreview, for: indexPath)
            }
        })
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("Cannot create new section header") }
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section kind")}
            sectionHeader.confgure(text: section.description(), font: .laoSangamMN20(), textColor: UIColor(hex: "929292"))
            return sectionHeader
        }
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ChatModel>()
        snapshot.appendSections([.waitingChats, .activeChats])
        snapshot.appendItems(activeChatPreviews, toSection: .activeChats)
        snapshot.appendItems(waitingChatPreviews, toSection: .waitingChats)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func configure<T: SelfConfiguringCell>(cellType: T.Type, with value: ChatModel, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T
            else { fatalError("Unable to dequeue \(cellType)") }
        cell.configure(with: value)
        return cell
    }
    
    enum Section: Int, CaseIterable {
        case waitingChats
        case activeChats
        
        func description() -> String {
            switch self {
            case .waitingChats:
                return "Waiting chats"
            case .activeChats:
                return "Active chats"
            }
        }
    }
}

//MARK: UICollectionViewDelegate
extension ConversationsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let chat = self.dataSource?.itemIdentifier(for: indexPath),
            let section = Section(rawValue: indexPath.section)
            else { return }
        switch section {
        case .waitingChats:
            let chatRequest = ChatRequestViewController(chat: chat)
            chatRequest.delegate = self
            self.present(chatRequest, animated: true)
        case .activeChats:
            let chatVC = ChatViewController(user: currentUser, chat: chat)
            navigationController?.navigationBar.isHidden = false
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }
}

//MARK: WaitingChatsNavigation
extension ConversationsViewController: WaitingChatsNavigation {
    
    func removeWaitingChat(_ chat: ChatModel) {
        FirestoreService.shared.deleteWaitingChat(chat: chat) { result in
            switch result {
            case .success:
                self.showAlert(title: "Успешно", message: "Чат с был \(chat.friendUsername) удалён")
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
    
    func changeToActive(_ chat: ChatModel) {
        FirestoreService.shared.changeToActive(chat: chat) { result in
            switch result {
            case .success:
                self.showAlert(title: "Успешно", message: "Приятного общения с \(chat.friendUsername)")
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
}

//MARK: UISearchBarDelegate
extension ConversationsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
    }
}

//MARK: CANVAS PREVIEW
struct ConversationsVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let mainTabBarController = MainTabBarController()
        
        func makeUIViewController(context: Context) -> UIViewController {
            return mainTabBarController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            
        }
    }
}
