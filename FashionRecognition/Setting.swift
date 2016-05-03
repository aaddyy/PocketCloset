import UIKit
import Parse
import AVFoundation
import Alamofire
import SwiftyJSON
import Onboard

    //基本の変数
    var RegistrarionViewFlag = "Reload"
    var imageColor = UIColor(red: 240/255, green: 150/255, blue: 155/255, alpha: 1.0)
    var imageFlag = ""
    var globalImage: UIImage!
    var forCheckView = ""
    var forCheckContent = [""]
    var globalIndexPath:NSIndexPath!
    var globalIndexPathRow:Int!
    var globalStyleTag:String!
    var globalTypeTag:String!
    var globalColorTag:String!
    var globalPatternTag:String!
    var forReEditFlag:String!
    var keyFlag = 0
    var fromFlag: String!
    var TotalCodeFlag = 0
    var TotalCodeArray:Array<UIImage> = []

    //Localize関連の変数
    var STYLE = NSLocalizedString("STYLE", comment:"" )
    var TYPE = NSLocalizedString("TYPE", comment:"" )
    var COLOR = NSLocalizedString("COLOR", comment:"" )
    var PATTERN = NSLocalizedString("PATTERN", comment:"" )
    var JACKET = NSLocalizedString("JACKET", comment:"" )
    var SHIRT = NSLocalizedString("SHIRT", comment:"" )
    var COAT = NSLocalizedString("COAT", comment:"" )
    var SWEAT = NSLocalizedString("SWEAT", comment:"" )
    var ONEPIECE_DRESS = NSLocalizedString("ONEPIECE_DRESS", comment:"" )
    var CARDIGAN = NSLocalizedString("CARDIGAN", comment:"" )
    var TOPS = NSLocalizedString("TOPS", comment:"" )
    var SKIRT = NSLocalizedString("SKIRT", comment:"" )
    var SLACKS = NSLocalizedString("SLACKS", comment:"" )
    var PANTS1 = NSLocalizedString("PANTS1", comment:"" )
    var PANTS2 = NSLocalizedString("PANTS2", comment:"" )
    var DENIM = NSLocalizedString("DENIM", comment:"" )
    var BOTTOMS = NSLocalizedString("BOTTOMS", comment:"" )
    var SHOES1 = NSLocalizedString("SHOES1", comment:"" )
    var SHOES2 = NSLocalizedString("SHOES2", comment:"" )
    var PUMPS = NSLocalizedString("PUMPS", comment:"" )
    var SHOES = NSLocalizedString("SHOES", comment:"" )
    var BAG = NSLocalizedString("BAG", comment:"" )
    var MISCELLANEOUS_GOODS = NSLocalizedString("MISCELLANEOUS_GOODS", comment:"" )
    var USER_REGISTER_LOGIN = NSLocalizedString("USER_REGISTER_LOGIN", comment:"" )
    var USER_n_REGISTER = NSLocalizedString("USER_n_REGISTER", comment:"" )
    var LOGIN = NSLocalizedString("LOGIN", comment:"" )
    var CANCEL = NSLocalizedString("CANCEL", comment:"" )
    var IS_ALREADY_REGISTERED = NSLocalizedString("IS_ALREADY_REGISTERED", comment:"" )
    var Username_and_Password_are_required_input = NSLocalizedString("Username_and_Password_are_required_input", comment:"" )
    var REGISTRATION_SUCCESS = NSLocalizedString("REGISTRATION_SUCCESS", comment:"" )
    var Username_or_Password_is_invailid = NSLocalizedString("Username_or_Password_is_invailid", comment:"" )
    var LOGIN_SUCCESS = NSLocalizedString("LOGIN_SUCCESS", comment:"" )
    var ERROR = NSLocalizedString("ERROR", comment:"" )
    var LETS_REGISTER = NSLocalizedString("LETS_REGISTER", comment:"" )
    var BY_CAMERA = NSLocalizedString("BY_CAMERA", comment:"" )
    var FROM_ALBUM = NSLocalizedString("FROM_ALBUM", comment:"" )
    var ANALYZE = NSLocalizedString("ANALYZE", comment:"" )
    var ANALYZING_ITEM = NSLocalizedString("ANALYZING_ITEM", comment:"" )
    var REDO = NSLocalizedString("REDO", comment:"" )
    var BACK_TO_THE_BIGGINING = NSLocalizedString("BACK_TO_THE_BIGGINING", comment:"" )
    var TO_IMAGE_EDITING = NSLocalizedString("TO_IMAGE_EDITING", comment:"" )
    var BACK = NSLocalizedString("BACK", comment:"" )
    var IF_YOU_USE_THE_ITEM_REGISTRATION_PLEASE_DO_USER_LOGIN = NSLocalizedString("IF_YOU_USE_THE_ITEM_REGISTRATION_PLEASE_DO_USER_LOGIN", comment:"" )
    var s_CLOSET = NSLocalizedString("s_CLOSET", comment:"" )
    var LOGOUT = NSLocalizedString("LOGOUT", comment:"" )
    var BY_TAPPING_THE_ITEM_SHOW_DETAIL_INFORMATION_n_BY_LONGPRESSING_THE_ITEM_GO_TO_EDIT_MODE = NSLocalizedString("BY_TAPPING_THE_ITEM_SHOW_DETAIL_INFORMATION_n_BY_LONGPRESSING_THE_ITEM_GO_TO_EDIT_MODE", comment:"" )
    var EDIT_SELECTED_ITEM = NSLocalizedString("EDIT_SELECTED_ITEM", comment:"" )
    var EDIT_THE_ITEM_TAGS = NSLocalizedString("EDIT_THE_ITEM_TAGS", comment:"" )
    var DELETE_ITEM = NSLocalizedString("DELETE_ITEM", comment:"" )
    var INPUTTING_ALL_TAGS_IS_REQUIRED = NSLocalizedString("INPUTTING_ALL_TAGS_IS_REQUIRED", comment:"" )
    var EDITTING_SUCCESS = NSLocalizedString("EDITTING_SUCCESS", comment:"" )
    var IF_YOU_USE_MY_CLOSET_PLEASE_DO_USER_LOGIN = NSLocalizedString("IF_YOU_USE_MY_CLOSET_PLEASE_DO_USER_LOGIN", comment:"" )
    var YOU_WANT_TO_LOGOUT = NSLocalizedString("YOU_WANT_TO_LOGOUT", comment:"" )
    var YOUR_ACCOUNT_INFORMATION_n_Username： = NSLocalizedString("YOUR_ACCOUNT_INFORMATION_n_Username：", comment:"" )
    var SELECT_ITEM_AREA = NSLocalizedString("SELECT_ITEM_AREA", comment:"" )
    var SHOW_EDITED_ITEM = NSLocalizedString("SHOW_EDITED_ITEM", comment:"" )
    var REGISTRATION_ITEM = NSLocalizedString("REGISTRATION_ITEM", comment:"" )
    var REGISTRATION_ITEM2 = NSLocalizedString("REGISTRATION_ITEM2", comment:"" )
    var EDIT_ITEMIMAGE = NSLocalizedString("EDIT_ITEMIMAGE", comment:"" )
    var CONSENT2TITLE = NSLocalizedString("CONSENT2TITLE", comment:"" )
    var RESELECT = NSLocalizedString("RESELECT", comment:"" )
    var BUTTON_TITLE_HIDE_RESULTS = NSLocalizedString("BUTTON_TITLE_HIDE_RESULTS", comment:"" )
    var EDITCLEAR = NSLocalizedString("EDITCLEAR", comment:"" )
    var PREPARE_EDIT = NSLocalizedString("PREPARE_EDIT", comment:"" )
    var EDIT_WAY = NSLocalizedString("EDIT_WAY", comment:"" )
    var TOMYCLOSET = NSLocalizedString("TOMYCLOSET", comment:"" )
    var ITEMTOUCH = NSLocalizedString("ITEMTOUCH", comment:"" )
    var ERASER = NSLocalizedString("ERASER", comment:"" )
    var REGISTRATION_ITEM3 = NSLocalizedString("REGISTRATION_ITEM3", comment:"" )
    var ADDCONSENT = NSLocalizedString("ADDCONSENT", comment:"" )
    var WARNINGADD = NSLocalizedString("WARNINGADD", comment:"" )
    var EDITCLEAR2 = NSLocalizedString("EDITCLEAR2", comment:"" )
    var TOTALCODE = NSLocalizedString("TOTALCODE", comment:"" )
    var REGISTRATION_SUCCESS2 = NSLocalizedString("REGISTRATION_SUCCESS2", comment:"" )
    var REGISTRATION_ITEM4 = NSLocalizedString("REGISTRATION_ITEM4", comment:"" )
    var ALLCLEAR = NSLocalizedString("ALLCLEAR", comment:"" )
    var CONFIRM_CLEAR = NSLocalizedString("CONFIRM_CLEAR", comment:"" )
    var CLEAR = NSLocalizedString("CLEAR", comment:"" )
    var SELECT_CLEARITEM = NSLocalizedString("SELECT_CLEARITEM", comment:"" )
    var CLEAR_SUCCESS =  NSLocalizedString("CLEAR_SUCCESS", comment:"" )
    var SKIP_ALERT =  NSLocalizedString("SKIP_ALERT", comment:"" )
    var SKIP =  NSLocalizedString("SKIP", comment:"" )
    var SKIP_FLAG =  NSLocalizedString("SKIP_FLAG", comment:"" )
    var GUIDE01 =  NSLocalizedString("GUIDE01", comment:"" )
    var GUIDE02 =  NSLocalizedString("GUIDE02", comment:"" )
    var GUIDE03 =  NSLocalizedString("GUIDE03", comment:"" )
    var GUIDE04 =  NSLocalizedString("GUIDE04", comment:"" )
    var GUIDE05 =  NSLocalizedString("GUIDE05", comment:"" )
    var GUIDE06 =  NSLocalizedString("GUIDE06", comment:"" )
    var GUIDE07 =  NSLocalizedString("GUIDE07", comment:"" )
    var GUIDE08 =  NSLocalizedString("GUIDE08", comment:"" )
    var GUIDE09 =  NSLocalizedString("GUIDE09", comment:"" )
    var HELP =  NSLocalizedString("HELP", comment:"" )

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
    var labelFlag = ""
    func setLabel(frameX:CGFloat,frameY:CGFloat, tag:Int, text:String, fontSize: CGFloat, layerX: CGFloat, layerY: CGFloat,view:UIView){
    let label = UILabel()
        label.frame = CGRectMake(0, 0, frameX, frameY)
        label.backgroundColor = UIColor.clearColor()
        label.layer.masksToBounds = true
        label.tag = tag
        label.text = text
        label.textColor = imageColor
        label.font = UIFont(name: "HiraKakuProN-W3", size: fontSize)
        label.textAlignment = NSTextAlignment.Center
        label.layer.position = CGPoint(x: layerX, y: layerY)
        label.layer.borderColor = UIColor.whiteColor().CGColor
        label.numberOfLines = 3
        if labelFlag == "SettingView"{
        label.layer.borderColor = imageColor.CGColor
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 5.0
        }
        labelFlag = ""
        view.addSubview(label)
    }
    var textFields:Array<UITextField> = []
    func setTextField(frameX:CGFloat,frameY:CGFloat, tag:Int, text:String,placeholder:String, fontSize: CGFloat, layerX: CGFloat, layerY: CGFloat,view:UIView){
        let textField = UITextField()
        textField.frame = CGRectMake(0, 0, frameX, frameY)
        textField.backgroundColor = UIColor.clearColor()
        textField.layer.masksToBounds = true
        textField.tag = tag
        textField.text = text
        textField.placeholder = placeholder
        textField.textColor = imageColor
        textField.tintColor = imageColor
        textField.font = UIFont(name: "HiraKakuProN-W3", size: fontSize)
        textField.layer.position = CGPoint(x: layerX, y: layerY)
        textField.layer.borderColor = UIColor.grayColor().CGColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 5.0
        view.addSubview(textField)
        textFields.append(textField)
    }
    //setButton
    var iconButtons:Array<UIButton> = []
    var button:UIButton!
    func setButton(frameX:CGFloat, frameY:CGFloat, layerX:CGFloat, layerY:CGFloat, text: String,fontSize:CGFloat, imageName:String,imageEdgeTop: CGFloat, imageEdgeLeft:CGFloat,  titleEdgeTop: CGFloat, titleEdgeLeft:CGFloat, cornerRadius:CGFloat, target:AnyObject, action: Selector, tag: Int, view: UIView ){
            button = UIButton()
            button.frame = CGRectMake(0,0,frameX,frameY)
            button.backgroundColor = UIColor.whiteColor()
            button.layer.masksToBounds = true
            button.setTitle(text, forState: .Normal)
            button.setTitleColor(imageColor, forState: .Normal)
            button.titleLabel!.font = UIFont(name: "HiraKakuProN-W3", size: fontSize)
            button.titleLabel?.numberOfLines = 2
        if imageName != "1.jpg"{
            let backImage = UIImage(named: imageName)!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            button.setImage(backImage, forState: .Normal)
            button.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeTop, imageEdgeLeft, 0, 0)
            button.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeTop, titleEdgeLeft, 0, 0)
            button.layer.borderColor = UIColor.whiteColor().CGColor
        }else{
            button.titleLabel?.textAlignment = NSTextAlignment.Center
            button.layer.borderColor = imageColor.CGColor
        }
            button.layer.cornerRadius = cornerRadius
            button.layer.position = CGPoint(x: layerX, y: layerY)
            button.layer.borderWidth = 2
            button.tintColor = imageColor
            button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
            button.tag = tag
            view.addSubview(button)
            iconButtons.append(button)
        }
    func setButton2(frameX:CGFloat, frameY:CGFloat, layerX:CGFloat, layerY:CGFloat, text: String,fontSize:CGFloat, imageName:String,imageEdgeTop: CGFloat, imageEdgeLeft:CGFloat,  titleEdgeTop: CGFloat, titleEdgeLeft:CGFloat, cornerRadius:CGFloat, target:AnyObject, action: Selector, tag: Int, view: UIView ){
        button = UIButton()
        button.frame = CGRectMake(0,0,frameX,frameY)
        button.backgroundColor = UIColor.whiteColor()
        button.layer.masksToBounds = true
        button.setTitle(text, forState: .Normal)
        button.setTitleColor(imageColor, forState: .Normal)
        button.titleLabel!.font = UIFont(name: "HiraKakuProN-W3", size: fontSize)
        button.titleLabel?.numberOfLines = 2
        if imageName != "1.jpg"{
            let backImage = UIImage(named: imageName)!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            button.setImage(backImage, forState: .Normal)
            button.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeTop, imageEdgeLeft, 0, 0)
            button.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeTop, titleEdgeLeft, 0, 0)
            button.layer.borderColor = UIColor.whiteColor().CGColor
        }else{
            button.titleLabel?.textAlignment = NSTextAlignment.Center
            button.layer.borderColor = imageColor.CGColor
        }
        button.layer.cornerRadius = cornerRadius
        button.layer.position = CGPoint(x: layerX, y: layerY)
        button.layer.borderWidth = 2
        button.tintColor = imageColor
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        button.tag = tag
        view.addSubview(button)
        iconButtons.append(button)
    }

 //画像解析
    //解析中画面
    //ActivityIndicator
    var analyzingView = UIView()
    var tempActivityIndicator = UIActivityIndicatorView()
    var tempLabel = UILabel()
    func analyzing(text:String,view:UIView){
        analyzingView.frame = CGRectMake(0, 0, view.bounds.width, view.bounds.height+100)
        analyzingView.backgroundColor = UIColor.whiteColor()
        view.addSubview(analyzingView)
        tempActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        tempActivityIndicator.frame = CGRectMake(0, 0, 100, 100)
        tempActivityIndicator.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        tempActivityIndicator.color = imageColor
        tempActivityIndicator.startAnimating()
        analyzingView.addSubview(tempActivityIndicator)
        //Label
        tempLabel.frame = CGRectMake(0, 0, 150, 50)
        tempLabel.backgroundColor = UIColor.whiteColor()
        tempLabel.text = text
        tempLabel.numberOfLines = 3
        tempLabel.textAlignment = NSTextAlignment.Center
        tempLabel.textColor = imageColor
        tempLabel.layer.position = CGPoint(x: view.bounds.width/2, y: view.bounds.height*(3/5))
        analyzingView.addSubview(tempLabel)
    }

    //解析
    var RecognitionImage: UIImage!
    var RecognitionName: String!
    var modelName = ["fashion_style", "fashion_type", "fashion_color", "fashion_pattern"]
    var Recognized: [[String:String]] = [[:],[:],[:],[:]]
    var forTranslate: [[String:String]] = [[:],[:],[:],[:]]
    var clothTagTitle = [STYLE,TYPE,COLOR,PATTERN]
    var clothTagDescript = ["","","",""]

    //画面遷移関連
    var showDetailFlag = ""
    var doUpdateFlag = ""

    var tabBarSet = ""
    var indexforDelete:Int!

    //説明表示画面
    var backGround:UIView!
    var middle:UIView!
    var top:UIImageView!
    var guideButton:UIButton!
    func Expression(view:UIView, guideImage:String){
        backGround = UIView()
        backGround.frame = CGRectMake(0, 0, view.frame.width, view.frame.height)
        backGround.backgroundColor = UIColor.grayColor()
        view.addSubview(backGround)
        middle = UIView()
        middle.frame = CGRectMake(0, view.frame.height*(1/7), view.frame.width, view.frame.height*(5/7))
        middle.backgroundColor = UIColor.whiteColor()
        view.addSubview(middle)
        top = UIImageView()
        top.frame = CGRectMake(0, view.frame.height*(1/5), view.frame.width, view.frame.height*(3/5))
        top.backgroundColor = UIColor.whiteColor()
        top.contentMode = UIViewContentMode.ScaleAspectFit
        top.image = UIImage(named: guideImage)
        view.addSubview(top)
        guideButton = UIButton()
        guideButton.frame = CGRectMake(view.frame.width*(1/2), view.frame.height*(7/8), view.frame.width*(1/8), view.frame.height*(1/12))
        guideButton.backgroundColor = UIColor.whiteColor()
        guideButton.layer.masksToBounds = true
        guideButton.setTitle("OK", forState: .Normal)
        guideButton.setTitleColor(imageColor, forState: .Normal)
        guideButton.titleLabel!.font = UIFont(name: "HiraKakuProN-W3", size: 15)
        guideButton.layer.borderColor = UIColor.whiteColor().CGColor
        guideButton.tintColor = imageColor
        guideButton.tag = 0
        view.addSubview(guideButton)
    }

    //各画面のウォークスルー
    var window: UIWindow?
    var CONTENT1 = NSLocalizedString("CONTENT1", comment:"" )
    var CONTENT2 = NSLocalizedString("CONTENT2", comment:"" )
    var vc:OnboardingViewController!
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
        vc = OnboardingViewController(
            backgroundImage: nil,
            contents: [content1, content2]
        )
        vc.allowSkipping = true
        vc.shouldMaskBackground = false
        vc.view.backgroundColor = UIColor.whiteColor()
        vc.view.contentMode = UIViewContentMode.ScaleAspectFit
        vc.view.frame = CGRectMake(0, 0, view.bounds.width, view.bounds.height-60)
        vc.skipButton.setTitle("Skip", forState: .Normal)
        vc.skipButton.setTitleColor(imageColor, forState: .Normal)
        vc.skipButton.frame = CGRectMake(view.bounds.width-80 ,view.bounds.height-40, 40, 40)
        vc.pageControl.pageIndicatorTintColor = UIColor.grayColor()
        vc.pageControl.currentPageIndicatorTintColor = imageColor
        vc.pageControl.frame = CGRectMake(0, view.bounds.height-40, view.bounds.width, 40)
    }

    //Myクローゼットの削除・更新
    var currentObjectId = ""
    func myclosetDelete(){
        let queryInfo = PFQuery(className: "TagManager")
        queryInfo.getObjectInBackgroundWithId(currentObjectId, block: { (object, error) -> Void in
            try! object?.delete()
        })
    }
    func myclosetUpdate(){
        let queryInfo = PFQuery(className: "TagManager")
        queryInfo.getObjectInBackgroundWithId(currentObjectId, block: { (object, error) -> Void in
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
    var alertMessage:String!
    var alertController: UIAlertController!
    func AlertTitle() {
    UIAlertController.appearance().tintColor = imageColor
    alertController = UIAlertController(title: alertTitle, message: "", preferredStyle: .Alert)
    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alertController.addAction(action)
    }
    func AlertMessage(){
    UIAlertController.appearance().tintColor = imageColor
    alertController = UIAlertController(title: "", message: alertMessage, preferredStyle: .Alert)
    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alertController.addAction(action)
    }
    func AlertMessage2(){
        UIAlertController.appearance().tintColor = imageColor
        alertController = UIAlertController(title: "", message: alertMessage, preferredStyle: .Alert)
    }

    //翻訳機能
    var willTranslate:String!
    var didTranslate:String!
    var didTranslateTimes = 0
    var accessToken: String!
    var parameter: [String:String]!
    func getToken_MSTranslator(){
        parameter =
            [
            "client_id": "for-ios-App_Translate",
            "client_secret": "j9xvx6l8Z83phmm+cBVEIFAuEoS0ezfSso74XFQCE9E=",
            "scope": "http://api.microsofttranslator.com",
            "grant_type": "client_credentials"
        ]
        Alamofire.request(.POST, "https://datamarket.accesscontrol.windows.net/v2/OAuth2-13/", parameters: parameter)
            .responseJSON{ response in
            guard let object = response.result.value else{
                return
            }
            let json = JSON(object)
            if json["access_token"] != nil{
                    accessToken = json["access_token"].string!
                }else{
            }
        }
    }



class Setting: NSObject {

}
