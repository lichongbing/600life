#import "SceneDelegate.h"
#import "LLTabBarController.h"
#import "GuidenceViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    
    if(!kIsIOS13beBelow){  //ios 13以上的版本
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
        self.window.backgroundColor = kAppBackGroundColor;
        self.window.frame = windowScene.coordinateSpace.bounds;
        LLTabBarController* rootTabbarVC = [LLTabBarController sharedController];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kFirstLaunch]){
             //不第一次启动
            self.window.rootViewController = rootTabbarVC;
        }else{ //第一次
             [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFirstLaunch];
             GuidenceViewController *guidanceVC = [[GuidenceViewController alloc] init];
             guidanceVC.modalPresentationStyle = UIModalTransitionStyleCrossDissolve;
             self.window.rootViewController = guidanceVC;
            [self.window makeKeyAndVisible];
        }
        
        [self.window makeKeyAndVisible];
    }
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    if(kIsIOS13()){
        //把角标数值清空
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
        //APP变为活跃状态时查看剪切板内容 弹出搜索框
        [[NSNotificationCenter defaultCenter]postNotificationName:kCheckUserPasteboardNofification object:nil userInfo:nil];
        
        //APP变为活跃状态时 告诉SettingViewController 让它刷新数据
        [[NSNotificationCenter defaultCenter]postNotificationName:kAppDidBecomeActiveNofification object:nil userInfo:nil];
    }
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
