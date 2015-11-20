//
//  File.swift
//  test
//
//  Created by Jonas Wåhslén on 2015-10-24.
//  Copyright © 2015 Jonas Wåhslén. All rights reserved.
//

import Foundation


class Model: NSObject, NSXMLParserDelegate {
    
    var currencyValue = [Dictionary<Double, String>()]
    var currencyString = [Dictionary<String, String>()]
    
    var number: Double
    var FirstCurrency: Int
    var SecondCurrency: Int
    
    override init(){
     number = 3.0
     FirstCurrency = 1
     SecondCurrency = 3
     currencyValue.append([1.1084:"USD",133.80:"JPY",27.074:"CZK",7.4597:"DKK",0.71955:"GBP",4.2529:"PLN",4.4269:"RON",9.4079:"SEK",1.0:"EURO"])
     currencyString.append(["🇺🇸 US Dollar":"USD","🇯🇵 Japanese yen":"JPY","🇵🇭 Czech koruna":"CZK","🇩🇰 Danish krone":"DKK","🇬🇧 Pound sterling":"GBP","🇮🇩 Polish zloty":"PLN","🇸🇪 Swedish krona":"SEK","🇪🇺 Europeriska EURO":"EURO"])
     
        
    }
    
    
    
    func calculate(){
        print("test")
    }
    
    func calculate(_number: Double){
        NSNotificationCenter.defaultCenter().postNotificationName(myNotificationKey, object: self)
         number = _number
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
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        print(attributeDict)
        
    }

}