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
    private let activeChatPreviews = Bundle.main.decode(Array<ChatPreview>.self, from: "activeChats.json")
    private let waitingChatPreviews = Bundle.main.decode(Array<ChatPreview>.self, from: "waitingChats.json")
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, ChatPreview>?
    
    //MARK: VIEW LIFCYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupCollectionView()
        createDataSource()
        reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let bounds = self.navigationController?.navigationBar.bounds else { return }
        let height = bounds.height
        let width = bounds.width
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    //MARK: SETUP
    private func setupSearchBar() {
        navigationController?.navigationBar.barTintColor = .mainWhite()
        navigationController?.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainWhite()
        view.addSubview(collectionView)
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
        section.contentInsets = NSDirectionalEdgeInsets(top: -20, leading: 20, bottom: 0, trailing: 20)
        return section
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
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ChatPreview>()
        snapshot.appendSections([.waitingChats, .activeChats])
        snapshot.appendItems(activeChatPreviews, toSection: .activeChats)
        snapshot.appendItems(waitingChatPreviews, toSection: .waitingChats)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func configure<T: SelfConfiguringCell>(cellType: T.Type, with value: ChatPreview, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T
            else { fatalError("Unable to dequeue \(cellType)") }
        cell.configure(with: value)
        return cell
    }
    
    enum Section: Int, CaseIterable {
        case waitingChats
        case activeChats
    }
}

//MARK: UISearchBarDelegate
extension ConversationsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
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
