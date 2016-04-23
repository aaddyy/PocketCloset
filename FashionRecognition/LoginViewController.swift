import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    var Flag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel(200, frameY: 40, tag:1, text: USER_REGISTER_LOGIN, fontSize: 16, layerX:self.view.bounds.width/2, layerY:self.view.bounds.height*(1/12),view: self.view)
        textFields = []
        setTextField(300, frameY: 30, tag: 2, text: "", placeholder: "Username", fontSize: 14, layerX: self.view.bounds.width/2, layerY: self.view.bounds.height*(1/6), view:self.view)
        textFields[0].delegate = self
        setTextField(300, frameY: 30, tag: 3, text: "", placeholder: "Password", fontSize: 14, layerX: self.view.bounds.width/2, layerY: self.view.bounds.height*(1.4/6), view:self.view)
        textFields[1].delegate = self
        
        //ユーザー登録、ログイン、キャンセル
        iconButtons = []
        setButton(80, frameY: 40, layerX: self.view.bounds.width*(1/6), layerY: self.view.bounds.height*(2/6), text: USER_n_REGISTER, fontSize: 14, imageName: "1.jpg", imageEdgeTop: 0, imageEdgeLeft: 0, titleEdgeTop: 0, titleEdgeLeft: 0, cornerRadius: 10, target: self, action: "tapSignUpButton:", tag: 4, view: self.view)
        setButton(80, frameY: 40, layerX: self.view.bounds.width*(3/6), layerY: self.view.bounds.height*(2/6), text: LOGIN, fontSize: 14, imageName: "1.jpg", imageEdgeTop: 0, imageEdgeLeft: 0, titleEdgeTop: 0, titleEdgeLeft: 0, cornerRadius: 10, target: self, action: "tapLoginButton:", tag: 5, view: self.view)
        setButton(80, frameY: 40, layerX: self.view.bounds.width*(5/6), layerY: self.view.bounds.height*(2/6), text: CANCEL, fontSize: 14, imageName: "1.jpg", imageEdgeTop: 0, imageEdgeLeft: 0, titleEdgeTop: 0, titleEdgeLeft: 0, cornerRadius: 10, target: self, action: "tapCancel:", tag: 6, view: self.view)
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        self.view.addGestureRecognizer(tap)
    }
    //表示する毎に表示画像を変更する
    override func viewWillAppear(animated: Bool) {
        let temp = arc4random() % 3 + 1
        setImageView(0, Y: self.view.bounds.height/2, sizeX: self.view.bounds.width, sizeY: self.view.bounds.height/2, image: UIImage(named: "\(temp).jpg")!, tag: 7, view: self.view)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    //GestureRecognizerで閉じる
    func handleTap(sender : UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    //
    func tapSignUpButton(sender: AnyObject) {
        let user = User(name: textFields[0].text!, password: textFields[1].text!)
        user.signUp { (message) in
            if let unwrappedMessage = message {
                if (unwrappedMessage == ("username "+"\(textFields[0].text!)"+" already taken")){
                    self.showAlert("「\(textFields[0].text!)」"+IS_ALREADY_REGISTERED)
                }else if(textFields[0].text! == ""){
                    self.showAlert(Username_and_Password_are_required_input)
                }else if(unwrappedMessage != "invalid login parameters") {
                    self.showAlert(unwrappedMessage)
                }
            }else if (textFields[1].text! == ""){
                self.showAlert(Username_and_Password_are_required_input)
            }else{
                self.showNotice(REGISTRATION_SUCCESS)
                self.presentingViewController!.dismissViewControllerAnimated(false, completion: nil)
            }
        }
    }
    func tapLoginButton(sender: AnyObject) {
        let user = User(name: textFields[0].text!, password: textFields[1].text!)
        user.login { (message) in
            if let unwrappedMessage = message {
                if (unwrappedMessage == "invalid login parameters") {
                    self.showAlert(Username_or_Password_is_invailid)
                }else if (unwrappedMessage != "invalid login parameters") {
                    self.showAlert(unwrappedMessage)
                }
            } else{
                self.showNotice(LOGIN_SUCCESS)
                self.presentingViewController!.dismissViewControllerAnimated(false, completion: nil)
            }
        }
    }
    func tapCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    //アラートを表示させるメソッドを定義
    func showAlert(message: String?) {
        UIAlertController.appearance().tintColor = imageColor
        let alertController = UIAlertController(title: ERROR, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }
    func showNotice(message: String?) {
        UIAlertController.appearance().tintColor = imageColor
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        presentViewController(alertController, animated: true, completion: nil)
    }
    //縦画面固定
    override func shouldAutorotate() -> Bool{
        return false
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    //
}
    