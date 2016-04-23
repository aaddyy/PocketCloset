import UIKit
import Parse
import AVFoundation
import Alamofire
import SwiftyJSON
import Photos

class RegistrarionViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, NSXMLParserDelegate, AVSpeechSynthesizerDelegate, NSURLSessionTaskDelegate{
    
    var dismissFrom:Int!
    var dismissTo:Int!
    var firstLayer = UIView()
    var secondLayer:UIView!
    var tempCategory:String!
    var tempRecognizing = [:]
    var Locali:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool){
        getToken_MSTranslator()
        self.tabBarController?.tabBar.hidden = false
        firstLayer.removeFromSuperview()
        if (RegistrarionViewFlag == "Reload"){
            RegistrarionViewFlag = ""
            // UIボタンを作成.
            firstLayer = UIView()
            firstLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            firstLayer.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(firstLayer)
            setLabel(200, frameY: 30, tag:1, text: "Pocket Closet", fontSize: 26, layerX:self.view.bounds.width/2, layerY:self.view.bounds.height/10,view: firstLayer)
            setLabel(200, frameY: 30,tag:2,  text: LETS_REGISTER, fontSize: 16, layerX:self.view.bounds.width/2, layerY:self.view.bounds.height/5,view: firstLayer)
            setButton(140, frameY: 120, layerX: self.view.bounds.width/4, layerY: self.view.bounds.height*(2/5), text: BY_CAMERA, fontSize:16, imageName: "camera.png",imageEdgeTop: -20, imageEdgeLeft: 20,titleEdgeTop: 100,titleEdgeLeft:-100, cornerRadius:0,target: self, action: "pickFromCamera:", tag:3, view: firstLayer)
            setButton(140, frameY: 120, layerX: self.view.bounds.width*(3/4), layerY: self.view.bounds.height*(2/5), text: FROM_ALBUM, fontSize:16, imageName: "album.png",imageEdgeTop: -20, imageEdgeLeft: 20,titleEdgeTop: 100,titleEdgeLeft: -90, cornerRadius:0,target: self, action: "pickFromAlbum:", tag:4, view: firstLayer)
            
            let temp = arc4random() % 3 + 1
            imageFlag = "RegistrarionView"
            setImageView(0, Y: self.view.bounds.height*(3/5), sizeX: self.view.bounds.width, sizeY: self.view.bounds.height*(2/5), image: UIImage(named: "\(temp).jpg")!, tag: 5, view: firstLayer)
        }
    }
    
    //画面遷移
    func nextView(){
        forCheckView = "fromRegistrarion"
        self.performSegueWithIdentifier("ShowToCheckView", sender: nil)
    }
    func execution(){
        performSegueWithIdentifier("ModalLoginViewController", sender: self)
    }
    //
    
    //カメラ接続の設定
    func pickFromCamera(sender: UIButton) {
        RegistrarionViewFlag = "Reload"
        fromFlag = "Camera"
        let ipc = UIImagePickerController()
        ipc.delegate = self
        ipc.sourceType = UIImagePickerControllerSourceType.Camera
        ipc.allowsEditing = false
        ipc.navigationBar.tintColor = imageColor
        ipc.navigationBar.backgroundColor = UIColor.whiteColor()
        ipc.navigationBar.translucent = false
        ipc.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HiraginoSans-W3", size: 16)!,NSForegroundColorAttributeName:imageColor]
        self.presentViewController(ipc, animated: true, completion: nil)
    }
    //
    
    //アルバム接続の設定
    func pickFromAlbum(sender: UIButton){
        RegistrarionViewFlag = "Reload"
        fromFlag = "Album"
        let ipc:UIImagePickerController = UIImagePickerController()
        ipc.delegate = self
        ipc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        ipc.navigationBar.tintColor = imageColor
        ipc.navigationBar.backgroundColor = UIColor.whiteColor()
        ipc.navigationBar.translucent = false
        ipc.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HiraginoSans-W3", size: 16)!,NSForegroundColorAttributeName:imageColor]
        self.presentViewController(ipc, animated:true, completion:nil)
    }
    //
    
    //写真を取得
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        RegistrarionViewFlag = ""
        let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        globalImage = image
        
        //対象の画像のパスを取得
        if fromFlag == "Camera"{
            //from camaera
            if (info.indexForKey(UIImagePickerControllerOriginalImage) != nil) {
                var imagePath = NSHomeDirectory()
                imagePath = imagePath.stringByAppendingFormat("Documents/sample.png")
                let imageData: NSData = UIImagePNGRepresentation(image)!
                imageData.writeToFile (imagePath, atomically: true)
                let fileUrl: NSURL = NSURL(fileURLWithPath: imagePath)
                let Title = String(fileUrl).componentsSeparatedByString("/")
                let i = Title.count
                for(var j=0; j<i; j++) {
                    if Title[j].lowercaseString.containsString(".jpg") || Title[j].lowercaseString.containsString(".png") || Title[j].lowercaseString.containsString(".jpeg") {
                        RecognitionName = Title[j]
                    }
                }
            }
        }else if fromFlag == "Album"{
            //from album
            let pickedURL: NSURL = info[UIImagePickerControllerReferenceURL] as! NSURL
            let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithALAssetURLs([pickedURL], options: nil)
            let asset: PHAsset = fetchResult.firstObject as! PHAsset
            PHImageManager.defaultManager().requestImageDataForAsset(asset, options: nil, resultHandler:
                {(imageData: NSData?, dataUTI: String?, orientation: UIImageOrientation, info: [NSObject : AnyObject]?) in
                    let fileUrl: NSURL = info!["PHImageFileURLKey"] as! NSURL
                    let Title = String(fileUrl).componentsSeparatedByString("/")
                    let i = Title.count
                    for(var j=0; j<i; j++) {
                        if Title[j].lowercaseString.containsString(".jpg") || Title[j].lowercaseString.containsString(".png") || Title[j].lowercaseString.containsString(".jpeg") {
                            RecognitionName = Title[j]
                        }
                    }
            })
        }
        //解析用に画像リサイズ
        let Ratio = (image.size.height)/(image.size.width)
        var newHeight: CGFloat!
        var newWidth: CGFloat!
        if (image.size.height * image.size.width) > 310000 {
            if (image.size.height) > (image.size.width) {
                newHeight = 640
                newWidth = newHeight / Ratio
            } else {
                newWidth = 640
                newHeight = newWidth * Ratio
            }
        } else {
            newHeight = image.size.height
            newWidth = image.size.width
        }
        
        let newSize = CGRectMake(0, 0, newWidth, newHeight)
        UIGraphicsBeginImageContext(newSize.size)
        image.drawInRect(newSize)
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        RecognitionImage = newImage
        
        //画像の確認
        secondLayer = UIView()
        secondLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        secondLayer.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(secondLayer)
        let checkImage = UIImageView(frame: CGRectMake(0, 120, self.view.bounds.size.width, self.view.bounds.size.height-120))
        checkImage.contentMode = UIViewContentMode.ScaleAspectFit
        checkImage.image = image
        checkImage.tag = 6
        secondLayer.addSubview(checkImage)
        setButton(80, frameY: 80, layerX: self.view.bounds.width/4, layerY: 50, text: REDO, fontSize:12, imageName: "redo.png", imageEdgeTop: 0, imageEdgeLeft: 20,titleEdgeTop:55,titleEdgeLeft: -30, cornerRadius: 10,target: self, action: "dismissFunc", tag:8, view: secondLayer)
        setButton(80, frameY: 80, layerX: self.view.bounds.width*(3/4), layerY: 50, text: ANALYZE, fontSize:12, imageName: "decision.png", imageEdgeTop: 0, imageEdgeLeft: 20,titleEdgeTop:55,titleEdgeLeft:-30,  cornerRadius: 10,target: self, action: "getImageTag", tag:7, view: secondLayer)
        if fromFlag == "Camera"{
        setButton(80, frameY: 80, layerX: self.view.bounds.width*(2/4), layerY: 50, text: RESELECT, fontSize:12, imageName: "back.png", imageEdgeTop: 0, imageEdgeLeft: 15,titleEdgeTop:55,titleEdgeLeft: -30, cornerRadius: 10,target: self, action: "pickFromCamera:", tag:8, view: secondLayer)
        }else if fromFlag == "Album"{
        setButton(80, frameY: 80, layerX: self.view.bounds.width*(2/4), layerY: 50, text: RESELECT, fontSize:12, imageName: "back.png", imageEdgeTop: 0, imageEdgeLeft: 15,titleEdgeTop:55,titleEdgeLeft: -30, cornerRadius: 10,target: self, action: "pickFromAlbum:", tag:8, view: secondLayer)
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    //
    
    //DocomoAPIで画像認識
    func getImageTag(){
        self.tabBarController?.tabBar.hidden = true
        analyzing(ANALYZING_ITEM, view:self.view)
        Recognized = [[:],[:],[:],[:]]
        willTranslate = ""
        for(var Get=0; Get<4; Get++){
            self.GetImageTag(Get)
        }
    }
    
    func GetImageTag(times: Int){
        let imageData = UIImagePNGRepresentation(RecognitionImage)!
        let Header = ["Content-Type":"multipart/form-data"]
        var key: String!
        if keyFlag == 0 {
        key = "766745795a685a6a6a632f3157446f72436759776e646850375372686c42504f563778424f507467456c34"
        } else if (keyFlag == 1) {
        key = "764c53344b4854736f39545630587038464875746158567a6a32777a6d6f33666e61672f4178787569322f"
        }else if (keyFlag == 2) {
        key = "3451325361303176544d446b63414870615239427443486c6b4446376e413230423373416a477175666b30"
        }
        Alamofire.upload(.POST,
            "https://api.apigw.smt.docomo.ne.jp/imageRecognition/v1/concept/classify/?" + "APIKEY=" + key,
            headers: Header,
            multipartFormData:{ multipartFormData in
                // 文字列データはUTF8エンコードでNSData型に
                multipartFormData.appendBodyPart(data: modelName[times].dataUsingEncoding(NSUTF8StringEncoding)!, name: "modelName")
                // バイナリデータ
                // サーバによってはファイル名や適切なMIMEタイプを指定しないとちゃんと処理してくれないかも
                multipartFormData.appendBodyPart(data: imageData, name: "image", fileName: RecognitionName, mimeType: "image/png")
            },
            // リクエストボディ生成のエンコード処理が完了したら呼ばれる
            encodingCompletion: { encodingResult in
                switch encodingResult {
                    // エンコード成功時
                case .Success(let upload, _, _):
                    // 実際にAPIリクエストする
                    upload.response { request, response, data, error in
                        if let error = error {
                            ++keyFlag
                            if keyFlag == 3{
                            }else{
                            self.getImageTag()
                            }
                        }
                        var answer = JSON.parse(NSString(data: data!, encoding: NSUTF8StringEncoding)! as String)
                        var Recognizing = [
                            "No" : "\(times)",
                            "tag" : answer["candidates"][0]["tag"].string!
                        ]
                        let forSort = Int(Recognizing["No"]!)!
                        Recognized.insert(Recognizing, atIndex: forSort)
                        Recognized.removeAtIndex(forSort+1)
                        if Recognized[0] != [:] && Recognized[1] != [:] && Recognized[2] != [:] && Recognized[3] != [:] {
                            if TOPS == "Tops"{
                                didTranslateTimes = 0
                                willTranslate =  Recognized[0]["tag"]
                                self.do_MSTranslator()
                            }else{
                            self.dispatch_async_main {
                                self.checkCategory()
                                tempActivityIndicator.removeFromSuperview()
                                tempLabel.removeFromSuperview()
                                self.nextView()
                                }
                            }
                        }
                    }
                    // エンコード失敗時
                case .Failure(let encodingError): break
                }
            }
        )
    }
    
    func checkCategory(){
        var check = Recognized[1]["tag"]!
        if check.containsString(JACKET) || check.containsString(SHIRT) || check.containsString(COAT) || check.containsString(SWEAT) || check.containsString(ONEPIECE_DRESS)||check.containsString(CARDIGAN){
            self.tempCategory = TOPS
        }else if check.containsString(SKIRT)||check.containsString(SLACKS)||check.containsString(PANTS1)||check.containsString(PANTS2)||check.containsString(DENIM){
            self.tempCategory = BOTTOMS
        }else if check.containsString(SHOES1)||check.containsString(SHOES2)||check.containsString(PUMPS){
            self.tempCategory = SHOES
        }else if check.containsString(BAG){
            self.tempCategory = BAG
        }else{
            self.tempCategory = MISCELLANEOUS_GOODS
        }
        tempRecognizing = ["Category" : self.tempCategory]
        Recognized.insert(self.tempRecognizing as! [String : String], atIndex: 4)
    }
    
    //
    func dispatch_async_main(block: () -> ()) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
    
    //翻訳機能
    func do_MSTranslator(){
        let authHeader = ["Authorization": "Bearer " + accessToken]
        var URLstr:String!
        URLstr = "https://api.microsofttranslator.com/v2/Http.svc/Translate?" + "text=" + willTranslate + "&from=" + "ja" + "&to=" + "en"
        URLstr = URLstr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        Alamofire.request(.GET, URLstr, headers: authHeader)
            .responseData{ response in
                guard let object = response.result.value else{
                    return
                }
                let parser : NSXMLParser? = NSXMLParser(data: object)
                parser?.delegate = self
                parser!.parse()
        }
    }
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        didTranslate = string
        Recognized[didTranslateTimes]["tag"] = didTranslate
        if didTranslateTimes == 3{
            self.dispatch_async_main {
                self.checkCategory()
                tempActivityIndicator.removeFromSuperview()
                tempLabel.removeFromSuperview()
                self.nextView()
            }
        }else{
            didTranslateTimes++
            willTranslate =  Recognized[didTranslateTimes]["tag"]
            self.do_MSTranslator()
        }
    }
    
    //dismiss
    func dismissFunc(){
        firstLayer.removeFromSuperview()
        secondLayer.removeFromSuperview()
        RegistrarionViewFlag = "Reload"
        self.viewDidAppear(true)
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

