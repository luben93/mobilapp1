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

class ViewController: UIViewController, UITextFieldDelegate, NSXMLParserDelegate ,UIPickerViewDataSource,UIPickerViewDelegate{
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.inputtest.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "NotificationSent", name: myNotificationKey, object: nil)
        myModel.LoadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //print(component)
        if let out = pickerDataSource[row].first{
            switch(component){
            case 0:return out.1
            case 1:return "\(out.1) ="
            default: return "error"
            }
        }else{
                return "error"
        }
        
    }
    
    
    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var inputtest: UITextField!
    @IBOutlet weak var test2: UILabel!
    @IBOutlet weak var Resultat: UILabel!
    @IBOutlet weak var fromCurrency: UILabel!
    @IBOutlet weak var toCurrency: UILabel!
    
    @IBOutlet weak var pickerView: UIPickerView!
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if let res = pickerDataSource[row].first{
            myModel.updateCurrency(res.0,toFrom: component)
            switch(component){
            case 0: fromCurrency.text=res.0;break
            case 1: toCurrency.text=res.0;break
            default: break
            }
        }else{
            print("error nil selecting pickerviewrow")
        }
        
    }
    
    
    
    var pickerDataSource = myModel.getCurrencys()
    
    
    func NotificationSent(){
      print("It works")
    }
    
    @IBAction func inputtest(sender: AnyObject) {
        if let number = Double(inputtest.text!){
            myModel.calculate(number)
            Resultat.text = String(format: "%.3f", myModel.getText())
        }else{
            Resultat.text = "gick inte"
        }
    }
    
    @IBAction func Testknapp(sender: AnyObject) {
        
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

