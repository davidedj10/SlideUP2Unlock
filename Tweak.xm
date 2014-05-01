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


//Global Vars...
NSDictionary *_preferences;

bool enabled = false;
bool hide_grabber = false;


%hook SBCameraGrabberView

- (id)_cameraGrabberImage{
if(enabled){
	if(hide_grabber){

		return nil;

	}else{

		return [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/SlideUP2UnlockPrefs.bundle/unlock.png"]; 
	}
}else{

	return %orig;
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
		[[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
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

            //surprising method xD
            SpringBoard *sb = (SpringBoard *)[%c(SpringBoard) sharedApplication];
            [sb _runUnlockTest];

            }
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
