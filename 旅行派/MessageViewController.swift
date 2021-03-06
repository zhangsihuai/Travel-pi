//
//  MessageViewController.swift
//  旅行派
//
//  Created by 张思槐 on 16/12/2.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class MessageViewController: UITableViewController {

    fileprivate lazy var locationTool = LocationTool()
    fileprivate var location: CLLocation?
    @IBOutlet weak var leftBarButtonClick: UIBarButtonItem!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    fileprivate lazy var placeholderView = PlaceholderView(frame: CGRect.zero)
    
    fileprivate var conversations: [EMConversation] = [EMConversation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPlaceholder()
        setUp()
        refresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        conversations = EMClient.shared().chatManager.getAllConversations() as! [EMConversation]
        tableView.reloadData()
        rightBarButton.isEnabled = EMClient.shared().isLoggedIn
        placeholderView.isHidden = EMClient.shared().isLoggedIn
    }

    @IBAction func leftBarButtonClick(_ sender: AnyObject) {
        present(ProfileViewController.shared, animated: true, completion: nil)
    }
    
    @IBAction func startNewConversation(_ sender: AnyObject) {
        let nav = UINavigationController(rootViewController: FriendListViewController.list)
        present(nav, animated: true, completion: nil)
    }

    
}

extension MessageViewController{
    
    
    fileprivate func setUp(){
        tableView.separatorStyle = .none
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.refreshConversation))
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("获取回话...", for: .refreshing)
        header?.setTitle("松开刷新", for: .pulling)
        tableView.mj_header = header
        
        EMClient.shared().chatManager.add(self)
    }
    
    @objc fileprivate func refreshConversation(){
        conversations = EMClient.shared().chatManager.getAllConversations() as! [EMConversation]
        endRefresh()
    }
    
    fileprivate func refresh(){
        tableView.mj_header.beginRefreshing()
    }
    
    fileprivate func endRefresh(){
        tableView.mj_header.endRefreshing()
        tableView.reloadData()
    }
    
}

extension MessageViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if conversations.count == 0 { title = "暂无消息" }
        return conversations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationCell
        cell.conversation = conversations[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVc = ChatViewController()
        chatVc.hidesBottomBarWhenPushed = true
        chatVc.conversationId = conversations[indexPath.row].conversationId
        navigationController?.pushViewController(chatVc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let conversation = conversations[indexPath.row]
        let deleteAc = UITableViewRowAction(style: .destructive, title: "删除") { (_, indexPath) in
            EMClient.shared().chatManager.deleteConversation(conversation.conversationId, isDeleteMessages: true, completion: { (_, error) in
                if error != nil{
                    print("删除回话失败")
                }
            })
            self.conversations.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .left)
        }
        return [deleteAc]
    }
}

extension MessageViewController: EMChatManagerDelegate{
    func messagesDidReceive(_ aMessages: [Any]!) {
        if aMessages != nil{
            tableView.reloadData()
        }
    }
}

extension MessageViewController: PlaceholderLoginDelegate{
    fileprivate func setUpPlaceholder(){
        self.view.addSubview(placeholderView)
        placeholderView.frame = UIScreen.main.bounds
        placeholderView.delegate = self
    }
    
    func login() {
        let nav = UINavigationController(rootViewController: LoginViewController())
        present(nav, animated: true, completion: nil)
    }
}





