import UIKit
import Parse

class MyClosetViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    var Y:CGFloat! = 70
    var belowY:CGFloat! = 40
    var scroll:UIScrollView!
    var myCollectionView:UICollectionView!
    var Favorits: [[String: AnyObject]] = []
    var tempFavorits: [[String: AnyObject]] = []
    var totalIndexPath:Array<Int> = []
    var layout:UICollectionViewFlowLayout!
    var currentCategory:String!
    var beforePointX:CGFloat!
    var currentPointX:CGFloat!
    var currentPointY:CGFloat!
    var temp = 0
    var localFlag = 0
    var base:UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() == nil {
            self.loadView()
            consent()
        }else if tabBarSet == ""{
            Favorits = []
            tempFavorits = []
            fetchFavorits()
            setTopView()
            setScrollView()
            tapIconButton(iconButtons[0])
        }
        tabBarSet = ""
        if TotalCodeFlag == 1{
            myCollectionView.allowsMultipleSelection = true
        }
    }
    func removeGuide(){
        top.removeFromSuperview()
        middle.removeFromSuperview()
        backGround.removeFromSuperview()
        guideButton.removeFromSuperview()
    }
    
    //topviewの設定
    func setTopView(){
        if TotalCodeFlag == 0{
        setLabel(self.view.frame.width, frameY: Y, tag: 1, text: "\(PFUser.currentUser()!.username!)"+s_CLOSET
, fontSize: 18, layerX: self.view.frame.width/2, layerY: Y/2, view: self.view)
        }else{
        Y = 80
        let top = UIView()
        top.frame = CGRectMake(0, 0, self.view.frame.width, Y)
        top.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(top)
        setButton(70, frameY: Y, layerX: top.bounds.width*(1/3), layerY: Y/2, text: BACK, fontSize: 10, imageName: "back.png", imageEdgeTop: -10, imageEdgeLeft: 20, titleEdgeTop: 30, titleEdgeLeft: -30, cornerRadius: 0, target: self, action: "back", tag: 1, view: top)
        setButton(70, frameY: Y, layerX: top.bounds.width*(2/3), layerY: Y/2, text: REGISTRATION_ITEM3, fontSize: 10, imageName: "plus.png", imageEdgeTop: -10, imageEdgeLeft: 17, titleEdgeTop: 30, titleEdgeLeft: -30, cornerRadius: 0, target: self, action: "addItem", tag: 1, view: top)
        }
    
        iconButtons = []
        if TOPS == "Tops"{
        setButton(60, frameY: Y, layerX: self.view.frame.width*(1/7), layerY: Y*(4/3), text: TOPS, fontSize: 8, imageName: "トップス.png", imageEdgeTop: -10, imageEdgeLeft: 0, titleEdgeTop: 30, titleEdgeLeft: -50, cornerRadius: 0, target: self, action: "tapIconButton:", tag: 1, view: self.view)
        setButton(60, frameY: Y, layerX: self.view.frame.width*(2/7), layerY: Y*(4/3), text: BOTTOMS, fontSize: 8, imageName: "ボトムス.png", imageEdgeTop: -10, imageEdgeLeft: 5, titleEdgeTop: 30, titleEdgeLeft: -45, cornerRadius: 0, target: self, action: "tapIconButton:", tag: 2, view: self.view)
        setButton(60, frameY: Y, layerX: self.view.frame.width*(3/7), layerY: Y*(4/3), text: SHOES, fontSize: 8, imageName: "シューズ.png", imageEdgeTop: -10, imageEdgeLeft: 5, titleEdgeTop: 30, titleEdgeLeft: -50, cornerRadius: 0, target: self, action: "tapIconButton:", tag: 3, view: self.view)
        setButton(60, frameY: Y, layerX: self.view.frame.width*(4/7), layerY: Y*(4/3), text: BAG, fontSize: 8, imageName: "バッグ.png", imageEdgeTop: -10, imageEdgeLeft: 5, titleEdgeTop: 30, titleEdgeLeft: -45, cornerRadius: 0, target: self, action: "tapIconButton:", tag: 4, view: self.view)
        setButton(60, frameY: Y, layerX: self.view.frame.width*(5/7), layerY: Y*(4/3), text: MISCELLANEOUS_GOODS, fontSize: 8, imageName: "雑貨.png", imageEdgeTop: -10, imageEdgeLeft: 12, titleEdgeTop: 30, titleEdgeLeft: -30, cornerRadius: 0, target: self, action: "tapIconButton:", tag: 5, view: self.view)
        setButton(60, frameY: Y, layerX: self.view.frame.width*(6/7), layerY: Y*(4/3), text: TOTALCODE, fontSize: 8, imageName: "total.png", imageEdgeTop: -10, imageEdgeLeft: 12, titleEdgeTop: 30, titleEdgeLeft: -30, cornerRadius: 0, target: self, action: "tapIconButton:", tag: 6, view: self.view)
        setButton(60, frameY: Y, layerX: self.view.frame.width*(8/9), layerY: Y/2, text: HELP, fontSize: 8, imageName: "help.png", imageEdgeTop: 0, imageEdgeLeft: 2, titleEdgeTop: 40, titleEdgeLeft: -33, cornerRadius: 0, target: self, action: "localGuide", tag: 100, view: self.view)
            if TotalCodeFlag == 0{
        setButton(60, frameY: Y, layerX: self.view.frame.width*(1/9), layerY: Y/2, text: LOGOUT, fontSize: 8, imageName: "logout.png", imageEdgeTop: 0, imageEdgeLeft: 2, titleEdgeTop: 40, titleEdgeLeft: -33, cornerRadius: 0, target: self, action: "logout", tag: 100, view: self.view)
            }
        }else{
        setButton(50, frameY: Y, layerX: self.view.frame.width*(1/7), layerY: Y*(4/3), text: TOPS, fontSize: 8, imageName: "トップス.png", imageEdgeTop: -10, imageEdgeLeft: 0, titleEdgeTop: 30, titleEdgeLeft: -35, cornerRadius: 0, target: self, action: "tapIconButton:", tag: 1, view: self.view)
        setButton(50, frameY: Y, layerX: self.view.frame.width*(2/7), layerY: Y*(4/3), text: BOTTOMS, fontSize: 8, imageName: "ボトムス.png", imageEdgeTop: -10, imageEdgeLeft: 0, titleEdgeTop: 30, titleEdgeLeft: -35, cornerRadius: 0, target: self, action: "tapIconButton:", tag: 2, view: self.view)
        setButton(50, frameY: Y, layerX: self.view.frame.width*(3/7), layerY: Y*(4/3), text: SHOES, fontSize: 8, imageName: "シューズ.png", imageEdgeTop: -10, imageEdgeLeft: 0, titleEdgeTop: 30, titleEdgeLeft: -35, cornerRadius: 0, target: self, action: "tapIconButton:", tag: 3, view: self.view)
        setButton(50, frameY: Y, layerX: self.view.frame.width*(4/7), layerY: Y*(4/3), text: BAG, fontSize: 8, imageName: "バッグ.png", imageEdgeTop: -10, imageEdgeLeft: 0, titleEdgeTop: 30, titleEdgeLeft: -40, cornerRadius: 0, target: self, action: "tapIconButton:", tag: 4, view: self.view)
        setButton(50, frameY: Y, layerX: self.view.frame.width*(5/7), layerY: Y*(4/3), text: MISCELLANEOUS_GOODS, fontSize: 8, imageName: "雑貨.png", imageEdgeTop: -10, imageEdgeLeft: 0, titleEdgeTop: 30, titleEdgeLeft: -45, cornerRadius: 0, target: self, action: "tapIconButton:", tag: 5, view: self.view)
        setButton(50, frameY: Y, layerX: self.view.frame.width*(6/7), layerY: Y*(4/3), text: TOTALCODE, fontSize: 8, imageName: "total.png", imageEdgeTop: -10, imageEdgeLeft: 0, titleEdgeTop: 30, titleEdgeLeft: -40, cornerRadius: 0, target: self, action: "tapIconButton:", tag: 6, view: self.view)
        setButton(50, frameY: Y, layerX: self.view.frame.width*(8/9), layerY: Y/2, text: HELP, fontSize: 8, imageName: "help.png", imageEdgeTop: 0, imageEdgeLeft: 2, titleEdgeTop: 40, titleEdgeLeft: -33, cornerRadius: 0, target: self, action: "localGuide", tag: 100, view: self.view)
            if TotalCodeFlag == 0{
        setButton(50, frameY: Y, layerX: self.view.frame.width*(1/9), layerY: Y/2, text: LOGOUT, fontSize: 8, imageName: "logout.png", imageEdgeTop: 0, imageEdgeLeft: 2, titleEdgeTop: 40, titleEdgeLeft: -33, cornerRadius: 0, target: self, action: "logout", tag: 100, view: self.view)
            }
        }
        iconButtons[6].tintColor = UIColor.grayColor()
        iconButtons[6].setTitleColor(UIColor.grayColor(), forState: .Normal)
        iconButtons[6].setTitleColor(imageColor, forState: .Selected)
        if TotalCodeFlag == 0{
        self.navigationItem.leftBarButtonItem = editButtonItem()
        iconButtons[7].tintColor = UIColor.grayColor()
        iconButtons[7].setTitleColor(UIColor.grayColor(), forState: .Normal)
        iconButtons[7].setTitleColor(imageColor, forState: .Selected)
        }
    }
    func setSelectedButton(button: UIButton, selected: Bool) {
        button.selected = selected
        if button.selected == true{
            button.tintColor = imageColor
            button.setTitleColor(imageColor, forState: .Normal)
        }else{
            button.tintColor = UIColor.grayColor()
            button.setTitleColor(UIColor.grayColor(), forState: .Normal)
        }
    }
    func tapIconButton(sender: UIButton){
        let i = sender.tag - 1
        for(var j = 0; j < 6; j++){
            if j == i{
                setSelectedButton(iconButtons[j], selected: true)
                let pointX = self.view.frame.width * CGFloat(iconButtons[j].tag - 1)
                scroll.setContentOffset(CGPointMake(pointX, 0), animated: true)
                currentCategory = iconButtons[j].titleLabel?.text
                checkCell()
                setCollectionView(self.view.frame.width * CGFloat(j))
            }else{
                setSelectedButton(iconButtons[j], selected: false)
            }
        }
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        beforePointX = scrollView.contentOffset.x
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        currentPointX = scrollView.contentOffset.x
        currentPointY = scrollView.contentOffset.y
            if  (beforePointX != currentPointX) && (currentPointY == 0){
                let page = scrollView.contentOffset.x / scrollView.frame.width
                for (var i = 0; i < 6; i++) {
                    if page == CGFloat(i) {
                    setSelectedButton(iconButtons[i], selected: true)
                    let pointX = self.view.frame.width * CGFloat(iconButtons[i].tag - 1)
                    scroll.setContentOffset(CGPointMake(pointX, 0), animated: true)
                    currentCategory = iconButtons[i].titleLabel?.text
                    checkCell()
                    setCollectionView(self.view.frame.width * CGFloat(i))
                } else {
                    setSelectedButton(iconButtons[i], selected: false)
                     }
                }
            }
    }
    func checkCell(){
        tempFavorits = []
        totalIndexPath = []
        for(var i=0; i<Favorits.count; i++){
            if Favorits[i]["Category"]! as! String == currentCategory{
                tempFavorits.append(Favorits[i])
                totalIndexPath.append(i)
            }
        }
    }
    
    //TotalCode追加用
    func addItem(){
        UIAlertController.appearance().tintColor = imageColor
        let alertController = UIAlertController(title: ADDCONSENT, message: "", preferredStyle: .Alert)
        let addAction = UIAlertAction(title: "OK", style: .Default,
            handler:{ (action:UIAlertAction!) -> Void in
                self.add()
        })
        let cancelAction = UIAlertAction(title: CANCEL, style: .Default,
            handler:{ (action:UIAlertAction!) -> Void in
        })
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    func add(){
        if localFlag == 0{
            alert(WARNINGADD)
        }else{
        let tempNumber = Favorits.count
        for(var i=0; i<tempNumber; i++){
            if (Favorits[i]["Selected"] as! Int == 1){
                Favorits[i]["Item"]?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                    TotalCodeArray.append(UIImage(data: data!)!)
                })
            }
            if (i == tempNumber - 1){
                self.dismissViewControllerAnimated(false, completion: nil)
                TotalCodeFlag = 0
            }
        }
        }
    }
    //
    //scrollViewの設定
    func setScrollView(){
        scroll = UIScrollView()
        scroll.frame = CGRectMake(0, Y*2, self.view.frame.width, self.view.frame.height-(Y*2))
        scroll.contentSize = CGSizeMake(scroll.frame.width*6, scroll.frame.height)
        scroll.contentOffset = CGPointMake(0, Y*2)
        self.view.addSubview(scroll)
        scroll.pagingEnabled = true
        scroll.scrollEnabled = true
        scroll.delegate = self
    }
    
    //CollectionViewの設定
    func setCollectionView(x:CGFloat){
        // CollectionViewのレイアウトを生成.
        layout = UICollectionViewFlowLayout()
        // Cell一つ一つの大きさ.
        layout.itemSize = CGSizeMake(140, 140)
        // Cellのマージン.
        layout.sectionInset = UIEdgeInsetsMake(16, 16, 16, 16)
        // セクション毎のヘッダーサイズ.
        //layout.headerReferenceSize = CGSizeMake(100,30)
        // CollectionViewを生成.
        myCollectionView = UICollectionView(frame: CGRectMake(x, 0, self.view.frame.width, scroll.frame.height) , collectionViewLayout: layout)
        // Cellに使われるクラスを登録.
        myCollectionView.registerNib(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        myCollectionView.backgroundColor = UIColor.whiteColor()
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        scroll.addSubview(myCollectionView)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if TotalCodeFlag == 0{
        tempFavorits[indexPath.row]["Item"]?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            globalImage = UIImage(data: data!)
        })
        forCheckContent = [
            tempFavorits[indexPath.row]["StyleTag"] as! String,
            tempFavorits[indexPath.row]["TypeTag"] as! String,
            tempFavorits[indexPath.row]["ColorTag"] as! String,
            tempFavorits[indexPath.row]["PatternTag"] as! String
        ]
        nextView()
        } else {
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            var temp = totalIndexPath[indexPath.row]
            if (Favorits[temp]["Selected"] as! Int == 0){
                cell!.layer.borderColor = imageColor.CGColor
                cell!.layer.borderWidth = 2
                cell!.layer.cornerRadius = 5
                Favorits[temp]["Selected"] = 1
                localFlag++
            }else{
                cell!.layer.borderColor = UIColor.clearColor().CGColor
                cell!.layer.borderWidth = 0
                Favorits[temp]["Selected"] = 0
                localFlag--
            }
        }
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if PFUser.currentUser() == nil {
            return 0
        }else{
            return tempFavorits.count
        }
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        if PFUser.currentUser() == nil {
        }else{
        tempFavorits[indexPath.row]["Item"]?.getDataInBackgroundWithBlock({ (data, error) -> Void in
        cell.Item.image = UIImage(data: data!)
        })
        let longPress = UILongPressGestureRecognizer(target: self, action: "longPress:")
        cell.addGestureRecognizer(longPress)
            if (TotalCodeFlag == 1){
                if (tempFavorits[indexPath.row]["Selected"] as! Int == 1) {
                    cell.layer.borderColor = imageColor.CGColor
                    cell.layer.borderWidth = 2
                    cell.layer.cornerRadius = 5
                }
            }
        }
    return cell
    }
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        currentObjectId = (tempFavorits[indexPath.row]["objectId"] as? String)!
        globalIndexPath = indexPath
        globalIndexPathRow = indexPath.row
    }
    func longPress(sender: UILongPressGestureRecognizer){
        if TotalCodeFlag == 0{
                editCell()
        }
    }
    //タグ修正用機能
    func editCell(){
        UIAlertController.appearance().tintColor = imageColor
        let alertController = UIAlertController(title: EDIT_SELECTED_ITEM, message: "", preferredStyle: .Alert)
        let editImageAction = UIAlertAction(title: EDIT_ITEMIMAGE, style: .Default,handler:{ (action:UIAlertAction!) -> Void in
            self.tempFavorits[globalIndexPathRow]["Item"]?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                RecognitionImage = UIImage(data: data!)
            })  
            globalStyleTag = self.tempFavorits[globalIndexPathRow]["StyleTag"] as! String
            globalTypeTag = self.tempFavorits[globalIndexPathRow]["TypeTag"] as! String
            globalColorTag = self.tempFavorits[globalIndexPathRow]["ColorTag"] as! String
            globalPatternTag = self.tempFavorits[globalIndexPathRow]["PatternTag"] as! String
            forReEditFlag = "fromMyCloset"
            sleep(1)
                self.dispatch_async_main{
                    self.toImageEditView()
                }
        })
        let editAction = UIAlertAction(title: EDIT_THE_ITEM_TAGS, style: .Default,handler:{ (action:UIAlertAction!) -> Void in
            self.modify()
        })
        let deleteAction = UIAlertAction(title: DELETE_ITEM, style: .Default,handler:{ (action:UIAlertAction!) -> Void in
            myclosetDelete()
            self.Favorits = []
            self.tempFavorits = []
            self.loadView()
            self.viewDidAppear(false)
        })

        let cancelAction = UIAlertAction(title: CANCEL, style: .Default,
            handler:{ (action:UIAlertAction!) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        if (iconButtons[5].selected == false){
            alertController.addAction(editImageAction)
            alertController.addAction(editAction)
        }
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
    }
    func modify(){
        UIAlertController.appearance().tintColor = imageColor
        let alert = UIAlertController(title: EDIT_SELECTED_ITEM, message: "", preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: EDIT_THE_ITEM_TAGS, style: .Default) { (action:UIAlertAction!) -> Void in
            globalStyleTag = alert.textFields![0].text!
            globalTypeTag = alert.textFields![1].text!
            globalColorTag = alert.textFields![2].text!
            globalPatternTag = alert.textFields![3].text!
            if globalStyleTag == "" || globalColorTag == "" || globalPatternTag == ""{
                self.showAlert(INPUTTING_ALL_TAGS_IS_REQUIRED)
            }else{
            self.dispatch_async_global{
                self.dispatch_async_main{
                    myclosetUpdate()
                    self.loadView()
                    self.viewDidAppear(false)
                    self.alert(EDITTING_SUCCESS)
                }
            }
            }
        }
        let cancelAction = UIAlertAction(title: CANCEL, style: .Default) { (action:UIAlertAction!) -> Void in
        }
        // UIAlertControllerにtextFieldを追加
        alert.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
            let label:UILabel = UILabel(frame: CGRectMake(0, 0, 100, 30))
            label.text = STYLE
            label.textColor = UIColor.grayColor()
            textField.leftView = label
            textField.leftViewMode = UITextFieldViewMode.Always
            textField.text = self.tempFavorits[globalIndexPathRow]["StyleTag"] as! String
        }
        alert.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
            let label:UILabel = UILabel(frame: CGRectMake(0, 0, 100, 30))
            label.text = TYPE
            label.textColor = UIColor.grayColor()
            textField.leftView = label
            textField.leftViewMode = UITextFieldViewMode.Always
            textField.text = self.tempFavorits[globalIndexPathRow]["TypeTag"] as! String
        }
        alert.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
            let label:UILabel = UILabel(frame: CGRectMake(0, 0, 100, 30))
            label.text = COLOR
            label.textColor = UIColor.grayColor()
            textField.leftView = label
            textField.leftViewMode = UITextFieldViewMode.Always
            textField.text = self.tempFavorits[globalIndexPathRow]["ColorTag"] as! String
        }
        alert.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
            let label:UILabel = UILabel(frame: CGRectMake(0, 0, 100, 30))
            label.text = PATTERN
            label.textColor = UIColor.grayColor()
            textField.leftView = label
            textField.leftViewMode = UITextFieldViewMode.Always
            textField.text = self.tempFavorits[globalIndexPathRow]["PatternTag"] as! String
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
        }
    func dispatch_async_main(block: () -> ()) {
            dispatch_async(dispatch_get_main_queue(), block)
        }
    func dispatch_async_global(block: () -> ()) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
        }
    //

    //Parseから取得
    func fetchFavorits() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let queryInfo = PFQuery(className: "TagManager")
        queryInfo.limit = 1000
        queryInfo.includeKey("user")
        queryInfo.findObjectsInBackgroundWithBlock { (objects, error) in
            if error == nil {
                var favorite: [String: AnyObject]!
                for object in objects! {
                    let USER = object["user"].objectId
                    let current = PFUser.currentUser()!.objectId
                    if USER == current {
                        if TotalCodeFlag == 0{
                        favorite = [
                            "Item": object["Item"] as! PFFile,
                            "StyleTag":object["StyleTag"] as! String,
                            "TypeTag":object["TypeTag"] as! String,
                            "ColorTag":object["ColorTag"] as! String,
                            "PatternTag":object["PatternTag"] as! String,
                            "Category": object["Category"] as! String,
                            "objectId": object.objectId!
                        ]
                        }else{
                        favorite = [
                            "Item": object["Item"] as! PFFile,
                            "StyleTag":object["StyleTag"] as! String,
                            "TypeTag":object["TypeTag"] as! String,
                            "ColorTag":object["ColorTag"] as! String,
                            "PatternTag":object["PatternTag"] as! String,
                            "Category": object["Category"] as! String,
                            "objectId": object.objectId!,
                            "Selected": 0
                        ]
                        }
                        self.Favorits.append(favorite)
                    }
                }
                self.tapIconButton(iconButtons[0])
                self.myCollectionView.reloadData()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            }
    }
    
    //Guide用
    func localGuide(){
        base = UIView()
        base.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
        base.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(base)
        Guide(GUIDE01, body1: GUIDE02, body2: GUIDE03, image1: "guide1-1.png", image2: "guide1-2.png", view: base)
        base.addSubview(vc.view)
        setButton(70, frameY: 40, layerX: self.view.bounds.width-60, layerY: self.view.bounds.height-20, text: SKIP, fontSize: 14, imageName: "1.jpg", imageEdgeTop: 0, imageEdgeLeft: 0, titleEdgeTop: 0, titleEdgeLeft: 0, cornerRadius: 5, target: self, action: "skipAlert", tag: 99, view: base)
        button.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    //画面遷移系
    func toImageEditView(){
        self.performSegueWithIdentifier("ShowToImageEdit", sender: nil)
    }
    func nextView(){
        forCheckView = "fromMyCloset"
        self.performSegueWithIdentifier("ShowToCheckView", sender: nil)
    }
    func execution(){
        performSegueWithIdentifier("ModalLoginViewController", sender: self)
    }
    func back(){
        self.dismissViewControllerAnimated(false, completion: nil)
        TotalCodeFlag = 0
    }
    //
    //ログイン・ログアウト系
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
    //ログアウト
    func logout() {
        UIAlertController.appearance().tintColor = imageColor
        let alertController = UIAlertController(title: YOU_WANT_TO_LOGOUT, message: YOUR_ACCOUNT_INFORMATION_n_Username：+"\(PFUser.currentUser()!.username!)", preferredStyle: .Alert)
        let logoutAction = UIAlertAction(title: LOGOUT, style: .Default,
            handler:{ (action:UIAlertAction!) -> Void in
                self.executionLogout()
        })
        let cancelAction = UIAlertAction(title: CANCEL, style: .Default,
            handler:{ (action:UIAlertAction!) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    func executionLogout(){
        PFUser.logOut()
        self.loadView()
        performSegueWithIdentifier("ModalLoginViewController", sender: self)
    }
    //
    //アラート系
    func showAlert(message: String?) {
        UIAlertController.appearance().tintColor = imageColor
        let alertController = UIAlertController(title: ERROR, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }
    func alert(title:String) {
        UIAlertController.appearance().tintColor = imageColor
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }
    //
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
