//
//  TripDetailViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/26.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

let color = UIColor(colorLiteralRed: 27/255, green: 166/255, blue: 170/255, alpha: 1)

class TripDetailViewController: UITableViewController, TripDetailDelegate {
    
    fileprivate var infoVc: TripInfoViewController = TripInfoViewController()
    
    var days: [Day] = [Day]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: tableView.bounds, style: .grouped)
        tableView.backgroundColor = color
        tableView.register(UINib(nibName: "PlanCell", bundle: nil), forCellReuseIdentifier: "PlanCell")
        tableView.register(UINib(nibName: "TripDetailCell", bundle: nil), forCellReuseIdentifier: "TripDetailCell")
        
        infoVc.modalPresentationStyle = .custom
        title = "详情"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.contentOffset.y = 0
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return days.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days[section].activities.count + 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 350
        }else{
            return 70
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let day = days[indexPath.section]
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell", for: indexPath) as! PlanCell
            cell.title = "- 第\(indexPath.section+1)天 -"
            cell._descripation = day._description
            if let urlStr = day.activities[0].photo_url{
                let url = URL(string: urlStr)
                cell.url = url
            }
            return cell
        }
        else{
            //系统的cell
            let activity = day.activities[indexPath.row-1]
//            var cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell")
//            if cell == nil {
//                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ActivityCell")
//            }
//            cell?.imageView?.image = UIImage(named: "info")
//            cell?.textLabel?.text = activity.topic
//            cell?.detailTextLabel?.text = activity.visit_tip
//            return cell!
            
            
            //自定义cell
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TripDetailCell", for: indexPath) as! TripDetailCell
            cell.indexPath = indexPath
            cell.delegate = self
            cell.activity = activity
            return cell
        }
    }
    
    
    func showInfoAt(indexPath: IndexPath?) {
//        print(indexPath)
        infoVc.day = days[indexPath!.section]
        infoVc.indexPath = indexPath
        present(infoVc, animated: false, completion: nil)
    }
    
}
