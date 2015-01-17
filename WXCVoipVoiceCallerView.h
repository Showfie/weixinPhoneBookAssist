//
//  WXCVoipVoiceCallerView.h
//  
//
//  Created by Chase Yee on 15/1/4.
//
//

#ifndef _WXCVoipVoiceCallerView_h
#define _WXCVoipVoiceCallerView_h

@interface WXCVoipVoiceCallerView : NSObject {
}
-(void)onAcceptBtnClicked:(id)clicked;
-(void)switchToNormalCallFromRedial;
-(void)switchToRedialViewInMainThread;
-(void)recordTimerLooper;
-(void)stopMailRecordTimer;
-(void)startMailRecordTimer;
-(void)endVoipCallInMainThread;
-(void)endVoipCallWithDelay;
-(void)endVoipCallUpdateUI;
-(void)endVoipCall;
-(void)dealloc;
-(void)OnNetRejectError:(id)error;
-(void)OnBeCanceled:(id)canceled;
-(void)onSimultaneousCall:(id)call;
-(void)OnAutoHangUp:(id)up;
-(void)OnCallInterrupt:(id)interrupt;
-(void)OnInterrupt:(id)interrupt;
-(void)OnSyncError:(id)error ErrNo:(int)no;
-(void)OnError:(id)error ErrNo:(int)no;
-(void)OnBeginTalk:(id)talk;
-(void)OnBeHanguped:(id)hanguped ErrNo:(int)no;
-(void)OnBeginConnect:(id)connect;
-(void)OnBeRejected:(id)rejected;
-(void)OnTimeOut:(id)anOut;
-(void)OnBeAccepted:(id)accepted;
-(void)OnPreConnect:(id)connect;
-(void)OnNoAnswer:(id)answer;
-(void)OnCall:(id)call ErrNo:(int)no;
-(void)onDirectSwtichToVoiceMailRecord:(id)voiceMailRecord;
-(void)forceFinishVoipTalk;
-(BOOL)isNeedPlayEndingSound;
-(void)forceCloseAlertView;
-(void)forceCloseMailRecordingView;
-(int)checkVoiceMailResult:(unsigned long)result;
-(void)resetVoipCallStateBeforeMailVoiceRecord;
-(void)voiceMailRecordEnd;
-(void)initVoiceMailView;
-(void)endCallByCancel;
-(void)hangupCall;
-(void)sendMissCall;
-(void)cancelCall;
-(void)doAudioCall;
-(void)asyncPlaySound;
-(void)checkAndShowAlertView;
-(void)alertView:(id)view clickedButtonAtIndex:(int)index;
-(void)showBeHangupAlertView;
-(void)showRecordDeniedAlertView;
-(void)checkRecorderPermission;
-(void)OnRecordDenied;
-(void)OnRecordPermissioned;
-(void)onFinishVoipCall;
-(void)handleCancelRedialButton:(id)button;
-(void)handleManualVoiceMailButton:(id)button;
-(void)cancelVoiceMailButton:(id)button;
-(void)handleHangupButton:(id)button;
-(void)initBtnEvent;
-(void)startShowView;
-(void)unregisterobserver;
-(void)voiceMailRecordOverTimeAutoStopNotify;
-(void)voiceMailRecordInterruptNotify;
-(void)voiceMailRecordStartFailedNotify;
-(void)voiceMailRecordStartNotify;
-(void)registerobserver;
-(id)initViewWithContact:(id)contact andViewMode:(int)mode;
@end

#endif
