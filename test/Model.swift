//
//  File.swift
//  test
//
//  Created by lucas persson on 2015-11-20.
//  Copyright © 2015 lucas persson. All rights reserved.
//

import Foundation


class Model: NSObject, NSXMLParserDelegate {
    
    var currencyValue = [String : Double]()
    var currencyString = [Dictionary<String, String>()]
    var fromCurrency = "SEK"
    var toCurrency = "EUR"
    var number = -1.0
    let save = NSUserDefaults.standardUserDefaults()
    var lastUpdateTime:String //= "2014-11-10"
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
        currencyValue[   "PLN"	] =	4.2529
        currencyValue[   "RON"	] =	4.4269
        currencyValue[   "SEK"	] =	9.4079
        currencyValue[   "EUR"	] =     1.0
        */
        currencyValue["EUR"]=1.0
        lastUpdateTime = "2015-11-22"
        super.init()

        if let tmp = save.stringForKey("time"){
            lastUpdateTime = tmp
        }else{
            LoadData()
        }

        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        if let time = format.dateFromString(lastUpdateTime){
            print(lastUpdateTime)
            if time.timeIntervalSinceNow <= -86400{
                print("do update")
                LoadData()
            }else{
                print("do read")
                currencyValue = save.dictionaryForKey("value") as! [String : Double]
                print(currencyValue)
            }
        }else{
            print("error do date")
        }
        currencyString.append(["🇺🇸 US Dollar":"USD","🇯🇵 Japanese yen":"JPY","🇵🇭 Czech koruna":"CZK","🇩🇰 Danish krone":"DKK","🇬🇧 Pound sterling":"GBP","🇮🇩 Polish zloty":"PLN","🇸🇪 Swedish krona":"SEK","🇪🇺 Europeriska EUR=":"EUR"])
        
    }
    
    func getCurrencys() -> [String : String]{
         return currencyString[0]
    }
    
    func calculate(){
        print("error calculate")
    }
    
    func calculate(_number: Double){
        print(currencyValue["SEK"])
        NSNotificationCenter.defaultCenter().postNotificationName(myNotificationKey, object: self)
        print("calculating to:\(currencyValue[toCurrency]) from:\(currencyValue[fromCurrency])")
        if let to=currencyValue[toCurrency]{
            if let from = currencyValue[fromCurrency]{
                print("to and from")
                number = (_number/from)*to
            }else{
                calculate()
            }
        }else{
            calculate()
        }
    }
    
    func getText()->Double{
        return number
    }
    
    func LoadData(){
        
        //let url = NSURL(string: "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml")!
        let url = NSURL(string: "http://maceo.sth.kth.se/Home/eurofxref")!

        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            if let urlContent = data {
//                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
//                print(webContent)
                let testXML = NSXMLParser(data: urlContent)
                testXML.delegate = self
                testXML.parse()
                NSNotificationCenter.defaultCenter().postNotificationName(myNotificationKey, object: self)
            }
        }
        task.resume()
    }

    
//    func LoadData(){
//        
//        print("load begun")
//        //let url = NSURL(string: "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml")!
//        let url = NSURL(string: "http://maceo.sth.kth.se/Home/eurofxref")!
//        //if updateTime().timeIntervalSinceNow <= -86400{
//            //print(NSDate())
//            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
//                print("task has begun")
//                if let urlContent = data {
//                    //let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
//                    //print(webContent)
//                    let testXML = NSXMLParser(data: urlContent)
//                    testXML.delegate = self
//                    testXML.parse()
//                    NSNotificationCenter.defaultCenter().postNotificationName(myNotificationKey, object: self)
//            }
       //     }
  //          task.resume()
        //save.setValue(currencyValue, forKey: "value")


            //if no network read from file aswell
//        }else{
//            print("load from file")
//            if let tmp = save.dictionaryForKey("value"){
//                currencyValue = tmp as! Dictionary<String, Double>
//                if let time = save.stringForKey("time"){
//                    print(lastUpdateTime)
//                    lastUpdateTime = time
//                    print(lastUpdateTime)
//                }else{
//                    print("read error")
//                }
//                print(currencyValue)
//            }else{
//                print("read error")
//            }
 //       }
//    }
    
    private func updateTime() -> NSDate {
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        if let out = format.dateFromString(lastUpdateTime){
            return out
        }
        return format.dateFromString("2014-11-14")!
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        print (attributeDict)
        if let time = attributeDict["time"]{
            lastUpdateTime = time
            save.setValue(time, forKey: "time")
            print(time)
        }
        if let cur = attributeDict["currency"]{
            if let rate = attributeDict["rate"]{
                
                currencyValue[cur]=Double(rate)
                print(currencyValue[cur])
            }
        }
    }
    
}