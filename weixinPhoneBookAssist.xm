#include <substrate.h>
#include <string.h>
#include <sqlite3.h>
#include <notify.h>
#import <CoreFoundation/CFNotificationCenter.h>
//#include "CPDistributedMessagingCenter.h"
#import <CoreFoundation/CoreFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>
#import "SBLockScreenManager.h"
#import "WCAppDelegate.h"					// import Weixin Phonebook APIs
#import "WXCMagicBox.h"
#import "WXCPushNotificationMgr.h"
#import "WXCVoipVoiceCallerView.h"
#import "WXCVoipVoiceReceiverView.h"

//#import "MMWormhole.h"

#define WEIXINADDRESSBOOK @"com.tencent.weixinPhoneBook"
#define WEIXINADDRESSBOOKCFNOTIFICATION @"com.tencent.weixinPhoneBook.cfnotification"
#define WEIXINADDRESSBOOKRELOCKNOTIFICATION @"com.tencent.weixinPhoneBook.relock"
#define WEIXINADDRESSBOOKINCALLNOTIFICATION @"com.tencent.weixinPhoneBook.incall"

static BOOL _shouldAutoRelockDevice = FALSE;
static BOOL _shouldCachePS = TRUE;
static BOOL _shouldRelaunchPreviousApp = FALSE;
static SBApplication *_frontMostApp = nil;

static void unlockDevice()
{
	if([[objc_getClass("SBLockScreenManager") sharedInstance] isUILocked])
	{
		id password = [[NSUserDefaults standardUserDefaults] objectForKey:@"cachedPS"];
// 			[_cache objectForKey:@"cachedPS"];
		if (password)
		{
			BOOL unlockSuccess = [[objc_getClass("SBLockScreenManager") sharedInstance] attemptUnlockWithPasscode:
				password];
			if(!unlockSuccess)
				_shouldCachePS = TRUE;
			
			_shouldAutoRelockDevice = TRUE;
		
		//NSLog(@"com.showfie.weixinPhonebookAssist: Device unlocked.");
		}
	}
	else
	{
		_frontMostApp = [(SpringBoard *)[UIApplication sharedApplication] _accessibilityFrontMostApplication];
		_shouldRelaunchPreviousApp = TRUE;
	}
}

static void weixinPhoneBookRelockDeviceHandler(CFNotificationCenterRef center,
						void * observer,
						CFStringRef name,
						void const * object,
						CFDictionaryRef userInfo)
{
	if(_shouldRelaunchPreviousApp)
	{
		if(_frontMostApp)
		{
			[[UIApplication sharedApplication] launchApplicationWithIdentifier:[_frontMostApp bundleIdentifier]
																	suspended:false];
// 			NSLog(@"com.showfie.weixinPhonebookAssist: weixinPhoneBookRelockDeviceHandler frontmostApp %@.", [_frontMostApp bundleIdentifier]);
		}
		else
			// return to homeScreen
			[[objc_getClass("SBUIController") sharedInstance] clickedMenuButton];
		_shouldRelaunchPreviousApp = FALSE;
	}
	
	if(_shouldAutoRelockDevice)
	{
		if(![[objc_getClass("SBLockScreenManager") sharedInstance] isUILocked])
		{
			[[objc_getClass("SBLockScreenManager") sharedInstance] lockUIFromSource:4 withOptions:nil];
		}
		_shouldAutoRelockDevice = FALSE;
	}
}

static void weixinPhoneBookIncallHandler(CFNotificationCenterRef center,
						void * observer,
						CFStringRef name,
						void const * object,
						CFDictionaryRef userInfo)
{
	unlockDevice();
	[[UIApplication sharedApplication] launchApplicationWithIdentifier :WEIXINADDRESSBOOK suspended:false];	
}

static void notifySpringBoardWithMessage(NSString *message)
{
	CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
	BOOL const deliverImmediately = YES;
	CFStringRef str = (__bridge CFStringRef)message;
	CFNotificationCenterPostNotification(center, str, NULL, nil, deliverImmediately);
}

%hook SpringBoard

