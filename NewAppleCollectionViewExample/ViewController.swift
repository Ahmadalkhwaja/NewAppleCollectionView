//
//  ViewController.swift
//  NewAppleCollectionViewExample
//
//  Created by A.Khwaja on 10/23/20.
//

import UIKit

class ViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureCollectionView()
        configureDataSource()
        applyInitialSnapshots()
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    func createLayout() -> UICollectionViewLayout {
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            let section: NSCollectionLayoutSection
            
            if sectionKind == .horizantal {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.28), heightDimension: .fractionalWidth(0.2))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                
            } else if sectionKind == .list {
                section = NSCollectionLayoutSection.list(using: .init(appearance: .insetGrouped), layoutEnvironment: layoutEnvironment)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)

            } else {
                fatalError("Unknown section!")
            }
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    func configuredGridCell() -> UICollectionView.CellRegistration<UICollectionViewCell, MainCategory> {
        return UICollectionView.CellRegistration<UICollectionViewCell, MainCategory> { (cell, indexPath, subCategory) in
            var content = UIListContentConfiguration.cell()
            content.text = subCategory.text
            content.textProperties.font = .boldSystemFont(ofSize: 38)
            content.textProperties.alignment = .center
            content.directionalLayoutMargins = .zero
            cell.contentConfiguration = content
            var background = UIBackgroundConfiguration.listPlainCell()
            background.cornerRadius = 8
            background.strokeColor = .systemGray3
            background.strokeWidth = 1.0 / cell.traitCollection.displayScale
            cell.backgroundConfiguration = background
        }
    }
    
    func configuredListCell() -> UICollectionView.CellRegistration<UICollectionViewListCell, SubCatergory> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, SubCatergory> { (cell, indexPath, subCategory) in
            var content = UIListContentConfiguration.valueCell()
            content.text = subCategory.text
            content.secondaryText = subCategory.title
            cell.contentConfiguration = content
            cell.accessories = [UICellAccessory.disclosureIndicator()]
        }
    }
    
    func configuredCategoryTitleHeaderCell() -> UICollectionView.CellRegistration<UICollectionViewListCell, String> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, String> { (cell, indexPath, title) in
            var content = cell.defaultContentConfiguration()
            content.text = title
            cell.contentConfiguration = content
            cell.accessories = [.outlineDisclosure(options: .init(style: .header))]
        }
    }
    
    func configureDataSource() {
        // data source
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            switch section {
            case .horizantal:
                return collectionView.dequeueConfiguredReusableCell(using: self.configuredGridCell(), for: indexPath, item: item.mainList)
            case .list:
                if item.hasChildren {
                    return collectionView.dequeueConfiguredReusableCell(using: self.configuredCategoryTitleHeaderCell(), for: indexPath, item: item.title!)
                } else {
                    return collectionView.dequeueConfiguredReusableCell(using: self.configuredListCell(), for: indexPath, item: item.subCategory)
                }
            }
        }
    }
    
    func applyInitialSnapshots() {
        // call the sections to collectionView.
        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: false)
        // add data to horizantal section.
        let mainCategories = MainCategory.list.map { Item(mainList: $0) }
        var mainCategoriesSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        mainCategoriesSnapshot.append(mainCategories)
        dataSource.apply(mainCategoriesSnapshot, to: .horizantal, animatingDifferences: false)
        // add data to list section
        var subCategoriesSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        let defaultCategory = SubCatergory.Category.clothing
        let rootItem = Item(title: String(describing: defaultCategory), hasChildren: true)
        subCategoriesSnapshot.append([rootItem])
        let productsItems = defaultCategory.products.map { Item(subCategory: $0) }
        subCategoriesSnapshot.append(productsItems, to: rootItem)
        dataSource.apply(subCategoriesSnapshot, to: .list, animatingDifferences: false)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == Section.horizantal.rawValue {
            var subCategoriesSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()

            let category = MainCategory.list[indexPath.row].category

            let rootItem = Item(title: String(describing: category), hasChildren: true)
            subCategoriesSnapshot.append([rootItem])
            
            let productsItems = category.products.map { Item(subCategory: $0) }
            subCategoriesSnapshot.append(productsItems, to: rootItem)

            dataSource.apply(subCategoriesSnapshot, to: .list, animatingDifferences: false)
        }
    }
}
