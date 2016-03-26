//
//  ViewController.swift
//  RestClient
//
//  Created by Csaba Marton on 26/03/16.
//  Copyright © 2016 Mandinga. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var greetingContent: UILabel!
    @IBOutlet var nameField: UITextField!
    
    @IBAction func fetchGreeting(sender: AnyObject) {
      
        let postEndpoint: String = "http://localhost:9000/greeting"
        
        doRequest(postEndpoint) { data in
            dispatch_async(dispatch_get_main_queue()) {
                if let data = data {
                    do {
                        let greeting = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                        let content = greeting["content"] as? String
                        self.greetingContent.text = content
                        //let id = greeting["id"] as? String
                        
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
 
    func doRequest(link:String,completion: ((data: NSData?) -> Void)) {
        if let requestUrl = NSURL(string: link){
            let request = NSMutableURLRequest(URL: requestUrl)
            
            request.HTTPMethod = "POST"
            let postString = "name=" + nameField.text!
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
                completion(data: NSData(data: data!))
                if let error = error {
                    print("error=\(error)")
                    return
                }
                
                }.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

