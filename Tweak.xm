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
- (void)_lockUI;

@end

@interface SBDeviceLockController

+(id)sharedController;
- (BOOL)isPasscodeLocked;

@end


NSDictionary *_preferences;

bool enabled = false;
bool hide_grabber = false;

// %hook SBIconController
// - (void)unscatterAnimated:(_Bool)arg1 afterDelay:(double)arg2 withCompletion:(id)arg3{

// 	%orig(false, arg2, arg3);
// }
// %end

%hook SpringBoard

- (void)_unscatterWillBegin:(id)arg1{

	NSLog(@"ciao");
}

%end


%hook SBCameraGrabberView

- (id)_cameraGrabberImage{

	if(hide_grabber){
		return nil;
	}else{
		return [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/SlideUP2UnlockPrefs.bundle/unlock.png"]; 
	}

}

%end

%hook SBLockScreenCameraController

int sliderCount = 0;

- (void)prepareForSlideUpAnimation{

if(enabled){

 	NSLog(@"Hooking the container camera view!");

 	//Yay quite tricky but it works! :D
 		if(sliderCount < 1){

		UIView *DownView = MSHookIvar<UIView *>(self, "_cameraContainerView");

		UIView *HomeScreen = [%c(SBHomeScreenPreviewView) preview];
	
		[DownView addSubview:HomeScreen];
	
		}
	}
	
	sliderCount++;
	
	%orig;

 }

- (void)activateCamera{

	if(enabled){

		if([[objc_getClass("SBDeviceLockController") sharedController] isPasscodeLocked]){

		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Passcode" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] ;
		alertView.tag = 2;
		alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
		[alertView show];

		[[alertView textFieldAtIndex:0] resignFirstResponder];
		[[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypePhonePad];
		[[alertView textFieldAtIndex:0] becomeFirstResponder];




		}else{

		[[objc_getClass("SBLockScreenManager") sharedInstance] unlockUIFromSource:0 withOptions:nil];
		
		}

			}else{

	%orig;

	}

}

%new
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
 
            UITextField * alertTextField = [alertView textFieldAtIndex:0];
           
            if([[%c(SBLockScreenManager) sharedInstance] attemptUnlockWithPasscode:alertTextField.text]){

            }else{

            NSLog(@"IS PASSED!");
            [[%c(SBIconController) sharedInstance] _lockScreenUIWillLock:nil];

            }
 
// do whatever you want to do with this UITextField.
}


%end


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

%ctor{

NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

NSLog(@"SlideUP2Unlock initialized...");

CFNotificationCenterRef center = CFNotificationCenterGetDarwinNotifyCenter();
CFNotificationCenterAddObserver(center, NULL, &prefs, (CFStringRef)@"com.davidedj10.slideup2unlock/prefs", NULL, 0);

reloadPreferences();

[pool drain];

}
