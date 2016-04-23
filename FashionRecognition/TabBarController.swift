import UIKit
import Parse

class TabBarController: UITabBarController,UITabBarControllerDelegate{
    var Tab = UITabBarItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        // アイコン色
        UITabBar.appearance().tintColor = imageColor
        UITabBar.appearance().translucent  = false
        UITabBar.appearance().backgroundColor = UIColor.whiteColor()
        UITabBar.appearance().layer.borderColor = UIColor.grayColor().CGColor
    }
    
    override func viewWillAppear(animated: Bool) {
        if tabBarSet == "MyCloset"{
            self.selectedIndex = 1
        }else if RegistrarionViewFlag == ""{
        }else{
            RegistrarionViewFlag = "Reload"
            self.selectedIndex = 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.tag == 1{
            RegistrarionViewFlag = "Reload"
        }
        if item.tag == 2{
            if PFUser.currentUser() == nil {
                self.selectedIndex = 0
            }
        }
    }
    
    //縦画面固定
    override func shouldAutorotate() -> Bool{
        return false
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }

}
