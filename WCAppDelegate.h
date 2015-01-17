@interface WCAppDelegate : NSObject{
}
-(BOOL)application:(id)application handleOpenURL:(id)url;
-(void)addDefaulteScreen;
-(BOOL)application:(id)application openURL:(id)url sourceApplication:(id)application3 annotation:(id)annotation;
-(void)application:(id)application didReceiveLocalNotification:(id)notification;
-(void)application:(id)application didReceiveRemoteNotification:(id)notification;
-(void)applicationDidReceiveMemoryWarning:(id)application;
-(void)application:(id)application didFailToRegisterForRemoteNotificationsWithError:(id)error;
-(void)application:(id)application didRegisterForRemoteNotificationsWithDeviceToken:(id)deviceToken;
-(void)applicationWillTerminate:(id)application;
-(void)handleActiveAlertView;
-(void)applicationDidBecomeActive:(id)application;
-(void)applicationWillEnterForeground:(id)application;
-(void)applicationDidEnterBackground:(id)application;
-(void)applicationWillResignActive:(id)application;
-(BOOL)application:(id)application didFinishLaunchingWithOptions:(id)options;
@end