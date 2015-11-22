//
//  File.swift
//  test
//
//  Created by Jonas Wåhslén on 2015-10-24.
//  Copyright © 2015 Jonas Wåhslén. All rights reserved.
//

import Foundation


class Model: NSObject, NSXMLParserDelegate {
    
    var currencyValue = Dictionary< String,Double>()
    var currencyString = [Dictionary<String, String>()]
    var fromCurrency = "SEK"
    var toCurrency = "EUR"
    var number: -1.0
    let save = NSUserDefaults.standardUserDefaults()
    var lastUpdateTime: String
    // var FirstCurrency: Int
    // var SecondCurrency: Int
    
    override init(){
                       // let format = NSDateFormatter()
       // format.dateFormat = "yyyy-MM-dd"
       // lastUpdateTime = format.dateFromString("2014-11-21")!
       /*
        currencyValue[   "USD"	] =  1.1084
        currencyValue[   "JPY"	] =  133.80
        currencyValue[   "CZK"	] =	27.074
        currencyValue[   "DKK"	] =	7.4597
        currencyValue[   "GBP"	] =	0.7195
        currencyValue[  "PLN"	] =	4.2529
        currencyValue[   "RON"	] =	4.4269
        currencyValue[   "SEK"	] =	9.4079
        currencyValue[   "EUR"	] =     1.0
        */
        
        updateTime(save.stringForKey("time")!)
        print(lastUpdateTime)
        currencyString.append(["🇺🇸 US Dollar":"USD","🇯🇵 Japanese yen":"JPY","🇵🇭 Czech koruna":"CZK","🇩🇰 Danish krone":"DKK","🇬🇧 Pound sterling":"GBP","🇮🇩 Polish zloty":"PLN","🇸🇪 Swedish krona":"SEK","🇪🇺 Europeriska EUR=":"EUR"])
        
        
        
        
    }
    
    
    func calculate(){
        print("error calculate")
    }
    
    func calculate(_number: Double){
        NSNotificationCenter.defaultCenter().postNotificationName(myNotificationKey, object: self)
        print("calculating to:\(currencyValue[toCurrency]) from:\(currencyValue[fromCurrency])")
        if let to=currencyValue[toCurrency]{
            if let from = currencyValue[fromCurrency]{
                print("to and from")
                number = (_number/from)*to
            }else{
                print("from nil")
                calculate()
            }
        }else{
            //TODO better errorhandling
            print("to nil")
            
            calculate()
        }
    }
    
    func getText()->Double{
        return number
    }
    
    
    func LoadData(){
        
        print("load begun")
        let url = NSURL(string: "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml")!
        //let url = NSURL(string: "http://maceo.sth.kth.se/Home/eurofxref")!
        //if lastUpdateTime.timeIntervalSinceNow <= -86400{
        if updateTime(save.stringForKey("time")){
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                print("task has begun")
                if let urlContent = data {
                    let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                    print(webContent)
                    let testXML = NSXMLParser(data: urlContent)
                    testXML.delegate = self
                    testXML.parse()
                    NSNotificationCenter.defaultCenter().postNotificationName(myNotificationKey, object: self)
                }
            }
            task.resume()
            save.setValue(currencyValue, forKey: "value")

            //if no network read from file aswell
        }else{
            print("load from file")
            if let tmp = save.objectForKey("value"){
                currencyValue = tmp as! Dictionary<String, Double>
            }else{
                print("read error")
            }
        }
    }
    
    private func updateTime(intime: String) -> Bool {
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        if let out = format.dateFromString(intime){
            return out
        }
        return NSDate.

    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        print (attributeDict)
        if let time = attributeDict["time"]{
            updateTime(time)
            setValue(time, forKey: "time")
        }
        if let cur = attributeDict["currency"]{
            if let rate = attributeDict["rate"]{
                currencyValue[cur]=Double(rate)
            }
        }
    }
    
}