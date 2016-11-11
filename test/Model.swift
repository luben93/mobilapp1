//
//  File.swift
//  test
//
//  Created by lucas persson on 2015-11-20.
//  Copyright © 2015 lucas persson. All rights reserved.
//

import Foundation


class Model: NSObject, XMLParserDelegate {
    
    var currencyValue = [String : Double]()
    var currencyString = [ ["USD":"🇺🇸 Dollar"],
                           ["JPY":"🇯🇵 yen"	],
                           ["CZK":"🇵🇭 koruna"],
                           ["DKK":"🇩🇰 krone"	],
                           ["GBP":"🇬🇧 sterling"],
                           ["PLN":"🇮🇩 zloty"	],
                           ["SEK":"🇸🇪 krona"	],
                           ["EUR":"🇪🇺 EUR"	],
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
    var fromCurrency = "USD"
    var toCurrency = "USD"
   // var number = -1.0
    let save = UserDefaults.standard
    var lastUpdateTime = "2015-11-22"

    
    override init(){
        currencyValue["EUR"]=1.0
        super.init()
        print("saves dict: \(save.dictionary(forKey: "value"))")
        print("saves time: \(save.string(forKey: "time"))")
        
        if let tmp = save.string(forKey: "time"){
            print("useing saved time")
            lastUpdateTime = tmp
        }else{
            LoadData()
        }
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        if let time = format.date(from: lastUpdateTime){
            print(lastUpdateTime)
            if time.timeIntervalSinceNow <= -86400{
                print("do update")
                LoadData()
            }else{
                print("do read")
                if let curVal = save.dictionary(forKey: "value") as? [String : Double]{
                    print(curVal)
                    currencyValue = curVal
                    print("read above vals")
                }else{
                    print("noting to read, doing update")
                    LoadData()
                }
            }
        }else{
            print("error do date")
        }
        
 }
    
    func getCurrencys() -> [Dictionary<String,String>]{
        return currencyString
    }
    
    func updateCurrency(_ currency: String,toFrom:Int){
        if toFrom == 0 {
            fromCurrency = currency
        }else{
            toCurrency = currency
        }
    }
    
    func calculate(_ _number: Double) -> Double?{
        if let to=currencyValue[toCurrency]{
            if let from = currencyValue[fromCurrency]{
                return (_number/from)*to
            }
        }
        return nil
    }
    
    func LoadData(){
        let url = URL(string: "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml")!
        //let url = URL(string: "http://maceo.sth.kth.se/Home/eurofxref")!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            if let urlContent = data {
                
                let testXML = XMLParser(data: urlContent)
                testXML.delegate = self
                testXML.parse()
               // NotificationCenter.default.post(name: Notification.Name(rawValue: myNotificationKey), object: self)
                //do save
                self.save.set(self.currencyValue, forKey: "value")
                //self.save.set(self.lastUpdateTime, forKey: "time")
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