-(void)applicationDidFinishLaunching:(id)application {
    %orig;
	
	// add CFNotification observer
	CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
	CFStringRef relockNoti = (__bridge CFStringRef)WEIXINADDRESSBOOKRELOCKNOTIFICATION;
	CFStringRef incallNoti = (__bridge CFStringRef)WEIXINADDRESSBOOKINCALLNOTIFICATION;
	CFNotificationCenterAddObserver(center,
						(__bridge const void *)(self),
						weixinPhoneBookRelockDeviceHandler,
						relockNoti,
						NULL,
						CFNotificationSuspensionBehaviorDeliverImmediately);
	CFNotificationCenterAddObserver(center,
						(__bridge const void *)(self),
						weixinPhoneBookIncallHandler,
						incallNoti,
						NULL,
						CFNotificationSuspensionBehaviorDeliverImmediately);
}

%end

%hook SBUIController
/*
-(void)_toggleSwitcherForReals
{
	%orig;
	if(_shouldAutoRelockDevice)
	{
		if(![[objc_getClass("SBLockScreenManager") sharedInstance] isUILocked])
		{
			[[objc_getClass("SBLockScreenManager") sharedInstance] lockUIFromSource:4 withOptions:nil];
		}
		_shouldAutoRelockDevice = FALSE;
	}	
}
*/
-(BOOL)_activateAppSwitcher
{
	if(_shouldAutoRelockDevice)
	{
		if(![[objc_getClass("SBLockScreenManager") sharedInstance] isUILocked])
		{
			[[objc_getClass("SBLockScreenManager") sharedInstance] lockUIFromSource:4 withOptions:nil];
		}
		_shouldAutoRelockDevice = FALSE;
	}
	return %orig;
}
%end

/*
%hook SBApplication
-(void)_fireNotification:(id)arg1
{
	%orig;
	NSLog(@"com.showfie.weixinPhonebookAssist: SBApplication %@ _setScheduledLocalNotifications %@.", 
		[self bundleIdentifier], arg1);
	if(![[objc_getClass("SBTelephonyManager") sharedTelephonyManager ] inCall])
	{
		if([[self bundleIdentifier] isEqualToString:WEIXINADDRESSBOOK])
		{
			unlockDevice();
			[[UIApplication sharedApplication] launchApplicationWithIdentifier :WEIXINADDRESSBOOK suspended:false];
		}
	}			
}
%end
*/

%hook SBRemoteNotificationServer
-(void)connection:(id)arg1 didReceiveIncomingMessage:(id)arg2
{
	%orig;
	//NSLog(@"com.showfie.weixinPhonebookAssist: SBRemoteNotificationServer connection %@ didReceiveIncomingMessage %@ topic %@ userinfo %@.", arg1, arg2, [arg2 topic], [arg2 userInfo]);
// 	NSLog(@"com.showfie.weixinPhonebookAssist: SBRemoteNotificationServer connection %@ didReceiveIncomingMessage %@.", arg1, arg2);
	
	if(![[objc_getClass("SBTelephonyManager") sharedTelephonyManager ] inCall])
	{
		//NSString *wePhoneIdentifier = @"com.tencent.weixinPhoneBook";
		
		if([[[objc_getClass("SBRemoteNotificationServer") sharedInstance ] lastNotificationReceivedBundleIdentifier]
					isEqualToString:WEIXINADDRESSBOOK])
		{
// 			NSLog(@"com.showfie.weixinPhonebookAssist: SBRemoteNotificationServer lastNotificationReceivedBundleIdentifier is %@.", 
// 			[[objc_getClass("SBRemoteNotificationServer") sharedInstance ] lastNotificationReceivedBundleIdentifier]);
			unlockDevice();
			[[UIApplication sharedApplication] launchApplicationWithIdentifier :WEIXINADDRESSBOOK suspended:false];
		}
		
	}
}
%end

%hook SBLockScreenManager

-(BOOL)attemptUnlockWithPasscode:(id)arg1
{
	BOOL ret = %orig;
	//NSLog(@"com.showfie.weixinPhonebookAssist: SBLockScreenManager attemptUnlockWithPasscode start.");
	if(_shouldCachePS && ret)
	{
		[[NSUserDefaults standardUserDefaults] setObject:arg1 forKey:@"cachedPS"];
// 		[[_cache objectForKey:@"cachedPS"] autorelease];
// 		[_cache setObject:[arg1 copy] forKey:@"cachedPS"];
	}
// 	NSLog(@"com.showfie.weixinPhonebookAssist: SBLockScreenManager attemptUnlockWithPasscode: %@, ret: %@.",
// 		[[NSUserDefaults standardUserDefaults] objectForKey:@"cachedPS"], ret?@"SUCCESS":@"FAILED");
	return ret;
}
%end

