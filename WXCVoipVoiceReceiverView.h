//
//  WXCVoipVoiceReceiverView.h
//  
//
//  Created by Chase Yee on 15/1/4.
//
//

#ifndef _WXCVoipVoiceReceiverView_h
#define _WXCVoipVoiceReceiverView_h

@interface WXCVoipVoiceReceiverView : NSObject{
    BOOL _isNeedFormSysMsg;
    BOOL _hasAcceptCall;
    BOOL _hasHangUp;
    BOOL _isAutoAccept;
    BOOL _needPlaySound;
    BOOL _notPlayEndingSound;
    BOOL _bCloseViewWithoutAnimation;
}

- (void)handleSystemCallButton:(id)arg1;
- (void)OnNetRejectError:(id)arg1;
- (void)OnBeCanceled:(id)arg1;
- (void)OnBeHanguped:(id)arg1 ErrNo:(int)arg2;
- (void)OnSyncError:(id)arg1 ErrNo:(int)arg2;
- (void)OnError:(id)arg1 ErrNo:(int)arg2;
- (void)OnTimeOut:(id)arg1;
- (void)OnAutoHangUp:(id)arg1;
- (void)OnCallInterrupt:(id)arg1;
- (void)OnInterrupt:(id)arg1;
- (void)OnBeginTalk:(id)arg1;
- (void)OnBeginConnect:(id)arg1;
- (void)OnPreConnect:(id)arg1;
- (void)OnAccept:(id)arg1 ErrNo:(int)arg2;
- (void)OnCall:(id)arg1 ErrNo:(int)arg2;
- (void)doAcceptCall;
- (void)endCallByCancel;
- (void)endVoipCallInMainThread;
- (void)endVoipCallWithDelay;
- (void)endVoipCallUpdateUI;
- (void)endVoipCall;
- (void)forceFinishVoipTalk;
- (BOOL)isNeedPlayEndingSound;
- (void)forceCloseAlertView;
- (void)alertView:(id)arg1 clickedButtonAtIndex:(int)arg2;
- (void)showBeHangupAlertView;
- (void)showRecordDeniedAlertView;
- (void)permissionDeniedHangup;
- (void)OnRecordDenied;
- (void)OnRecordPermissioned;
- (void)hangupCall;
- (void)rejectCall;
- (void)realAcceptCall;
- (void)acceptCall;
- (void)onFromBackgroundToForeground;
- (void)playSoundInThread;
- (void)startRing;
- (void)asyncPlaySound;
- (void)asyncAcceptAudio;
- (void)markLastVoipInfo;
- (void)onFinishVoipCall;
- (void)handleAcceptButton:(id)arg1;
- (void)handleDeclineButton:(id)arg1;
- (void)initBtnEvent;
- (void)checkAndShowAlertView;
- (void)startShowView;
- (void)autoHungUpTimerHere;
- (void)autoReceivceTimerHere;
- (void)stopAutoHungUpCallTimer;
- (void)stopAutoReceviceCallTimer;
- (void)startAutoReceviceCallTimer;
- (BOOL)checkIsAutoTestMode;
- (BOOL)isCaller;
- (void)dealloc;
- (void)onSysVolumeChange:(id)arg1;
- (id)initViewWithContact:(id)arg1 andPlaySound:(BOOL)arg2 andViewMode:(int)arg3;

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) unsigned int hash;
@property(readonly) Class superclass;

@end


#endif
