//
//  IAPMaster.swift
//  IAPMaster
//
//  Created by Suraphan on 11/29/2558 BE.
//  Copyright © 2558 irawd. All rights reserved.
//

import StoreKit

class IAPMaster: NSObject {

    static let sharedInstance = IAPMaster()
    
    let productRequestHandler:ProductRequestHandler
    let paymentRequestHandler:PaymentRequestHandler
    let receiptRequestHandler:ReceiptRequestHandler
    
    override init() {
        self.productRequestHandler = ProductRequestHandler.init()
        self.paymentRequestHandler = PaymentRequestHandler.init()
        self.receiptRequestHandler = ReceiptRequestHandler.init()
        super.init()
    }

    deinit{
    }
    func setProductionMode(isProduction:Bool){
        self.receiptRequestHandler.isProduction = isProduction
    }
    func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    func receiptURL() -> NSURL {
        return self.receiptRequestHandler.receiptURL()
    }
    
    //  MARK: - Product
    func productForIdentifier(productIdentifier:String) -> SKProduct{
        return self.productRequestHandler.products[productIdentifier]!
    }
    func requestProducts(productIDS:Set<String>,completion:RequestProductCallback){
        self.productRequestHandler.requestProduc(productIDS, requestCallback: completion)
    }
    //  MARK: - Purchase
    func addPayment(productIDS: String,userIdentifier:String?, addPaymentCallback: AddPaymentCallback){
        let product = self.productRequestHandler.products[productIDS]
        if product != nil {
            self.paymentRequestHandler.addPayment(product!, userIdentifier: userIdentifier, addPaymentCallback: addPaymentCallback)
        }else{
            addPaymentCallback(result:.Failed(error: NSError.init(domain: "AddPayment Unknow Product identifier", code: 0, userInfo: nil)))
        }
    }
    //  MARK: - Restore
    func restoreTransaction(userIdentifier:String?,addPaymentCallback: AddPaymentCallback){
        self.paymentRequestHandler.restoreTransaction(userIdentifier, addPaymentCallback: addPaymentCallback)
    }
    func checkIncompleteTransaction(addPaymentCallback: AddPaymentCallback){
        self.paymentRequestHandler.checkIncompleteTransaction(addPaymentCallback)
    }
    //  MARK: - Receipt
    func refreshReceipt(requestCallback: RequestReceiptCallback){
        self.receiptRequestHandler.refreshReceipt(requestCallback)
    }
    func verifyReceipt(autoRenewableSubscriptionsPassword:String?,receiptVerifyCallback:ReceiptVerifyCallback){
        self.receiptRequestHandler.verifyReceipt(autoRenewableSubscriptionsPassword, receiptVerifyCallback: receiptVerifyCallback)
    }
}
