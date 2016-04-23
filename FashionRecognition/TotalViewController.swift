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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if TOPS == "Tops"{
//            Expression(self.view, guideImage: "guide2en.png")
//        }else{
//            Expression(self.view, guideImage: "guide2.png")
//        }
//        guideButton.addTarget(self, action: "removeGuide", forControlEvents: .TouchUpInside)
    }
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() == nil {
            self.loadView()
            consent()
        }else{
        print(TotalCodeArray.description)
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
        setButton(90, frameY: 80, layerX: self.view.bounds.width*(1/4), layerY: 50, text: EDITCLEAR2, fontSize:12, imageName: "clear.png", imageEdgeTop: 0, imageEdgeLeft: 28,titleEdgeTop:55,titleEdgeLeft: -25, cornerRadius: 10,target: self, action: "itemClear", tag:5, view: self.view)
        setButton(90, frameY: 80, layerX: self.view.bounds.width*(2/4), layerY: 50, text: REGISTRATION_ITEM3, fontSize:11, imageName: "plus.png", imageEdgeTop: 0, imageEdgeLeft: 28,titleEdgeTop:55,titleEdgeLeft: -20, cornerRadius: 10,target: self, action: "toMyCloset", tag:5, view: self.view)
        setButton(90, frameY: 80, layerX: self.view.bounds.width*(3/4), layerY: 50, text: REGISTRATION_ITEM4, fontSize:12, imageName: "register.png", imageEdgeTop: 0, imageEdgeLeft: 25,titleEdgeTop:55,titleEdgeLeft: -25, cornerRadius: 10,target: self, action: "RegistrationCode", tag:5, view: self.view)
    }
    //トータルコーデの検討エリア
    func setTotalView(){
        totalView = UIView()
        totalView.frame = CGRectMake(0, tempFloat, self.view.bounds.width, self.view.bounds.height-tempFloat)
        totalView.backgroundColor = UIColor.whiteColor()
        totalView.layer.borderColor = imageColor.CGColor
        totalView.layer.borderWidth = 4
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
        if (touches.first!.view != totalView)&&(touches.first!.view != self.view) {
        Touch = touches.first!
        touchTag = Touch.view?.tag
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // タッチイベントを取得
        // ドラッグ前の座標, Swift 1.2 から
        if (touches.first!.view != totalView)&&(touches.first!.view != self.view) {
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
            AlertMessage2()
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
//    //アイテム削除
    func subtraction(){
//        var temp = UIView()
//        temp.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
//        temp.backgroundColor = UIColor.grayColor()
//        temp.alpha = 0.6
//        self.view.addSubview(temp)
//        setLabel(self.view.bounds.width*(2/3), frameY: 80, tag: 0, text: SELECT_CLEARITEM, fontSize: 14, layerX: self.view.bounds.width*(1/2), layerY: self.view.bounds.height*(1/6), view: temp)
//        var temp2 = UIView()
//        temp2.frame = CGRectMake(0, self.view.bounds.height*(1/5), self.view.bounds.width, self.view.bounds.height*(2/3))
//        temp2.backgroundColor = UIColor.whiteColor()
//        temp.addSubview(temp2)
//        var count = TotalCodeArray.count
//        for (var i=0; i<count; i++){
//            
//        
//        }
//        
    }

    
    //ユーザー登録の確認
    func consent() {
        UIAlertController.appearance().tintColor = imageColor
        let alertController = UIAlertController(title: IF_YOU_USE_MY_CLOSET_PLEASE_DO_USER_LOGIN, message: "", preferredStyle: .Alert)
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
