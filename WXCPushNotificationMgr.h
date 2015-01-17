/**
 * This header is generated by class-dump-z 0.2a.
 * class-dump-z is Copyright (C) 2009 by KennyTM~, licensed under GPLv3.
 *
 * Source: (null)
 */

@class NSMutableArray, NSString, NSMutableDictionary;

__attribute__((visibility("hidden")))
@interface WXCPushNotificationMgr : NSObject {
	NSMutableArray* _mUnreadCallNotificationArray;
	NSMutableArray* _mVoipCallNotificationArray;
	NSMutableDictionary* _mPokeNotificationDic;
	unsigned mCurProcessBackgroudID;
	BOOL _bReapeatLocalPush;
	int _nReapeatLocalPushTimes;
	id _repeatPushObj;
}
@property(readonly, copy) NSString* debugDescription;
@property(readonly, copy) NSString* description;
@property(readonly, assign) Class superclass;
@property(readonly, assign) unsigned hash;
-(void)clearNoificationData;
-(int)fetchUnreadCountAndCancelNotificationByUuid:(id)uuid;
-(void)cancelVoipCallNotificationByUuid:(id)uuid;
-(void)presentUnreadCallLocalNotification;
-(void)presentVoipCallLocalNotification:(id)notification;
-(void)stopReapeatLocalPush;
-(void)startReapeatLocalPush:(id)push;
-(void)reapeatLocalPush:(id)push;
-(void)putLocalPush;
-(void)stopDetectLockScreen;
-(void)startDetectLockScreen;
-(void)presentPokeLocalNotification:(int)notification;
-(int)cancelPokeLocalNotification:(int)notification;
-(void)LocalPushWithUsrInfo:(id)usrInfo;
-(void)processUpdateApnPush:(id)push;
-(void)APNSPushWithUsrInfo:(id)usrInfo;
-(void)dealloc;
-(id)init;
@end

