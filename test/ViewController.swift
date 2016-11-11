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

class ViewController: UIViewController, UITextFieldDelegate, XMLParserDelegate ,UIPickerViewDataSource,UIPickerViewDelegate{
    
    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var inputtest: UITextField!
    @IBOutlet weak var test2: UILabel!
    @IBOutlet weak var Resultat: UILabel!
    @IBOutlet weak var fromCurrency: UILabel!
    @IBOutlet weak var toCurrency: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    //TODO offline switch, dont flip input/result
    var pickerDataSource = myModel.getCurrencys()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.inputtest.delegate = self
        updatedTimeLabel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func switchero() {
        let oldFrom = myModel.fromCurrency
        let oldTo = myModel.toCurrency
        let oldResult = Resultat.text
        
        inputtest.text = oldResult
        changeCurrency(res: oldFrom, component: 1)
        changeCurrency(res: oldTo, component: 0)
        // TODO update picker view
        pickerView.selectRow(  pickerDataSource.index(where: { ($0[oldFrom] != nil)})! , inComponent: 1, animated: false)
        pickerView.selectRow( pickerDataSource.index(where: { ($0[oldTo] != nil)})! , inComponent: 0, animated: false)
        
    }
    /*
    @IBAction func inputtest(_ sender: AnyObject) {
        calculateResult()
    }
    */
    @IBAction func inputUpdated() {
        calculateResult()
    }
    @IBAction func Testknapp(_ sender: AnyObject) {
        myModel.LoadData()
        updatedTimeLabel()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        if let res = pickerDataSource[row].first{
            changeCurrency(res: res.0,component: component)
        }else{
            print("error nil selecting pickerviewrow")
        }
        
    }

    
    private func changeCurrency( res: String,component:Int ){
        myModel.updateCurrency(res,toFrom: component)
        switch(component){
        case 0: fromCurrency.text=res;break
        case 1: toCurrency.text=res;break
        default: break
        }
        calculateResult()
        
    }
    
    private func calculateResult() {
        if let dotted = inputtest.text?.replacingOccurrences(of: ",", with: "."){
            if let number = Double(dotted){
                if let res = myModel.calculate(number) {
                    Resultat.text = String(format: "%.3f",res)
                    return
                }
            }
            //inputtest.text = dotted
        }
        Resultat.text = "gick inte"
        //inputtest.text = "0.0"
    }
    
    private func updatedTimeLabel(){
        lastUpdatedLabel.text = "Updaterat: \(myModel.lastUpdateTime)"
    }
    
    
    
}

