//
//  PublicCtrller+SourceDelegate.swift
//  GuiLiu
//
//  Created by Li Fumin on 2018/10/26.
//  Copyright © 2018 Moonlight. All rights reserved.
//

import Foundation
import AppKit


extension PubCollectionCtrller: NSCollectionViewDelegate,NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: .PubTopicItemIdentifier, for: indexPath) as! PubTopicItemCtrller
        item.updateWith(tp: topics[indexPath.item])
        return item
    }
}


extension PubCollectionCtrller: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: 240, height: 135)
    }
}
