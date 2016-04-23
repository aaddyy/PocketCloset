import UIKit
import Parse
import Foundation

class EditorViewController: imageEditorViewController{
    var alertTitle:String!
    var alertController: UIAlertController!
    var forObjectiveCimage:UIImage! = RecognitionImage
    var forObjectiveCsave:UIImage! = RecognitionImage
    var imageColor = UIColor(red: 240/255, green: 150/255, blue: 155/255, alpha: 1.0)
    var imageColor2 = UIColor(red: 240/255, green: 150/255, blue: 155/255, alpha: 0.2)
    var tag:Int! = 0
    var text: String!
    var layerX: CGFloat!
    var objectiveView:UIView!
    var target:AnyObject!
    var action:Selector!
    var test = []
    var flag = forReEditFlag
    var LangFlag = TOPS
    var GuideView:UIView!
    
    var SELECT_ITEM_AREA = NSLocalizedString("SELECT_ITEM_AREA", comment:"" )
    var SHOW_EDITED_ITEM = NSLocalizedString("SHOW_EDITED_ITEM", comment:"" )
    var REGISTRATION_ITEM = NSLocalizedString("REGISTRATION_ITEM", comment:"" )
    var BACK_TO_THE_BIGGINING = NSLocalizedString("BACK_TO_THE_BIGGINING", comment:"" )
    var BACK = NSLocalizedString("BACK", comment:"" )
    var REDO = NSLocalizedString("REDO", comment:"" )
    var BUTTON_TITLE_HIDE_RESULTS = NSLocalizedString("BUTTON_TITLE_HIDE_RESULTS", comment:"" )
    var EDITCLEAR = NSLocalizedString("EDITCLEAR", comment:"" )
    var REGISTRATION_SUCCESS = NSLocalizedString("REGISTRATION_SUCCESS", comment:"" )
    var PREPARE_EDIT = NSLocalizedString("PREPARE_EDIT", comment:"" )
    var EDIT_WAY = NSLocalizedString("EDIT_WAY", comment:"" )
    var TOMYCLOSET = NSLocalizedString("TOMYCLOSET", comment:"" )
    var ITEMTOUCH = NSLocalizedString("ITEMTOUCH", comment:"" )
    var ERASER = NSLocalizedString("ERASER", comment:"" )
    var UPDATE = NSLocalizedString("UPDATE", comment:"" )
    var UPDATE_SUCCESS = NSLocalizedString("UPDATE_SUCCESS", comment:"" );
    
//setObject系
    //setButton
    var iconButtons:Array<UIButton> = []
    var imageName:String!
    var imageEdgeTop:CGFloat! = 0
    var imageEdgeLeft:CGFloat! = 30
    var titleEdgeTop:CGFloat! = 45
    var titleEdgeLeft:CGFloat! = -25

    func Guide(){
        if TOPS == "Tops"{
            Expression(GuideView, guideImage: "guide3en.png")
        }else{
            Expression(GuideView, guideImage: "guide3.png")
        }
        guideButton.addTarget(self, action: "removeGuide", forControlEvents: .TouchUpInside)
    }
    func removeGuide(){
        top.removeFromSuperview()
        middle.removeFromSuperview()
        backGround.removeFromSuperview()
        guideButton.removeFromSuperview()
    }
    
