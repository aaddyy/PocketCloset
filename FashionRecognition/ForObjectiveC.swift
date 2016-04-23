import Foundation
import UIKit
import Parse

class ForObjectiveC: NSObject {
    var ObjectiveCSave:UIImage!
    var UPDATE_SUCCESS = NSLocalizedString("UPDATE_SUCCESS", comment:"" );
    var REGISTRATION_SUCCESS = NSLocalizedString("REGISTRATION_SUCCESS", comment:"" );

    func RegistrationC(){
        if PFUser.currentUser() == nil {
        }else{
            let image = UIImagePNGRepresentation(ObjectiveCSave)!
            let Item = PFFile(name: "Item", data: image)
            let tagmanager = TagManager(Item: Item!, StyleTag: Recognized[0]["tag"]!, TypeTag: Recognized[1]["tag"]!,  ColorTag: Recognized[2]["tag"]!, PatternTag: Recognized[3]["tag"]!, Category:Recognized[4]["Category"]!)
            tagmanager.save()
        }
    }
    func UpdateC(){
        let queryInfo = PFQuery(className: "TagManager")
        queryInfo.getObjectInBackgroundWithId(currentObjectId, block: { (object, error) -> Void in
            
            let image = UIImagePNGRepresentation(self.ObjectiveCSave)!
            let Item = PFFile(name: "Item", data: image)
            object!["Item"] = Item
            object!["StyleTag"] = globalStyleTag
            object!["TypeTag"] = globalTypeTag
            object!["ColorTag"] = globalColorTag
            object!["PatternTag"] = globalPatternTag
            
            var check = globalTypeTag
            if check.containsString(JACKET) || check.containsString(SHIRT) || check.containsString(COAT) || check.containsString(SWEAT) || check.containsString(ONEPIECE_DRESS)||check.containsString(CARDIGAN){
                object!["Category"] = TOPS
            }else if check.containsString(SKIRT)||check.containsString(SLACKS)||check.containsString(PANTS1)||check.containsString(PANTS2)||check.containsString(DENIM){
                object!["Category"] = BOTTOMS
            }else if check.containsString(SHOES1)||check.containsString(SHOES2)||check.containsString(PUMPS){
                object!["Category"] = SHOES
            }else if check.containsString(BAG){
                object!["Category"] = BAG
            }else{
                object!["Category"] = MISCELLANEOUS_GOODS
            }
            try! object!.save()
        })
    }
    
    //alert系
    var alertTitle:String!
    var alertController: UIAlertController!
    func alert() {
        UIAlertController.appearance().tintColor = imageColor
        alertController = UIAlertController(title: alertTitle, message: "", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(action)
    }
}
