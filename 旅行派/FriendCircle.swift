//
//  FriendCircle.swift
//  旅行派
//
//  Created by 张思槐 on 17/1/29.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit

class FriendCircle: NSObject {
    
    var isFavorite: Bool = false
    var cellHeight: CGFloat = 0
    var user: String?
    var avator: URL?
    var content: String?
    var imgUrls: [URL] = [URL]()
    var comments: [Comment] = [Comment]()
    //从网络获取创建方法
    init(dict: [String: AnyObject]) {
        super.init()
        user = dict["user"] as? String
        
        let urlStr = dict["avator"] as! String
        avator = URL(string: urlStr)
        
        content = dict["content"] as? String
        
        let images = dict["images"] as! [String]
        for img in images{
            let url = URL(string: img)
            imgUrls.append(url!)
        }
        
        let coms = dict["comments"] as! [[String: AnyObject]]
        for comDict in coms{
            self.comments.append(Comment(dict: comDict))
        }
    }
    
    init(user: String, avaterUrl: String, urls: [URL], text: String) {
        super.init()
        self.user = user
        self.avator = URL(string: avaterUrl)
        self.imgUrls = urls

        //估算高度
        let h = (UIScreen.main.bounds.width - 75) / 3
        let textH = getCellHeight(text: text)
        let constH: CGFloat = 65
        if urls.count == 1{
            cellHeight = textH + h + constH
        }else{
            let row = CGFloat((urls.count - 1) / 3 + 1)
            cellHeight = row * h + textH + constH + (row - 1) * 10
        }
    }
    
    fileprivate func getCellHeight(text: String) -> CGFloat{
        let str = text as NSString
        let attr = [NSFontAttributeName : UIFont.systemFont(ofSize: 13)]
        let rect = str.boundingRect(with: CGSize(width: UIScreen.main.bounds.width - 65, height: CGFloat(MAXFLOAT)), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: attr, context: nil)
        return rect.height
    }
    
}
