//
//  ViewController.swift
//  coredataDEMO
//
//  Created by anil kumar srivastava on 9/11/17.
//  Copyright © 2017 AditiSrivastava. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {

    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var name: UITextField!
    
    
    @IBOutlet weak var address: UITextField!
    
    @IBOutlet weak var mobile: UITextField!
    
    
    @IBOutlet weak var status: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func save(_ sender: Any) {
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Contacts",
                                       in: managedObjectContext)
        
        let contact = Contacts(entity: entityDescription!,
                              insertInto: managedObjectContext)
        
        contact.name = name.text!
        contact.address = address.text!
        contact.mobile = mobile.text!
        
        do {
            try managedObjectContext.save()
            name.text = ""
            address.text = ""
            mobile.text = ""
            status.text = "Contact Saved"
            
        } catch let error {
            status.text = error.localizedDescription
        }

        
        
        
    }
    
    @IBAction func find(_ sender: Any) {
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "Contacts",
                                       in: managedObjectContext)
        
        let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "(name = %@)", name.text!)
        request.predicate = pred
        
        do {
            var results =
                try managedObjectContext.fetch(request as!
                    NSFetchRequest<NSFetchRequestResult>)
            
            if results.count > 0 {
                let match = results[0] as! NSManagedObject
                
                name.text = match.value(forKey: "name") as? String
                address.text = match.value(forKey: "address") as? String
                mobile.text = match.value(forKey: "mobile") as? String
                status.text = "Matches found: \(results.count)"
            } else {
                status.text = "No Match"
            }
            
        } catch let error {
            status.text = error.localizedDescription
        }

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

