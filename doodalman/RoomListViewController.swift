//
//  RoomTableViewController.swift
//  doodalman
//
//  Created by mac on 2017. 2. 7..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit

class RoomListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView : UITableView!
    
    var roomList:[[String:AnyObject]]!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.roomList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomListCell", for: indexPath) as! RoomListTableViewCell
        let imageURL = URL(string: self.roomList[indexPath.row]["thumbnail"] as! String)
        let imageData = try? Data(contentsOf: imageURL!)
        
        cell.roomThumbnail.image = UIImage(data: imageData!)
        cell.roomTitle.text = self.roomList[indexPath.row]["title"] as? String
        return cell
    }
    
    func loadImage(urlString:String) -> UIImage? {
        
        let imageURL = URL(string: urlString)
        if let imageData = try? Data(contentsOf: imageURL!) {
            return UIImage(data: imageData)!
            
        } else {
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let id = self.roomList[indexPath.row]["id"] as! Int
        let roomURL = URL(string: "http://localhost:3000/rooms/get/\(id)")!
        
        let task = URLSession.shared.dataTask(with: roomURL) { (data, response, error) in
            if error == nil {
                let parsedResult: [String:AnyObject]!
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                    
                    performUIUpdatesOnMain{
                        self.performSegue(withIdentifier: "showRoom", sender: parsedResult["data"] as! [String: AnyObject])
                    }
                    
                } catch {
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }
                
                
            }
        }
        
        task.resume()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRoom" {
            let RoomVC = segue.destination as! RoomViewController
            RoomVC.room = sender as! [String:AnyObject]
        }
    }



}
