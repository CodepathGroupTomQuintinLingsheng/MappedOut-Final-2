//
//  CoreViewPreview.swift
//  MappedOut
//
//  Created by 吕凌晟 on 16/4/29.
//  Copyright © 2016年 Codepath. All rights reserved.
//

import UIKit

extension CoreViewController: UIViewControllerPreviewingDelegate {

    // PEEK
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRowAtPoint(location),
            cell = tableView.cellForRowAtIndexPath(indexPath) else {return nil}
        
        
        guard let previewVC = storyboard?.instantiateViewControllerWithIdentifier("PreviewVC") as? PreviewViewController else {return nil}
        
        previewVC.selectedItem = filteredevent![indexPath.row].descript
        //quickActionString = filteredevent[indexPath.row].description
        
        
        previewVC.preferredContentSize = CGSize(width: 0, height: 150)
        
        previewingContext.sourceRect = cell.frame
        
        
        return previewVC
    }
    
    // POP
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
//        if let stuffVC = storyboard?.instantiateViewControllerWithIdentifier("AddStuffVC") as? AddStuffViewController{
//            stuffVC.detailInfo = quickActionString
//            
//            showViewController(stuffVC, sender: self)
//        }
        
        
    }

}
