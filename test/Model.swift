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
    var currencyString = [Dictionary<String,String>]()
    var fromCurrency = "USD"
    var toCurrency = "USD"
    var number = -1.0
    let save = NSUserDefaults.standardUserDefaults()
    var lastUpdateTime:String
    
    override init(){
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
        currencyString.append(["USD":"🇺🇸  Dollar"	])
        currencyString.append(["JPY":"🇯🇵  yen"	])
        currencyString.append(["CZK":"🇵🇭  koruna"	])
        currencyString.append(["DKK":"🇩🇰  krone"	])
        currencyString.append(["GBP":"🇬🇧  sterling"	])
        currencyString.append(["PLN":"🇮🇩  zloty"	])
        currencyString.append(["SEK":"🇸🇪  krona"	])
        currencyString.append(["EUR":"🇪🇺  EUR"	])
        currencyString.append(["BGN":" Leva"])
        currencyString.append(["HUF":" Forint"])
        currencyString.append(["RON":" Lei"])
        currencyString.append(["CHF":" Francs"])
        currencyString.append(["NOK":" Kroner"])
        currencyString.append(["HRK":" Kuna"])
        currencyString.append(["RUB":" Rubles"])
        currencyString.append(["TRY":" Lira"])
        currencyString.append(["AUD":" A Dollar"])
        currencyString.append(["BRL":" Reals"])
        currencyString.append(["CAD":" C Dollar"])
        currencyString.append(["CNY":" Yuan"])
        currencyString.append(["HKD":" H Dollar"])
        currencyString.append(["IDR":" Rupaihs"])
        currencyString.append(["ILS":" Shekels"])
        currencyString.append(["INR":" Rupees"])
        currencyString.append(["KRW":" Won"])
        currencyString.append(["MXN":" Pesos"])
        currencyString.append(["MYR":" Ringgits"])
        currencyString.append(["NZD":" NZ dollar"])
        currencyString.append(["PHP":" PH pesos"])
        currencyString.append(["SGD":" S dollar"])
        currencyString.append(["THB":" Baht"])
        currencyString.append(["ZAR":" Rand"])
    }
    
    func getCurrencys() -> [Dictionary<String,String>]{
        return currencyString
    }
    
    func calculate(){
        print("error calculate")
    }
    
    func updateCurrency(currency: [String:String],toFrom:Int){
        if toFrom == 0 {
            fromCurrency = currency.first!.0
        }else{
            toCurrency = currency.first!.0
        }
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
        
        let url = NSURL(string: "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml")!
        //let url = NSURL(string: "http://maceo.sth.kth.se/Home/eurofxref")!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            if let urlContent = data {
                
                let testXML = NSXMLParser(data: urlContent)
                testXML.delegate = self
                testXML.parse()
                NSNotificationCenter.defaultCenter().postNotificationName(myNotificationKey, object: self)
            }
        }
        task.resume()
    }
    
    
    
    
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
                addFlagsCurrency(cur)
                currencyValue[cur]=Double(rate)
                print(currencyValue[cur])
            }
        }
    }
    
    func addFlagsCurrency(str:String){
        for currency in currencyString{
            if let _ = currency[str]{
                return
            }
        }
        currencyString.append([str:str])
    }
    
    
}