    func setButton(){
        let button = UIButton()
        button.frame = CGRectMake(0,0,120,60)
        button.backgroundColor = UIColor.whiteColor()
        button.layer.masksToBounds = true
        button.setTitle(text, forState: .Normal)
        button.setTitleColor(imageColor, forState: .Normal)
        button.titleLabel!.font = UIFont(name: "HiraKakuProN-W3", size: 12)
        button.titleLabel?.numberOfLines = 2
        let backImage = UIImage(named: imageName)!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        button.setImage(backImage, forState: .Normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeTop, imageEdgeLeft, 0, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeTop, titleEdgeLeft, 0, 0);
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.tintColor = imageColor
        button.tag = tag
        iconButtons.append(button)
    }
    //setImage
    func setImageView(X:CGFloat, Y:CGFloat, sizeX:CGFloat, sizeY:CGFloat, image:UIImage, tag:Int,view:UIView){
        let imageView = UIImageView()
        imageView.frame = CGRectMake(X, Y, sizeX, sizeY)
        if imageFlag == "RegistrarionView"{
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
        }else{
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
        }
        imageFlag = ""
        imageView.image = image
        imageView.tag = tag
        view.addSubview(imageView)
    }
    //setLabel
    var iconLabels:Array<UILabel> = []
    func setLabel(){
        let label = UILabel()
        label.frame = CGRectMake(0,0,200,30)
        label.backgroundColor = UIColor.clearColor()
        label.layer.masksToBounds = true
        label.text = text
        label.textColor = imageColor
        label.tintColor = imageColor
        label.font = UIFont(name: "HiraKakuProN-W3", size: 15)
        label.textAlignment = NSTextAlignment.Center
        label.layer.borderColor = UIColor.whiteColor().CGColor
        label.numberOfLines = 3
        iconLabels.append(label)
    }
    
    //アイテム登録
    func Registration(){
        if PFUser.currentUser() == nil {
            self.consent()
        }else{
            let image = UIImagePNGRepresentation(forObjectiveCsave)!
            let Item = PFFile(name: "Item", data: image)
            let tagmanager = TagManager(Item: Item!, StyleTag: Recognized[0]["tag"]!, TypeTag: Recognized[1]["tag"]!,  ColorTag: Recognized[2]["tag"]!, PatternTag: Recognized[3]["tag"]!, Category:Recognized[4]["Category"]!)
            tagmanager.save()
            self.alert()
        }
    }
    
    //
    func dispatch_async_global(block: () -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
    }
    func dispatch_async_main(block: () -> ()) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
    //
    
    //ユーザー登録/ログインの確認
    func consent() {
        let alertConsent = UIAlertController(title: IF_YOU_USE_THE_ITEM_REGISTRATION_PLEASE_DO_USER_LOGIN, message: "", preferredStyle: .Alert)
        let signUpAction = UIAlertAction(title: USER_REGISTER_LOGIN, style: .Default,
            handler:{ (action:UIAlertAction!) -> Void in
                self.execution()
        })
        let cancelAction = UIAlertAction(title: CANCEL, style: .Default,
            handler:{ (action:UIAlertAction!) -> Void in
        })
        alertConsent.addAction(signUpAction)
        alertConsent.addAction(cancelAction)
        presentViewController(alertConsent, animated: true, completion: nil)
    }
    //
    
    //読込中画面
    //ActivityIndicator
    var analyzingView = UIView()
    var tempActivityIndicator = UIActivityIndicatorView()
    var tempLabel = UILabel()
    func analyzing(){
        analyzingView.backgroundColor = UIColor.whiteColor()
        tempActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        tempActivityIndicator.frame = CGRectMake(0, 0, 100, 100)
        tempActivityIndicator.color = imageColor
        tempActivityIndicator.startAnimating()
        tempActivityIndicator.layer.position = CGPointMake(analyzingView.bounds.size.width/2, analyzingView.bounds.size.height/2)
        analyzingView.addSubview(tempActivityIndicator)
        //Label
        tempLabel.frame = CGRectMake(0, 0, 150, 50)
        tempLabel.backgroundColor = UIColor.whiteColor()
        //tempLabel.text = text
        tempLabel.numberOfLines = 3
        tempLabel.textAlignment = NSTextAlignment.Center
        tempLabel.textColor = imageColor
        tempLabel.layer.position = CGPointMake(analyzingView.bounds.size.width/2, analyzingView.bounds.size.height*(3/5))
        analyzingView.addSubview(tempLabel)
    }
    
    //画面遷移系
    func execution(){
        performSegueWithIdentifier("ModalLoginViewController", sender: self)
    }
    func Back(){
        self.presentingViewController!.presentingViewController!.dismissViewControllerAnimated(false, completion: nil)
    }
    func BackMyCloset(){
        self.presentingViewController!.dismissViewControllerAnimated(false, completion: nil)
    }
    //alert系
    func alert() {
        UIAlertController.appearance().tintColor = imageColor
//        alertTitle = REGISTRATION_SUCCESS
        alertController = UIAlertController(title: alertTitle, message: "", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }
}
