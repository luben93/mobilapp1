//
//  File.swift
//  test
//
//  Created by Jonas Wåhslén on 2015-10-24.
//  Copyright © 2015 Jonas Wåhslén. All rights reserved.
//

import Foundation


class Model: NSObject, NSXMLParserDelegate {
    
    var currencyValue = [Dictionary< String,Double>()]
    var currencyString = [Dictionary<String, String>()]
    var fromCurrency: String
    var toCurrency: String
    var number: Double
   // var FirstCurrency: Int
   // var SecondCurrency: Int
    
    override init(){
        fromCurrency="SEK"
        toCurrency="EUR"
     number = -1
//     FirstCurrency = 1
//     SecondCurrency = 3
        currencyValue.append([
            "USD"	:	1.1084,
            "JPY"	:	133.80,
            "CZK"	:	27.074,
            "DKK"	:	7.4597,
            "GBP"	:	0.7195,
            "PLN"	:	4.2529,
            "RON"	:	4.4269,
            "SEK"	:	9.4079,
            "EUR"	:		1.0		])
        currencyValue[0]["EUR"]=1.0
     currencyString.append(["🇺🇸 US Dollar":"USD","🇯🇵 Japanese yen":"JPY","🇵🇭 Czech koruna":"CZK","🇩🇰 Danish krone":"DKK","🇬🇧 Pound sterling":"GBP","🇮🇩 Polish zloty":"PLN","🇸🇪 Swedish krona":"SEK","🇪🇺 Europeriska EUR=":"EUR"])
     
        
    }
    
    
    func calculate(){
        print("error ")
    }
    
    func calculate(_number: Double){
        NSNotificationCenter.defaultCenter().postNotificationName(myNotificationKey, object: self)
        print("calculating to:\(currencyValue[0][toCurrency]) from:\(currencyValue[0][fromCurrency])")
        if let to=currencyValue[0][toCurrency]{
            if let from = currencyValue[0][fromCurrency]{
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
        
        let url = NSURL(string: "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml")!
    
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
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
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        print (attributeDict)
        if let cur = attributeDict["currency"]{
            if let rate = attributeDict["rate"]{
                    currencyValue[0][cur]=Double(rate)
            }
        }
    }

}