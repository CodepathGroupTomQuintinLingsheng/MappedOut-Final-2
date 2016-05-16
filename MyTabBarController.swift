//
//  MyTabBarController.swift
//  MappedOut
//
//  Created by 吕凌晟 on 16/3/10.
//  Copyright © 2016年 Codepath. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tabBar.barTintColor = UIColor.clearColor()
        //self.tabBar.opaque = true;
        let backgroundimage = UIImageView.init(image: UIImage(named: "images.png"))
        backgroundimage.frame = CGRectMake(0, 0, self.tabBar.frame.size.width, self.tabBar.frame.size.height)
        backgroundimage.contentMode = UIViewContentMode.ScaleToFill
        self.tabBar.insertSubview(backgroundimage, atIndex: 0)
        //self.tabBar.backgroundImage = UIImage(named: "images.png")
        
        // Do any additional setup after loading the view.
        for (index, viewController) in self.viewControllers!.enumerate() {
            // 声明 TabBarItem 的Image，如果没有imageWithRenderingMode方法Image只会保留轮廓
            let image = UIImage(named: "Tabbar\(index)")?.imageWithRenderingMode(.AlwaysOriginal)
            let selectedImage = UIImage(named: "Tabbar\(index)sel")?.imageWithRenderingMode(.AlwaysOriginal)
            
            // 声明新的无标题TabBarItem
            let tabBarItem = UITabBarItem(title: nil, image: image, selectedImage: selectedImage)
            // 设置 tabBarItem 的 imageInsets 可以使图标居中显示
            tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
            
            viewController.tabBarItem = tabBarItem
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
