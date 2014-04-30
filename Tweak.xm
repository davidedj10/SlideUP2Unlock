@interface SBHomeScreenPreviewView
+ (void)cleanupPreview;
+ (id)preview;
@end

@interface SBLockScreenManager

+(id)sharedInstance;
-(void)unlockUIFromSource:(int)source withOptions:(id)options;

@end

NSDictionary *_preferences;

bool enabled = false;
bool hide_grabber = false;

// %hook SBIconController
// - (void)unscatterAnimated:(_Bool)arg1 afterDelay:(double)arg2 withCompletion:(id)arg3{

// 	%orig(false, arg2, arg3);
// }
// %end

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

		NSLog(@"I'm unlocking for u sir!!!!!");
		[[objc_getClass("SBLockScreenManager") sharedInstance] unlockUIFromSource:0 withOptions:nil];

	}else{

	%orig;

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
