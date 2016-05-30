import UIKit
import Parse
import Alamofire
import SwiftyJSON

class CheckViewController: UIViewController {
    
    var Flag = ""
    var Register = RegistrarionViewController()
    var base:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        setTopView()
        setCheckTableView()
        forCheckView = ""
    }
    
    //TopView生成
    func setTopView(){
        if forCheckView == "fromRegistrarion"{
        setButton(80, frameY: 80, layerX: self.view.bounds.width*(1/4), layerY: 50, text: REDO, fontSize:12, imageName: "redo.png", imageEdgeTop: 0, imageEdgeLeft: 20,titleEdgeTop:55,titleEdgeLeft: -30, cornerRadius: 10,target: self, action: "Back:", tag:5, view: self.view)
        setButton(90, frameY: 80, layerX: self.view.bounds.width*(2/4), layerY: 50, text: REGISTRATION_ITEM2, fontSize:11, imageName: "register.png", imageEdgeTop: 0, imageEdgeLeft: 30,titleEdgeTop:55,titleEdgeLeft: -20, cornerRadius: 10,target: self, action: "Registration", tag:5, view: self.view)
        setButton(80, frameY: 80, layerX: self.view.bounds.width*(3/4), layerY: 50, text: TO_IMAGE_EDITING, fontSize:12, imageName: "edit.png", imageEdgeTop: 0, imageEdgeLeft: 15,titleEdgeTop:55,titleEdgeLeft: -25, cornerRadius: 10,target: self, action: "nextView", tag:5, view: self.view)
        }else if forCheckView == "fromMyCloset"{
        setButton(80, frameY: 80, layerX: self.view.bounds.width*(1/2), layerY: 50, text: BACK, fontSize:12, imageName: "back.png", imageEdgeTop: 0, imageEdgeLeft: 20,titleEdgeTop:55,titleEdgeLeft: -30, cornerRadius: 10,target: self, action: "Back:", tag:6, view: self.view)
        }
    }
    
    //CheckTableView生成
    func setCheckTableView(){
        let Y:CGFloat = 100
        if (forCheckContent[0] == "TotalCoordinate"){
        let tempView = UIImageView()
        tempView.frame = CGRectMake(0, Y, self.view.bounds.width, self.view.bounds.height - Y)
        tempView.contentMode = UIViewContentMode.ScaleAspectFit
        tempView.image = globalImage
        self.view.addSubview(tempView)
        }else{
        let frame = CGRectMake(5, Y, self.view.frame.width-10, self.view.frame.height - Y)
        let checktableview = CheckTableView(frame: frame, style: UITableViewStyle.Plain)
        checktableview.Image = globalImage
        checktableview.Title = clothTagTitle
        if forCheckView == "fromRegistrarion"{
            for(var i=0; i<4; i++){
                clothTagDescript[i] = Recognized[i]["tag"]!
            }
        }else if forCheckView == "fromMyCloset"{
            for(var i=0; i<4; i++){
                clothTagDescript[i] = forCheckContent[i]
            }
        }
        checktableview.Descript = clothTagDescript
        self.view.addSubview(checktableview)
        }
    }
    
    //画面遷移系
    func Back(sender:UIButton){
        if sender.tag == 6{
            tabBarSet = "MyCloset"
        }
        RegistrarionViewFlag = "Reload"
        self.presentingViewController!.dismissViewControllerAnimated(false, completion: nil)
    }
    func nextView(){
        if PFUser.currentUser() == nil {
            consent2()
        }else{
        forReEditFlag = ""
        RegistrarionViewFlag = "Reload"
        performSegueWithIdentifier("ShowToEditor", sender: nil)
        }
    }
    func execution(){
        performSegueWithIdentifier("ModalLoginViewController", sender: self)
    }
    //
    
    //アイテム登録
    func Registration(){
        if PFUser.currentUser() == nil {
            consent()
        }else{
            let image = UIImagePNGRepresentation(RecognitionImage)!
            let Item = PFFile(name: "Item", data: image)
            let tagmanager = TagManager(Item: Item!, StyleTag: Recognized[0]["tag"]!, TypeTag: Recognized[1]["tag"]!,  ColorTag: Recognized[2]["tag"]!, PatternTag: Recognized[3]["tag"]!, Category:Recognized[4]["Category"]!)
            tagmanager.save()
            alert(REGISTRATION_SUCCESS)
        }
    }
    
    //ユーザー登録/ログインの確認
    func consent() {
        UIAlertController.appearance().tintColor = imageColor
        let alertController = UIAlertController(title: IF_YOU_USE_THE_ITEM_REGISTRATION_PLEASE_DO_USER_LOGIN, message: "", preferredStyle: .Alert)
        let signUpAction = UIAlertAction(title: USER_REGISTER_LOGIN, style: .Default,
            handler:{ (action:UIAlertAction!) -> Void in
                self.execution()
        })
        let cancelAction = UIAlertAction(title: CANCEL, style: .Default,
            handler:{ (action:UIAlertAction!) -> Void in
        })
        alertController.addAction(signUpAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    func consent2() {
        UIAlertController.appearance().tintColor = imageColor
        let alertController = UIAlertController(title: CONSENT2TITLE, message: "", preferredStyle: .Alert)
        let signUpAction = UIAlertAction(title: "OK", style: .Default,
            handler:{ (action:UIAlertAction!) -> Void in
                self.execution()
        })
        let cancelAction = UIAlertAction(title: CANCEL, style: .Default,
            handler:{ (action:UIAlertAction!) -> Void in
        })
        alertController.addAction(signUpAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    //
    
    //Alert
    func alert(title:String) {
        UIAlertController.appearance().tintColor = imageColor
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }

    //skipHandler用のaleart
    func skipAlert(){
        UIAlertController.appearance().tintColor = imageColor
        let alertController = UIAlertController(title: "", message: SKIP_ALERT, preferredStyle: .Alert)
        let action = UIAlertAction(title: SKIP, style: .Default,handler:{ (action:UIAlertAction!) -> Void in
            self.base.removeFromSuperview()
            forReEditFlag = ""
            RegistrarionViewFlag = "Reload"
            self.performSegueWithIdentifier("ShowToEditor", sender: nil)
        })
        let cancelAction = UIAlertAction(title: CANCEL, style: .Default,handler:{ (action:UIAlertAction!) -> Void in
        })
        alertController.addAction(action)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    //
    
    //縦画面固定
    override func shouldAutorotate() -> Bool{
        return false
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    //
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}