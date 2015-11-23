//
//  ViewController.swift
//  test
//
//  Created by Jonas Wåhslén on 2015-10-24.
//  Copyright © 2015 Jonas Wåhslén. All rights reserved.
//

import UIKit

let myModel = Model()
let myNotificationKey = "com.exyr.myNotificationKey"

class ViewController: UIViewController, UITextFieldDelegate, NSXMLParserDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.inputtest.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "NotificationSent", name: myNotificationKey, object: nil)
        myModel.LoadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var inputtest: UITextField!
    @IBOutlet weak var test2: UILabel!
    @IBOutlet weak var Resultat: UILabel!
    
    func NotificationSent(){
      print("It works")
    }
    
    @IBAction func inputtest(sender: AnyObject) {
        if let number = Double(inputtest.text!){
            myModel.calculate(number)
            Resultat.text = "Kursen blev \(myModel.getText())"
        }else{
            Resultat.text = "gick"
        }
    }
    
    @IBAction func Testknapp(sender: AnyObject) {
        print("knasig knapp")
        myModel.LoadData()
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