%hook WXCPushNotificationMgr
-(void)presentVoipCallLocalNotification:(id)notification
{
	%orig;
// 	NSLog(@"com.showfie.weixinPhonebookAssist: WXCPushNotificationMgr presentVoipCallLocalNotification %@.", notification);
	/*
	NSDictionary *d = [NSDictionary dictionaryWithObject:@"onFinishVoipCall"
                                                  forKey:@"status"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"WXCStatusChangeNotification"
                      object:self
                    userInfo:d];
    */
    
	notifySpringBoardWithMessage(WEIXINADDRESSBOOKINCALLNOTIFICATION);
}
%end

%hook WXCVoipVoiceCallerView
-(void)onAcceptBtnClicked:(id)clicked
{
	%orig;
// 	NSLog(@"com.showfie.weixinPhonebookAssist: WXCVoipVoiceCallerView onAcceptBtnClicked %@.", clicked);
}
-(void)OnBeHanguped:(id)hanguped ErrNo:(int)no
{
	%orig;
// 	NSLog(@"com.showfie.weixinPhonebookAssist: WXCVoipVoiceCallerView onBeHanguped %@ ErrNo %d.", hanguped, no);

	notifySpringBoardWithMessage(WEIXINADDRESSBOOKRELOCKNOTIFICATION);
}
-(void)OnBeRejected:(id)rejected
{
	%orig;
// 	NSLog(@"com.showfie.weixinPhonebookAssist: WXCVoipVoiceCallerView onBeRejected %@.", rejected);
}
-(void)OnBeAccepted:(id)accepted
{
	%orig;
// 	NSLog(@"com.showfie.weixinPhonebookAssist: WXCVoipVoiceCallerView OnBeAccepted %@.", accepted);
}
-(void)onFinishVoipCall
{
	%orig;
// 	NSLog(@"com.showfie.weixinPhonebookAssist: WXCVoipVoiceCallerView onFinishVoipCall.");
                    
	notifySpringBoardWithMessage(WEIXINADDRESSBOOKRELOCKNOTIFICATION);
}
%end

%hook WXCVoipVoiceReceiverView
-(void)OnBeHanguped:(id)hanguped ErrNo:(int)no
{
	%orig;
// 	NSLog(@"com.showfie.weixinPhonebookAssist: WXCVoipVoiceReceiverView onBeHanguped %@ ErrNo %d.", hanguped, no);
	
	notifySpringBoardWithMessage(WEIXINADDRESSBOOKRELOCKNOTIFICATION);
}
-(void)onFinishVoipCall
{
	%orig;
// 	NSLog(@"com.showfie.weixinPhonebookAssist: WXCVoipVoiceReceiverView onFinishVoipCall.");
	notifySpringBoardWithMessage(WEIXINADDRESSBOOKRELOCKNOTIFICATION);
}
- (void)handleAcceptButton:(id)arg1
{
	%orig;
// 	NSLog(@"com.showfie.weixinPhonebookAssist: WXCVoipVoiceReceiverView handleAcceptButton %@.", arg1);
}
- (void)handleDeclineButton:(id)arg1
{
	%orig;
// 	NSLog(@"com.showfie.weixinPhonebookAssist: WXCVoipVoiceReceiverView handleDeclineButton %@.", arg1);
	
	notifySpringBoardWithMessage(WEIXINADDRESSBOOKRELOCKNOTIFICATION);
}
%end

%hook WCAppDelegate
-(void)application:(id)application didReceiveRemoteNotification:(id)notification
{
	%orig;
// 	NSLog(@"com.showfie.weixinPhonebookAssist: WCAppDelegate %@ didReceiveRemoteNotification %@.", application, notification);
}

-(BOOL)application:(id)application didFinishLaunchingWithOptions:(id)options
{	
// 	NSLog(@"com.showfie.weixinPhonebookAssist: WCAppDelegate %@ didFinishLaunchingWithOptions %@.", application, options);
	return %orig;
}

-(void)applicationWillEnterForeground:(id)application
{
	%orig;
// 	NSLog(@"com.showfie.weixinPhonebookAssist: WCAppDelegate applicationWillEnterForeground.");
}

-(void)applicationDidEnterBackground:(id)application
{
	%orig;
	notifySpringBoardWithMessage(WEIXINADDRESSBOOKRELOCKNOTIFICATION);
}
%end