#line 1 "Tweak.xm"
@interface SBIconController
+ (id)sharedInstance;
- (void)_lockScreenUIWillLock:(id)arg1;
@end

@interface SBHomeScreenPreviewView
+ (void)cleanupPreview;
+ (id)preview;
@end

@interface SBLockScreenManager

+(id)sharedInstance;
-(void)unlockUIFromSource:(int)source withOptions:(id)options;
- (void)_setUILocked:(_Bool)arg1;
- (_Bool)_shouldAutoUnlockFromUnlockSource:(int)arg1;
-(BOOL)attemptUnlockWithPasscode:(id)arg1;
- (BOOL)isUILocked;
- (void)_relockUIForButtonPress:(_Bool)arg1 afterCall:(_Bool)arg2;

@end

@interface SpringBoard
- (void)_lockButtonDownFromSource:(int)arg1;
- (void)_runUnlockTest;
@end

@interface SBDeviceLockController

+(id)sharedController;
- (BOOL)isPasscodeLocked;

@end


NSDictionary *_preferences;

bool enabled = false;
bool hide_grabber = false;








#include <logos/logos.h>
#include <substrate.h>
@class SBLockScreenCameraController; @class SBHomeScreenPreviewView; @class SBCameraGrabberView; @class SBLockScreenManager; @class SBLockScreenView; @class SpringBoard; 
static id (*_logos_orig$_ungrouped$SBLockScreenView$_defaultSlideToUnlockText)(SBLockScreenView*, SEL); static id _logos_method$_ungrouped$SBLockScreenView$_defaultSlideToUnlockText(SBLockScreenView*, SEL); static id (*_logos_orig$_ungrouped$SBCameraGrabberView$_cameraGrabberImage)(SBCameraGrabberView*, SEL); static id _logos_method$_ungrouped$SBCameraGrabberView$_cameraGrabberImage(SBCameraGrabberView*, SEL); static void (*_logos_orig$_ungrouped$SBLockScreenCameraController$prepareForSlideUpAnimation)(SBLockScreenCameraController*, SEL); static void _logos_method$_ungrouped$SBLockScreenCameraController$prepareForSlideUpAnimation(SBLockScreenCameraController*, SEL); static void (*_logos_orig$_ungrouped$SBLockScreenCameraController$activateCamera)(SBLockScreenCameraController*, SEL); static void _logos_method$_ungrouped$SBLockScreenCameraController$activateCamera(SBLockScreenCameraController*, SEL); static BOOL _logos_method$_ungrouped$SBLockScreenCameraController$textField$shouldChangeCharactersInRange$replacementString$(SBLockScreenCameraController*, SEL, UITextField *, NSRange, NSString *); static void _logos_method$_ungrouped$SBLockScreenCameraController$alertView$clickedButtonAtIndex$(SBLockScreenCameraController*, SEL, UIAlertView *, NSInteger); 
static __inline__ __attribute__((always_inline)) Class _logos_static_class_lookup$SBHomeScreenPreviewView(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBHomeScreenPreviewView"); } return _klass; }static __inline__ __attribute__((always_inline)) Class _logos_static_class_lookup$SBLockScreenManager(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBLockScreenManager"); } return _klass; }static __inline__ __attribute__((always_inline)) Class _logos_static_class_lookup$SpringBoard(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SpringBoard"); } return _klass; }
#line 48 "Tweak.xm"


static id _logos_method$_ungrouped$SBLockScreenView$_defaultSlideToUnlockText(SBLockScreenView* self, SEL _cmd){

    _logos_orig$_ungrouped$SBLockScreenView$_defaultSlideToUnlockText(self, _cmd);

    return @"";    
}

 



static id _logos_method$_ungrouped$SBCameraGrabberView$_cameraGrabberImage(SBCameraGrabberView* self, SEL _cmd){

	if(hide_grabber){
		return nil;
	}else{
		return [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/SlideUP2UnlockPrefs.bundle/unlock.png"]; 
	}

}





int sliderCount = 0;

static void _logos_method$_ungrouped$SBLockScreenCameraController$prepareForSlideUpAnimation(SBLockScreenCameraController* self, SEL _cmd){

if(enabled){

 	NSLog(@"Hooking the container camera view!");

 	
 		if(sliderCount < 1){

		UIView *DownView = MSHookIvar<UIView *>(self, "_cameraContainerView");

		UIView *HomeScreen = [_logos_static_class_lookup$SBHomeScreenPreviewView() preview];
	
		[DownView addSubview:HomeScreen];
	
		}
	}
	
	sliderCount++;
	
	_logos_orig$_ungrouped$SBLockScreenCameraController$prepareForSlideUpAnimation(self, _cmd);

 }

static void _logos_method$_ungrouped$SBLockScreenCameraController$activateCamera(SBLockScreenCameraController* self, SEL _cmd){

	if(enabled){

		if([[objc_getClass("SBDeviceLockController") sharedController] isPasscodeLocked]){

		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Passcode" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] ;
		alertView.tag = 2;
		alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
		[alertView show];

		[[alertView textFieldAtIndex:0] resignFirstResponder];
		[[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
		[[alertView textFieldAtIndex:0] becomeFirstResponder];

		 UITextField * alertTextField = [alertView textFieldAtIndex:0];
		 alertTextField.delegate = self;


		}else{

		[[objc_getClass("SBLockScreenManager") sharedInstance] unlockUIFromSource:0 withOptions:nil];
		
		}

			}else{

	_logos_orig$_ungrouped$SBLockScreenCameraController$activateCamera(self, _cmd);

	}

}


static BOOL _logos_method$_ungrouped$SBLockScreenCameraController$textField$shouldChangeCharactersInRange$replacementString$(SBLockScreenCameraController* self, SEL _cmd, UITextField * textField, NSRange range, NSString * string) {
    if ([textField.text length] > 3) {

        textField.text = [textField.text substringToIndex:4-1];
        
        return NO;
    }

    return YES;
}


static void _logos_method$_ungrouped$SBLockScreenCameraController$alertView$clickedButtonAtIndex$(SBLockScreenCameraController* self, SEL _cmd, UIAlertView * alertView, NSInteger buttonIndex){
 
            UITextField * alertTextField = [alertView textFieldAtIndex:0];

           
            if([[_logos_static_class_lookup$SBLockScreenManager() sharedInstance] attemptUnlockWithPasscode:alertTextField.text]){

            }else{

            
            SpringBoard *sb = (SpringBoard *)[_logos_static_class_lookup$SpringBoard() sharedApplication];
            [sb _runUnlockTest];

            }
 }





void reloadPreferences(){

 _preferences = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.davidedj10.slideup2unlockprefs.plist"];

enabled = [[_preferences objectForKey:@"enable"] boolValue];
hide_grabber = [[_preferences objectForKey:@"hide_grabber_icon"] boolValue];


}

static inline void prefs(CFNotificationCenterRef center,
                                    void *observer,
                                    CFStringRef name,
                                    const void *object,
                                    CFDictionaryRef userInfo) {
    reloadPreferences();
    NSLog(@"SlideUP2Unlock preferences updated...");
}

static __attribute__((constructor)) void _logosLocalCtor_b614337b(){

NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

NSLog(@"SlideUP2Unlock initialized...");

CFNotificationCenterRef center = CFNotificationCenterGetDarwinNotifyCenter();
CFNotificationCenterAddObserver(center, NULL, &prefs, (CFStringRef)@"com.davidedj10.slideup2unlock/prefs", NULL, 0);

reloadPreferences();

[pool drain];

}
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBLockScreenView = objc_getClass("SBLockScreenView"); MSHookMessageEx(_logos_class$_ungrouped$SBLockScreenView, @selector(_defaultSlideToUnlockText), (IMP)&_logos_method$_ungrouped$SBLockScreenView$_defaultSlideToUnlockText, (IMP*)&_logos_orig$_ungrouped$SBLockScreenView$_defaultSlideToUnlockText);Class _logos_class$_ungrouped$SBCameraGrabberView = objc_getClass("SBCameraGrabberView"); MSHookMessageEx(_logos_class$_ungrouped$SBCameraGrabberView, @selector(_cameraGrabberImage), (IMP)&_logos_method$_ungrouped$SBCameraGrabberView$_cameraGrabberImage, (IMP*)&_logos_orig$_ungrouped$SBCameraGrabberView$_cameraGrabberImage);Class _logos_class$_ungrouped$SBLockScreenCameraController = objc_getClass("SBLockScreenCameraController"); MSHookMessageEx(_logos_class$_ungrouped$SBLockScreenCameraController, @selector(prepareForSlideUpAnimation), (IMP)&_logos_method$_ungrouped$SBLockScreenCameraController$prepareForSlideUpAnimation, (IMP*)&_logos_orig$_ungrouped$SBLockScreenCameraController$prepareForSlideUpAnimation);MSHookMessageEx(_logos_class$_ungrouped$SBLockScreenCameraController, @selector(activateCamera), (IMP)&_logos_method$_ungrouped$SBLockScreenCameraController$activateCamera, (IMP*)&_logos_orig$_ungrouped$SBLockScreenCameraController$activateCamera);{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(BOOL), strlen(@encode(BOOL))); i += strlen(@encode(BOOL)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UITextField *), strlen(@encode(UITextField *))); i += strlen(@encode(UITextField *)); memcpy(_typeEncoding + i, @encode(NSRange), strlen(@encode(NSRange))); i += strlen(@encode(NSRange)); memcpy(_typeEncoding + i, @encode(NSString *), strlen(@encode(NSString *))); i += strlen(@encode(NSString *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBLockScreenCameraController, @selector(textField:shouldChangeCharactersInRange:replacementString:), (IMP)&_logos_method$_ungrouped$SBLockScreenCameraController$textField$shouldChangeCharactersInRange$replacementString$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIAlertView *), strlen(@encode(UIAlertView *))); i += strlen(@encode(UIAlertView *)); memcpy(_typeEncoding + i, @encode(NSInteger), strlen(@encode(NSInteger))); i += strlen(@encode(NSInteger)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBLockScreenCameraController, @selector(alertView:clickedButtonAtIndex:), (IMP)&_logos_method$_ungrouped$SBLockScreenCameraController$alertView$clickedButtonAtIndex$, _typeEncoding); }} }
#line 200 "Tweak.xm"
