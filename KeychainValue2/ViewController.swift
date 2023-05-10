//
//  ViewController.swift
//  KeychainValue2
//
//  Created by mangesht on 10/05/23.
//
import UIKit
import Security

class ViewController: UIViewController {
    
    @IBOutlet weak var keychainLabel: UILabel!
    let keychainService = "com.cybage.service"
    let keychainAccount = "com.cybage.account"
    let accessGroup = "<#TeamID#>.com.cybage.SharedItems"

    override func viewDidLoad() {
        super.viewDidLoad()
        displayValue()
    }
    
    @IBAction func btnDeleteTapped(_ sender: Any) {
        deleteFromKeychain()
    }
    
    
    @IBAction func btnGetTapped(_ sender: Any) {
        displayValue()
    }
    
    @IBAction func btnUpdateTapped(_ sender: Any) {
        let valueToSave = "Hello, Keychain! secret V2-896"
        updateToKeychain(value: valueToSave)
        displayValue()
    }
    
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        let valueToSave = "Hello, Keychain! secret V2-123"
        saveToKeychain(value: valueToSave)
        displayValue()
    }
    
    func  displayValue()  {
        let retrievedValue = retrieveFromKeychain()
        if let value = retrievedValue {
            keychainLabel.text = value
        } else {
            keychainLabel.text = "No Keychain Value Available"
        }
    }
    
    func saveToKeychain(value: String) {
        guard let data = value.data(using: .utf8) else { return }


        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecAttrAccessGroup as String: accessGroup,
            kSecValueData as String: data
        ] as [String: Any]

        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Error saving to Keychain: \(status)")
        }
    }
    func updateToKeychain(value: String) {
        guard let data = value.data(using: .utf8) else { return }
        
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecValueData as String: data
        ] as [String: Any]
        
        let update = [
            kSecValueData as String: data
        ]
        
        let status = SecItemUpdate(query as CFDictionary, update as CFDictionary)
        if status != errSecSuccess {
            print("Error updating Keychain item: \(status)")
        }
    }

    func deleteFromKeychain() {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount
        ] as [String: Any]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("Error deleting Keychain item: \(status)")
        }
    }

    
    func retrieveFromKeychain() -> String? {
        
        
        
//        let query:[String:Any] = [
//            kSecClass as String: kSecClassGenericPassword as String,
//            kSecAttrAccount as String: keychainAccount,
//            kSecReturnData as String: true,
//            kSecMatchLimit as String: kSecMatchLimitOne,
//            kSecAttrAccessGroup as String: accessGroup
//        ]
//
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecAttrAccessGroup as String: accessGroup,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ] as [String: Any]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return value
    }
}
