//
//  ChatViewController.swift
//  doodalman
//
//  Created by mac on 2017. 2. 17..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit
import SocketIO

class ContactViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chatInput: UITextField!
    @IBOutlet weak var viewTitle: UINavigationItem!
    @IBOutlet weak var toolbar: UIToolbar!

    var socket: SocketIOClient?
    var contact: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectSocketIO()
        chatInput.delegate = self

        subscribeToKeyboardNotifications()
        self.viewTitle.title = self.contact?.username
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 1000
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.socket?.disconnect()
        unsubscribeFromKeyboardNotifications()

    }
    
    func connectSocketIO() {
        let model = DooDalMan.shared
        let connectParams = ["token": model.authToken! as AnyObject, "contactId": self.contact?.contactId as AnyObject]
        self.socket = SocketIOClient(socketURL: URL(string: "http://omsh.ga")!,
                                     config: [.log(false), .forcePolling(false), .path("/io/"), .connectParams(connectParams) ])
        self.socket?.connect()
        self.configSocketIO()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.contact?.contactChats?.count {
            return count
        } else {
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let chat = self.contact?.contactChats?[indexPath.row]
        let cell: ContactTableViewCell
        
        if (chat?.isMe!)! {
            cell = tableView.dequeueReusableCell(withIdentifier: "userChatCell", for: indexPath) as! ContactTableViewCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "anotherUserChatCell", for: indexPath) as! ContactTableViewCell
        }
        
        cell.contentTextView?.text = chat?.content
        
        return cell
    }
    
    @IBAction func send(_ sender: UIBarButtonItem) {
        let content = self.chatInput.text!
        
        
        let chat = Chat(content: content, isMe: true)
        self.contact?.contactChats?.append(chat)
        
        self.socket?.emit("sendChat", ["content":content])
        self.chatInput.text = ""
        self.tableView.reloadData()
        self.scrollToLastRow()

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // test
    }
    
    // Notification 등록
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    // Notification 해제
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    
//    // textField 리턴키를 눌렀을 때 키보드 내리는 함수
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
        
    }

//    // keybord가 올라올 때 이벤트 핸들러
    func keyboardWillShow(_ notification:Notification) {
        //keyboard 높이
        
        let keyboardHeight = getKeyboardHeight(notification)

        self.toolbar.frame.origin.y -= keyboardHeight
        
        
        self.tableView.contentInset.bottom = keyboardHeight
        self.tableView.scrollIndicatorInsets.bottom = keyboardHeight

        self.scrollToLastRow()

        
        
    }

//    // keyboard가 내려갈 때 이벤트 핸들러
    func keyboardWillHide(_ notification: Notification) {

        let toolbarHeight = self.toolbar.frame.height
        self.toolbar.frame.origin.y = self.view.frame.height - toolbarHeight
        self.tableView.contentInset.bottom = 0
        self.tableView.scrollIndicatorInsets.bottom = 0

//        self.scrollToLastRow()

    }

//    // keyboard 높이 구하는 함수
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func scrollToLastRow() {
        
        if (self.contact?.contactChats?.count)! > 0 {
            let indexPath = IndexPath(row: (self.contact?.contactChats?.count)! - 1 , section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    



}

extension ContactViewController {
    func configSocketIO() {
        
        
        self.socket?.on("connect") { data, ack in
            print("connected")
        }
        
        self.socket?.on("chatList") { data, ack in
            
            let json = data[0] as! Dictionary<String,AnyObject>
            let chatList = json["chatList"] as! Array<Dictionary<String,AnyObject>>
            
            self.contact?.contactChats?.removeAll()
            
            for data in chatList {
                let chat = Chat(content: data["content"] as! String, isMe: data["isMe"] as! Bool)
                self.contact?.contactChats?.append(chat)
            }
            self.tableView.reloadData()
            self.scrollToLastRow()
        }
        
        
        self.socket?.on("receiveChat") { data, ack in
            if let content = data[0] as? String {
                let chat = Chat(content: content, isMe: false)
                
                self.contact?.contactChats?.append(chat)
                self.tableView.reloadData()
                self.scrollToLastRow()


            }
        }
        
        self.socket?.on("disconnect") { data, ack in
            print("disconnected")
            
        }
        
        self.socket?.on("reconnect") { data, ack in
            print("reconnect")
        }
        

       
        
        
       
//        self.socket?.on("error") { data, ack in
//            print("server error")
//            self.socket?.disconnect()
//            let alert = UIAlertController(title: "Server Error", message: "Retry after few minute.", preferredStyle: UIAlertControllerStyle.alert)
//            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { alert in
//                self.navigationController?.popViewController(animated: true)
//
//            }
//            alert.addAction(okAction)
//            self.present(alert, animated: true, completion: nil)
//
//
//        }

    }
}

