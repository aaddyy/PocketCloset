import UIKit
import Parse

class TotalViewController: UIViewController{
    // 画像インスタンス
    var imageItem:UIImageView!
    var currentTransForm: CGAffineTransform!
    var totalView:UIView!
    var imageItems:Array<UIImageView> = []
    var touchTag:Int!
    var Pinch:UIPinchGestureRecognizer!
    var tempFloat:CGFloat = 100
    var Touch:UITouch!
    var subtractionFlag = 0
    var tempImageView:UIImageView!
    var tempImageViews:Array<UIImageView> = []
    var tempImageViews2:Array<UIImageView> = []
    var tempImageViews3:Array<UIImageView> = []
    var subtractionView:UIView!
    var subtractionArray:Array<Int> = []
    var temp2:UIView!
    var base:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() == nil {
            self.loadView()
            consent()
        }else{
        imageItems = []
        setTopView()
        setTotalView()
        }
    }
    override func viewWillDisappear(animated: Bool) {
        self.loadView()
    }
    //TopView生成
    func setTopView(){
        setButton(90, frameY: 80, layerX: self.view.bounds.width*(1/4), layerY: 50, text: EDITCLEAR2, fontSize:10, imageName: "clear.png", imageEdgeTop: 0, imageEdgeLeft: 28,titleEdgeTop:55,titleEdgeLeft: -25, cornerRadius: 10,target: self, action: "itemClear", tag:5, view: self.view)
        setButton(90, frameY: 80, layerX: self.view.bounds.width*(2/4), layerY: 50, text: REGISTRATION_ITEM3, fontSize:10, imageName: "plus.png", imageEdgeTop: 0, imageEdgeLeft: 28,titleEdgeTop:55,titleEdgeLeft: -20, cornerRadius: 10,target: self, action: "toMyCloset", tag:5, view: self.view)
        setButton(90, frameY: 80, layerX: self.view.bounds.width*(3/4), layerY: 50, text: REGISTRATION_ITEM4, fontSize:10, imageName: "register.png", imageEdgeTop: 0, imageEdgeLeft: 30,titleEdgeTop:55,titleEdgeLeft: -25, cornerRadius: 10,target: self, action: "RegistrationCode", tag:5, view: self.view)
        setButton(50, frameY: 60, layerX: self.view.frame.width*(9/10), layerY: 30, text: HELP, fontSize: 8, imageName: "help.png", imageEdgeTop: 0, imageEdgeLeft: 2, titleEdgeTop: 40, titleEdgeLeft: -33, cornerRadius: 0, target: self, action: "localGuide", tag: 100, view: self.view)
        iconButtons[5].tintColor = UIColor.grayColor()
        iconButtons[5].setTitleColor(UIColor.grayColor(), forState: .Normal)
        iconButtons[5].setTitleColor(imageColor, forState: .Selected)
    }
    //トータルコーデの検討エリア
    func setTotalView(){
        totalView = UIView()
        totalView.frame = CGRectMake(0, tempFloat, self.view.bounds.width, self.view.bounds.height-tempFloat)
        totalView.backgroundColor = UIColor.whiteColor()
        totalView.layer.borderColor = imageColor.CGColor
        totalView.layer.borderWidth = 4
        totalView.layer.shadowColor = UIColor.grayColor().CGColor
        totalView.layer.shadowOpacity = 1
        totalView.layer.shadowOffset = CGSizeMake(3, 3)
        self.view.addSubview(totalView)
        
        if TotalCodeArray != []{
            let temp = TotalCodeArray.count
            var tempPoint:CGFloat! = 8
            var tempY = tempFloat + 8
            var j:CGFloat = 2
            for (var i=0; i<temp; i++){
                imageItem = UIImageView()
                imageItem.contentMode = UIViewContentMode.ScaleAspectFit
                imageItem.image = TotalCodeArray[i]
                imageItem.frame = CGRectMake(tempPoint, tempY, 100, 100)
                imageItem.backgroundColor = UIColor.clearColor()
                if (tempPoint+100 > totalView.bounds.width - 8){
                tempPoint = 0
                tempY = tempFloat * j
                j++
                }else{
                tempPoint = tempPoint + totalView.bounds.width/5
                }
                Pinch = UIPinchGestureRecognizer()
                Pinch.addTarget(self, action:"pinchAction:")
                imageItem.addGestureRecognizer(Pinch)
                imageItem.tag = i
                self.view.addSubview(imageItem)
                imageItem.userInteractionEnabled = true
                imageItems.append(imageItem)
            }
        }
    }
    func removeGuide(){
        top.removeFromSuperview()
        middle.removeFromSuperview()
        backGround.removeFromSuperview()
        guideButton.removeFromSuperview()
    }
    //
    //画面遷移系
    func toMyCloset(){
        TotalCodeFlag = 1
        performSegueWithIdentifier("toMyCloset", sender: self)
    }
    func execution(){
        performSegueWithIdentifier("ModalLoginViewController", sender: self)
    }
    //
    //タッチイベント(画像の移動)
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (touches.first!.view != totalView)&&(touches.first!.view != self.view)&&(touches.first!.view != subtractionView)&&(touches.first!.view != temp2){
        Touch = touches.first!
        touchTag = Touch.view?.tag
            if(subtractionFlag == 1){
                var tempWidth = Int((Touch.view?.layer.borderWidth)!)
                switch tempWidth{
                case 0:
                    Touch.view?.layer.borderColor = imageColor.CGColor
                    Touch.view?.layer.borderWidth = 3
                    Touch.view?.layer.cornerRadius = 5
                case 3:
                    Touch.view?.layer.borderColor = UIColor.whiteColor().CGColor
                    Touch.view?.layer.borderWidth = 0
                default: break
                }
            }
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if subtractionFlag == 0{
        if (touches.first!.view != totalView)&&(touches.first!.view != self.view){
            let preDx = Touch.previousLocationInView(totalView).x
            let preDy = Touch.previousLocationInView(totalView).y
            // ドラッグ後の座標
            let newDx = Touch.locationInView(totalView).x
            let newDy = Touch.locationInView(totalView).y
        // ドラッグしたx座標の移動距離
        let dx = newDx - preDx
        // ドラッグしたy座標の移動距離
        let dy = newDy - preDy
        // 画像のフレーム
        var viewFrame: CGRect = imageItems[touchTag!].frame
        // 移動分を反映させる
        if (newDx > imageItems[touchTag!].frame.width/3)&&(newDx < (totalView.bounds.width - imageItems[touchTag!].frame.width/3)){
        viewFrame.origin.x += dx
        }
        if (newDy > imageItems[touchTag!].frame.height/3)&&(newDy < (totalView.bounds.height - imageItems[touchTag!].frame.height/3)){
        viewFrame.origin.y += dy
        }
        imageItems[touchTag!].frame = viewFrame
        }
    }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    //ピンチジェスチャー(画像サイズの変更)
    func pinchAction(gesture: UIPinchGestureRecognizer){
    if Touch.view != totalView {
        if (gesture.state == UIGestureRecognizerState.Began) {
            currentTransForm = imageItems[touchTag!].transform
        }
        let scale = gesture.scale
        imageItems[touchTag!].transform = CGAffineTransformConcat(currentTransForm, CGAffineTransformMakeScale(scale, scale))
    }
    }
    //
    
//トータルコーデ用登録機能
    //アイテム登録
    func RegistrationCode(){
        if PFUser.currentUser() == nil {
            consent()
        }else{
            Registration()
            alertMessage = REGISTRATION_SUCCESS2
            AlertMessage()
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    func Registration(){
        totalView.layer.borderColor = UIColor.clearColor().CGColor
        totalView.layer.borderWidth = 0
        Recognized[0]["tag"] = "TotalCoordinate"
        Recognized[1]["tag"] = "TotalCoordinate"
        Recognized[2]["tag"] = "TotalCoordinate"
        Recognized[3]["tag"] = "TotalCoordinate"
        Recognized.insert(["Category":TOTALCODE], atIndex: 4)
        UIGraphicsBeginImageContextWithOptions(totalView.frame.size, true, 0)
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextTranslateCTM(context, 0, 0)
        totalView.layer.renderInContext(context)
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let image = UIImagePNGRepresentation(newImage)
        let Item = PFFile(name: "Item", data: image!)
        let tagmanager = TagManager(Item: Item!, StyleTag: Recognized[0]["tag"]!, TypeTag: Recognized[1]["tag"]!,  ColorTag: Recognized[2]["tag"]!, PatternTag: Recognized[3]["tag"]!, Category:Recognized[4]["Category"]!)
        tagmanager.save()
        totalView.layer.borderColor = imageColor.CGColor
        totalView.layer.borderWidth = 4
    }
    //アイテムクリア
    func itemClear() {
        UIAlertController.appearance().tintColor = imageColor
        let alertController = UIAlertController(title: CONFIRM_CLEAR, message: "", preferredStyle: .Alert)
        let clearAction = UIAlertAction(title: CLEAR, style: .Default,
            handler:{ (action:UIAlertAction!) -> Void in
                self.subtraction()
        })
        let allclearAction = UIAlertAction(title: ALLCLEAR, style: .Default,
            handler:{ (action:UIAlertAction!) -> Void in
                let temp = TotalCodeArray.count
                for (var i=0; i<temp; i++){
                    self.imageItems[i].removeFromSuperview()
                }
                TotalCodeArray = []
        })
        let cancelAction = UIAlertAction(title: CANCEL, style: .Default,
            handler:{ (action:UIAlertAction!) -> Void in
        })
        alertController.addAction(clearAction)
        alertController.addAction(allclearAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    //アイテム削除
    func subtraction(){
        subtractionFlag = 1
        tempImageViews = []
        subtractionArray = []
        subtractionView = UIView()
        subtractionView.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
        subtractionView.backgroundColor = UIColor.grayColor()
        self.view.addSubview(subtractionView)
        setLabel(self.view.bounds.width*(2/3), frameY: 50, tag: 0, text: SELECT_CLEARITEM, fontSize: 16, layerX: self.view.bounds.width*(1/2), layerY: self.view.bounds.height*(1/6), view: subtractionView)
        temp2 = UIView()
        temp2.frame = CGRectMake(0, self.view.bounds.height*(1/5), self.view.bounds.width, self.view.bounds.height*(2/3))
        temp2.backgroundColor = UIColor.whiteColor()
        subtractionView.addSubview(temp2)
        var count = TotalCodeArray.count
        var tempX:CGFloat = 8
        var tempY:CGFloat = 8
        var tempNumber:CGFloat = 0
        for (var i=0; i<count; i++){
            tempImageView = UIImageView()
            tempImageView.contentMode = UIViewContentMode.ScaleAspectFit
            tempImageView.frame = CGRectMake(tempX, tempY, 100, 100)
            tempImageView.image = TotalCodeArray[i]
            tempImageView.userInteractionEnabled = true
            tempImageView.layer.borderWidth = 0
            tempImageView.tag = i
            temp2.addSubview(tempImageView)
            tempImageViews.append(tempImageView)
            tempNumber++
            tempX = tempX + 100*tempNumber + 5
            if(tempX > (self.view.bounds.width - 105)) {
                tempX = 8
                tempY = tempY + 108
            }
        }
        setButton(100, frameY: 40, layerX: self.view.bounds.width*(1/3), layerY: self.view.bounds.height*(11/12), text: CLEAR, fontSize: 15, imageName: "1.jpg", imageEdgeTop: 0, imageEdgeLeft: 0, titleEdgeTop: 0, titleEdgeLeft: 0, cornerRadius: 5, target: self, action: "subtractionAction", tag: 0, view: subtractionView)
        setButton(100, frameY: 40, layerX: self.view.bounds.width*(2/3), layerY: self.view.bounds.height*(11/12), text: CANCEL, fontSize: 15, imageName: "1.jpg", imageEdgeTop: 0, imageEdgeLeft: 0, titleEdgeTop: 0, titleEdgeLeft: 0, cornerRadius: 5, target: self, action: "subtractionCancel", tag: 0, view: subtractionView)
    }
    func subtractionAction(){
        var count = tempImageViews.count
        for(var i=0; i<count; i++){
            if tempImageViews[i].layer.borderWidth == 0{
                subtractionArray.append(i)
            }
        }
        if count == subtractionArray.count{
            alertTitle = WARNINGADD
            AlertTitle()
            presentViewController(alertController, animated: true, completion: nil)
        }else{
            var tempcount = subtractionArray.count
            TotalCodeArray = []
            for(var j=0; j<tempcount; j++){
            TotalCodeArray.append(tempImageViews[subtractionArray[j]].image!)
            }
            subtractionView.removeFromSuperview()
            subtractionFlag = 0
            self.loadView()
            self.viewDidAppear(false)
        }
    }
    func subtractionCancel(){
        subtractionView.removeFromSuperview()
        subtractionFlag = 0
    }
    //
    
    //Guide用
    func localGuide(){        
        base = UIView()
        base.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
        base.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(base)
        if TOPS == "Tops"{
        Guide(GUIDE04, body1: GUIDE05, body2: GUIDE06, image1: "guide2-1en.png", image2: "guide2-2.png", view: base)
        }else{
        Guide(GUIDE04, body1: GUIDE05, body2: GUIDE06, image1: "guide2-1ja.png", image2: "guide2-2.png", view: base)
        }
        base.addSubview(vc.view)
        setButton(70, frameY: 40, layerX: self.view.bounds.width-60, layerY: self.view.bounds.height-20, text: SKIP, fontSize: 14, imageName: "1.jpg", imageEdgeTop: 0, imageEdgeLeft: 0, titleEdgeTop: 0, titleEdgeLeft: 0, cornerRadius: 5, target: self, action: "skipAlert", tag: 99, view: base)
        button.layer.borderColor = UIColor.whiteColor().CGColor
        }
    //skipHandler用のaleart
    func skipAlert(){
        UIAlertController.appearance().tintColor = imageColor
        let alertController = UIAlertController(title: "", message: SKIP_ALERT, preferredStyle: .Alert)
        let action = UIAlertAction(title: SKIP, style: .Default,handler:{ (action:UIAlertAction!) -> Void in
            self.base.removeFromSuperview()
        })
        let cancelAction = UIAlertAction(title: CANCEL, style: .Default,handler:{ (action:UIAlertAction!) -> Void in
        })
        alertController.addAction(action)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    //
    
    
    //ユーザー登録の確認
    func consent() {
        UIAlertController.appearance().tintColor = imageColor
        let alertController = UIAlertController(title: IF_YOU_USE_TOTALCODE_PLEASE_DO_USER_LOGIN, message: "", preferredStyle: .Alert)
        let signUpAction = UIAlertAction(title: USER_REGISTER_LOGIN, style: .Default,
            handler:{ (action:UIAlertAction!) -> Void in
                self.execution()
        })
        let cancelAction = UIAlertAction(title: CANCEL, style: .Default,
            handler:{ (action:UIAlertAction!) -> Void in
                var tempTab = TabBarController()
                tempTab.viewWillAppear(false)
        })
        alertController.addAction(signUpAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    //
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
