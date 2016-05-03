import UIKit
import Parse
import Foundation
import Onboard

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
    var base:UIView!
    var vc:OnboardingViewController!
    
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
    var UPDATE_SUCCESS = NSLocalizedString("UPDATE_SUCCESS", comment:"" )
    var LOGOUT = NSLocalizedString("LOGOUT", comment:"" )
    var HELP =  NSLocalizedString("HELP", comment:"" )
    var SKIP =  NSLocalizedString("SKIP", comment:"" )

    
//setObject系
    //setButton
    var iconButtons:Array<UIButton> = []
    var imageName:String!
    var imageEdgeTop:CGFloat! = 0
    var imageEdgeLeft:CGFloat! = 30
    var titleEdgeTop:CGFloat! = 45
    var titleEdgeLeft:CGFloat! = -25
    
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
    func setButtonSkip(){
        let button = UIButton()
        button.frame = CGRectMake(0,0,120,60)
        button.backgroundColor = UIColor.whiteColor()
        button.layer.masksToBounds = true
        button.setTitle(text, forState: .Normal)
        button.setTitleColor(imageColor, forState: .Normal)
        button.titleLabel!.font = UIFont(name: "HiraKakuProN-W3", size: 12)
        button.titleLabel?.numberOfLines = 2
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
    //Guide用
    func localGuide(){
        base = UIView()
        base.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
        base.backgroundColor = UIColor.whiteColor()
        if TOPS == "Tops"{
            Guide(GUIDE07, body1: GUIDE08, body2: GUIDE09, image1: "guide3-1en.png", image2: "guide3-2.png", view: base)
        }else{
            Guide(GUIDE07, body1: GUIDE08, body2: GUIDE09, image1: "guide3-1ja.png", image2: "guide3-2.png", view: base)
        }
        base.addSubview(vcc.view)
        button.layer.borderColor = UIColor.whiteColor().CGColor
    }
    var vcc:OnboardingViewController!
    func Guide(title:String,body1:String,body2:String,image1:String,image2:String,view:UIView){
        let content1 = OnboardingContentViewController(
            title: title,
            body: body1,
            image: UIImage(named: image1),
            buttonText: "",
            action: nil
        )
        content1.bodyFontSize = 16
        let content2 = OnboardingContentViewController(
            title: title,
            body: body2,
            image: UIImage(named: image2),
            buttonText: "",
            action: nil
        )
        content2.bodyFontSize = 16
        let contentArray = [content1, content2]
        for (var i=0; i<2; i++){
            contentArray[i].iconHeight = (view.bounds.height)*0.5
            contentArray[i].iconWidth = (view.bounds.width)
            contentArray[i].titleFontSize = 18
            contentArray[i].bodyFontSize = 15
            contentArray[i].topPadding =  0
            contentArray[i].underIconPadding = 0
            contentArray[i].underTitlePadding = 30
            contentArray[i].bottomPadding = 0
            contentArray[i].titleTextColor = imageColor
            contentArray[i].bodyTextColor = UIColor.blackColor()
            contentArray[i].buttonTextColor = imageColor
        }
        vcc = OnboardingViewController(
            backgroundImage: nil,
            contents: [content1, content2]
        )
        vcc.allowSkipping = true
        vcc.shouldMaskBackground = false
        vcc.view.backgroundColor = UIColor.whiteColor()
        vcc.view.contentMode = UIViewContentMode.ScaleAspectFit
        vcc.view.frame = CGRectMake(0, 0, view.bounds.width, view.bounds.height-60)
        vcc.skipButton.setTitle("Skip", forState: .Normal)
        vcc.skipButton.setTitleColor(imageColor, forState: .Normal)
        vcc.skipButton.frame = CGRectMake(view.bounds.width-80 ,view.bounds.height-40, 40, 40)
        vcc.pageControl.pageIndicatorTintColor = UIColor.grayColor()
        vcc.pageControl.currentPageIndicatorTintColor = imageColor
        vcc.pageControl.frame = CGRectMake(0, view.bounds.height-40, view.bounds.width, 40)
    }
    
    //skipHandler用のaleart
    func skipAlert(){
        UIAlertController.appearance().tintColor = imageColor
        alertController = UIAlertController(title: "", message: SKIP_ALERT, preferredStyle: .Alert)
        let action = UIAlertAction(title: SKIP, style: .Default,handler:{ (action:UIAlertAction!) -> Void in
            self.base.removeFromSuperview()
        })
        let cancelAction = UIAlertAction(title: CANCEL, style: .Default,handler:{ (action:UIAlertAction!) -> Void in
        })
        alertController.addAction(action)
        alertController.addAction(cancelAction)
    }
    //
    
    
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
        alertController = UIAlertController(title: alertTitle, message: "", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }
}
