import UIKit
import Parse
import Onboard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var CONTENT1 = NSLocalizedString("CONTENT1", comment:"" )
    var CONTENT2 = NSLocalizedString("CONTENT2", comment:"" )
    var CONTENT3 = NSLocalizedString("CONTENT3", comment:"" )
    var CONTENT4 = NSLocalizedString("CONTENT4", comment:"" )

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //Parseで取得したApplication IDとClient Keyを指定
        Parse.setApplicationId("hGYT1yWYmFhBiU7zPFv7PBuStYK28NC8EvY0g1Uw", clientKey: "zh1qm6ab7liWHnKrPiBIWTRqLobcJPEsSglWUZtI")
    AdobeUXAuthManager.sharedManager().setAuthenticationParametersWithClientID("9f756b4516444a9d8d20ea4f2cc58f60", withClientSecret: "184a1df5-bf27-4be5-af5f-4d3a1732506e")
        
        //Onboardでのウォークスルー
        if PFUser.currentUser() == nil {
        if true {
        if TOPS == "Tops"{
            let content1 = OnboardingContentViewController(
                title: "",
                body: CONTENT1,
                image: nil,
                buttonText: nil,
                action: nil
            )
            content1.bodyFontSize = 18
            let content2 = OnboardingContentViewController(
                title: "",
                body: CONTENT2,
                image: UIImage(named: "intro1en.png"),
                buttonText: "",
                action: nil
            )
            content2.bodyFontSize = 16
            let content3 = OnboardingContentViewController(
                title: "",
                body: CONTENT3,
                image: UIImage(named: "intro2en.png"),
                buttonText: "",
                action: nil
            )
            content3.bodyFontSize = 16
            let content4 = OnboardingContentViewController(
                title: "",
                body: CONTENT4,
                image: UIImage(named: "intro3en.png"),
                buttonText: "",
                action: nil
            )
            content4.bodyFontSize = 16
            let contentArray = [content1, content2, content3,content4]
            for (var i=0; i<4; i++){
                contentArray[i].iconHeight = (window?.bounds.height)!*0.8
                contentArray[i].iconWidth = (window?.bounds.width)!*0.8
                contentArray[i].topPadding =  -10
                contentArray[i].underIconPadding = 0
                contentArray[i].underTitlePadding = 0
                contentArray[i].bottomPadding = 10
                contentArray[i].titleTextColor = imageColor
                contentArray[i].bodyTextColor = imageColor
                contentArray[i].buttonTextColor = imageColor
            }
            let vc = OnboardingViewController(
                backgroundImage: nil,
                contents: [content1, content2, content3,content4]
            )
            vc.allowSkipping = true
            vc.shouldMaskBackground = false
            vc.view.backgroundColor = UIColor.whiteColor()
            vc.view.contentMode = UIViewContentMode.ScaleAspectFit
            vc.skipButton.setTitle("Skip", forState: .Normal)
            vc.skipButton.setTitleColor(imageColor, forState: .Normal)
            vc.pageControl.pageIndicatorTintColor = UIColor.grayColor()
            vc.pageControl.currentPageIndicatorTintColor = imageColor
            vc.skipHandler = { _ in
                let firstView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("firstView")
                self.window?.rootViewController!.presentViewController(firstView, animated: true, completion: nil)
            }
            window?.rootViewController = vc
            return true
        }else{
            let content1 = OnboardingContentViewController(
                title: "",
                body: nil,
                image: nil,
                buttonText: CONTENT1,
                action: nil
            )
            content1.buttonFontSize = 16
            let content2 = OnboardingContentViewController(
                title: "",
                body: CONTENT2,
                image: UIImage(named: "intro1.png"),
                buttonText: "",
                action: nil
            )
            content2.bodyFontSize = 16
            let content3 = OnboardingContentViewController(
                title: "",
                body: CONTENT3,
                image: UIImage(named: "intro2.png"),
                buttonText: "",
                action: nil
            )
            content3.bodyFontSize = 16
            let content4 = OnboardingContentViewController(
                title: "",
                body: CONTENT4,
                image: UIImage(named: "intro3.png"),
                buttonText: "",
                action: nil
            )
            content4.bodyFontSize = 16
            let contentArray = [content1, content2, content3,content4]
            for (var i=0; i<4; i++){
                contentArray[i].iconHeight = (window?.bounds.height)!*0.8
                contentArray[i].iconWidth = (window?.bounds.width)!*0.8
                contentArray[i].topPadding =  -10
                contentArray[i].underIconPadding = 0
                contentArray[i].underTitlePadding = 0
                contentArray[i].bottomPadding = 10
                contentArray[i].titleTextColor = imageColor
                contentArray[i].bodyTextColor = imageColor
                contentArray[i].buttonTextColor = imageColor
            }
            let vc = OnboardingViewController(
                backgroundImage: nil,
                contents: [content1, content2, content3,content4]
            )
            vc.allowSkipping = true
            vc.shouldMaskBackground = false
            vc.view.backgroundColor = UIColor.whiteColor()
            vc.view.contentMode = UIViewContentMode.ScaleAspectFit
            vc.skipButton.setTitle("Skip", forState: .Normal)
            vc.skipButton.setTitleColor(imageColor, forState: .Normal)
            vc.pageControl.pageIndicatorTintColor = UIColor.grayColor()
            vc.pageControl.currentPageIndicatorTintColor = imageColor
            vc.skipHandler = { _ in
                let firstView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("firstView")
                self.window?.rootViewController!.presentViewController(firstView, animated: true, completion: nil)
            }
            window?.rootViewController = vc
            return true
            }
            }
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

