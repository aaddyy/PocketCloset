import UIKit
import Parse

class TagManager: NSObject {
    var user: User?
    
    var Item: PFFile
    var StyleTag: String
    var TypeTag: String
    var ColorTag: String
    var PatternTag: String
    var Category:String
    
    init(Item: PFFile, StyleTag: String, TypeTag: String, ColorTag: String, PatternTag: String, Category: String) {
        self.Item = Item
        self.StyleTag = StyleTag
        self.TypeTag = TypeTag
        self.ColorTag = ColorTag
        self.PatternTag = PatternTag
        self.Category = Category
    }
    
    //Parseへ保存
    func save(){
        let tagmanagerObject = PFObject(className: "TagManager")
        tagmanagerObject["Item"] = Item
        tagmanagerObject["StyleTag"] = StyleTag
        tagmanagerObject["TypeTag"] = TypeTag
        tagmanagerObject["ColorTag"] = ColorTag
        tagmanagerObject["PatternTag"] = PatternTag
        tagmanagerObject["Category"] = Category
        tagmanagerObject["user"] = PFUser.currentUser()
        tagmanagerObject.saveInBackgroundWithBlock { (success, error) in
            if success{
            }
        }
    }
}
