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
    
    let errorResultOutput = "gick inte"
    let updateOutput = "Updaterat:"
    var pickerDataSource = myModel.getCurrencys()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.inputtest.delegate = self
        updatedTimeLabel()
        inputtest.text = "\(myModel.inputed)"
        updatePickerView(res: myModel.fromCurrency, component: 0)
        updatePickerView(res: myModel.toCurrency , component: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func offlineSwitch(_ sender: UISwitch) {
        myModel.offline = !sender.isOn
    }
    
    @IBAction func switchero() {
        let oldFrom = myModel.fromCurrency
        let oldTo = myModel.toCurrency
        var oldResult = Resultat.text
        if oldResult == errorResultOutput{ oldResult = "\(0.0)" }
        
        //inputtest.text = oldResult
        updatePickerView(res: oldFrom, component: 1)
        updatePickerView(res: oldTo, component: 0)
        
    }
    
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
        switch(component){
        case 0: fromCurrency.text=res;myModel.fromCurrency = res
        case 1: toCurrency.text=res;myModel.toCurrency = res
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
            inputtest.text = dotted
        }
        Resultat.text = errorResultOutput
    }
    
    private func updatePickerView(res: String, component: Int){
        changeCurrency(res: res, component: component)
        pickerView.selectRow( pickerDataSource.index(where: { ($0[res] != nil)})! , inComponent: component, animated: false)
    }
    
    private func updatedTimeLabel(){
        lastUpdatedLabel.text = "\(updateOutput) \(myModel.lastUpdateTime)"
    }
    
}

