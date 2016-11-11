//
//  File.swift
//  test
//
//  Created by lucas persson on 2015-11-20.
//  Copyright © 2015 lucas persson. All rights reserved.
//

import Foundation


class Model: NSObject, XMLParserDelegate {
    
    var currencyString = [ ["USD":"🇺🇸 Dollar"],
                           ["JPY":"🇯🇵 yen"   ],
                           ["CZK":"🇵🇭 koruna"],
                           ["DKK":"🇩🇰 krone" ],
                           ["GBP":"🇬🇧 sterling"],
                           ["PLN":"🇮🇩 zloty" ],
                           ["SEK":"🇸🇪 krona" ],
                           ["EUR":"🇪🇺 EUR"	 ],
                           ["NZD":"🇳🇿 dollar"],
                           ["PHP":"🇵🇭 pesos" ],
                           ["SGD":"🇸🇬 dollar"],
                           ["AUD":"🇦🇺 Dollar"],
                           ["CAD":"🇨🇦 Dollar"],
                           ["HKD":"🇭🇰 Dollar"],
                           ["BGN":" Leva"    ],
                           ["HUF":" Forint"  ],
                           ["RON":" Lei"     ],
                           ["CHF":" Francs"  ],
                           ["NOK":" Kroner"  ],
                           ["HRK":" Kuna"    ],
                           ["RUB":" Rubles"  ],
                           ["TRY":" Lira"    ],
                           ["BRL":" Reals"   ],
                           ["CNY":" Yuan"    ],
                           ["IDR":" Rupaihs" ],
                           ["ILS":" Shekels" ],
                           ["INR":" Rupees"  ],
                           ["KRW":" Won"     ],
                           ["MXN":" Pesos"   ],
                           ["MYR":" Ringgits"],
                           ["THB":" Baht"    ],
                           ["ZAR":" Rand"    ] ]
    var lastUpdateTime = "2015-11-22"
    var currencyValue = [String : Double]()
    let offline = false
    var inputed:Double {
        get {
            return save.double(forKey: "number") 
        }
        set{
            save.set(newValue,forKey: "number")
            save.synchronize()
        }
    }
    var save = UserDefaults.standard{
        didSet{
            print("saveing stuff")
            save.synchronize()
        }
    }
    
    var fromCurrency:String {
        get{
            return save.string(forKey: "fromCurrency") ?? "USD"
        }
        set{
            save.set(newValue,forKey: "fromCurrency")
            save.synchronize()
        }
    }
    var toCurrency:String {
        get{
            return save.string(forKey: "toCurrency") ?? "USD"
        }
        set{
            save.set(newValue,forKey: "toCurrency")
            save.synchronize()
        }
    }
    
    
    
    
    override init(){
        currencyValue["EUR"]=1.0
        super.init()
        
        if let tmp = save.string(forKey: "time"){
            print("useing saved time")
            lastUpdateTime = tmp
        }else{
            LoadData()
        }
        
        if let curVal = save.dictionary(forKey: "value") as? [String : Double]{
            print(curVal)
            currencyValue = curVal
            print("read above vals")
        }
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        if let time = format.date(from: lastUpdateTime){
            print(lastUpdateTime)
            if time.timeIntervalSinceNow <= -86400{
                print("do update")
                LoadData()
            }
        }else{
            print("error do date")
        }
    }
    
    func getCurrencys() -> [Dictionary<String,String>]{
        return currencyString
    }
    
    func calculate(_ number: Double) -> Double?{
        inputed = number
        if let to=currencyValue[toCurrency]{
            if let from = currencyValue[fromCurrency]{
                return (number/from)*to
            }
        }
        return nil
    }
    
    func LoadData(){
        if offline {
            print("pretending to be offline")
            return
        }
        //let url = URL(string: "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml")!
        let url = URL(string: "http://maceo.sth.kth.se/Home/eurofxref")!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            if let urlContent = data {
                
                let testXML = XMLParser(data: urlContent)
                testXML.delegate = self
                testXML.parse()
                // NotificationCenter.default.post(name: Notification.Name(rawValue: myNotificationKey), object: self)
                //TODO do save
                self.save.set(self.currencyValue, forKey: "value")
                self.save.synchronize()
                print("saved")
                
            }
        })
        task.resume()
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        if let time:String = attributeDict["time"]{
            lastUpdateTime = time
            save.setValue(time, forKey: "time")
            print(time)
        }
        if let cur = attributeDict["currency"]{
            if let rate = attributeDict["rate"]{
                addFlagsCurrency(cur)
                currencyValue[cur]=Double(rate)
            }
        }
    }
    
    func addFlagsCurrency(_ str:String){
        for currency in currencyString{
            if let _ = currency[str]{
                return
            }
        }
        currencyString.append([str:str])
    }
    
    
}
