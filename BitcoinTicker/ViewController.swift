//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by rahul Ravi Prakash on 20/06/2018.
//  Copyright © 2018 Rahul Ravi Prakash. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
	let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
	var currencySelected = ""
	var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		currencyPicker.delegate = self
		currencyPicker.dataSource = self
       
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return currencyArray.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return currencyArray[row]
	}
	
	//Make something happen when user select item from pickerview.
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		//print(currencyArray[row]) // Check whether it works properly or not
		
		finalURL = baseURL + currencyArray[row]
		//print(finalURL)
		currencySelected = currencySymbolArray[row]
		getBitcoinData(url: finalURL)
	}
    
	
    
	
    //MARK: - Networking
    /***************************************************************/
	
    func getBitcoinData(url: String) {
		
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the Bitcoin data")
                    let bitcoinJSON : JSON = JSON(response.result.value!)

                    self.updateBicoinData(json: bitcoinJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }

	
	
//    //MARK: - JSON Parsing
//    /***************************************************************/
	
    func updateBicoinData(json : JSON) {
		
        if let bitcoinPriceResult = json["ask"].double {
			
			print(bitcoinPriceResult)
			bitcoinPriceLabel.text = "\(currencySelected) \(bitcoinPriceResult)"
		}
		else {
			bitcoinPriceLabel.text = "Price Unavailable"
		}
			
    }
//




}

