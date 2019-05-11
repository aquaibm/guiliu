//
//  Favorite+SourceDelegate.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/12/6.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit

extension FavCollectionCtrller: NSCollectionViewDelegate,NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: .FavTopicItemIdentifier, for: indexPath) as! FavTopicItemCtrller
        item.updateWith(tp: topics[indexPath.item])
        return item
    }
}


extension FavCollectionCtrller: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: 240, height: 135)
    }
}
