//
//  ViewController.swift
//  Braintree-CreditCards-Swift
//
//  Created by MTS Dublin on 23/11/2016.
//  Copyright © 2016 BraintreeEMEA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
   var braintreeClient: BTCardClient?
    var price: Double=0
    var nonce: String = ""
    
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var expiryMonthTextField: UITextField!
    @IBOutlet weak var expiryYearTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    
    
    @IBAction func payButtonTapped(sender: AnyObject) {
        
        
        let braintreeClient = BTAPIClient(authorization: "sandbox_tpt8mgp5_26qns4ycnjgrr6cv")!
        let cardClient = BTCardClient(APIClient: braintreeClient)
        let card = BTCard(number: cardNumberTextField.text!, expirationMonth: expiryMonthTextField.text!, expirationYear: expiryYearTextField.text!, cvv: cvvTextField.text!)
        cardClient.tokenizeCard(card) { (tokenizedCard, error) in
            // Communicate the tokenizedCard.nonce to your server, or handle error
            
            self.nonce = (tokenizedCard?.nonce)!
            
            print("Nonce received: ",tokenizedCard!.nonce)
            
            // Send the nonce to the server
            
            self.postNonceToServer(self.nonce)
        }

        
        
    }
    
    func postNonceToServer(paymentMethodNonce: String) {
        price = 13.99
        let paymentURL = NSURL(string: "http://orcodevbox.co.uk/BTOrcun/iosPayment.php")!
        let request = NSMutableURLRequest(URL: paymentURL)
        request.HTTPBody = "amount=\(Double(price))&payment_method_nonce=\(self.nonce)".dataUsingEncoding(NSUTF8StringEncoding);
        request.HTTPMethod = "POST"
        
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            // TODO: Handle success or failure
            let responseData = String(data: data!, encoding: NSUTF8StringEncoding)
            // Log the response in console
            print(responseData);
            
            // Display the result in an alert view
            dispatch_async(dispatch_get_main_queue(), {
                let alertResponse = UIAlertController(title: "Result", message: "\(responseData)", preferredStyle: UIAlertControllerStyle.Alert)
                
                // add an action to the alert (button)
                alertResponse.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                
                // show the alert
                self.presentViewController(alertResponse, animated: true, completion: nil)
                
            })
            
            }.resume()
    }
 
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

