@interface SBHomeScreenPreviewView
+ (void)cleanupPreview;
+ (id)preview;
@end

@interface SBLockScreenManager

+(id)sharedInstance;
-(void)unlockUIFromSource:(int)source withOptions:(id)options;

@end

// %hook SBIconController
// - (void)unscatterAnimated:(_Bool)arg1 afterDelay:(double)arg2 withCompletion:(id)arg3{

// 	%orig(false, arg2, arg3);
// }
// %end

%hook SBCameraGrabberView

- (id)_cameraGrabberImage{

//UIImage *image = [UIImage imageWithContentsOfFile:@"/User/Documents/unlock.png"];

//return image;
return nil;

}

%end

%hook SBLockScreenCameraController
 

- (void)prepareForSlideUpAnimation{

 	NSLog(@"Hooking the container camera view!");

	UIView *DownView = MSHookIvar<UIView *>(self, "_cameraContainerView");

	UIView *HomeScreen = [%c(SBHomeScreenPreviewView) preview];
	
	[DownView addSubview:HomeScreen];

	NSLog(@"Variable Hooking completed view = %@", HomeScreen);
	
	%orig;

 }

- (void)activateCamera{

NSLog(@"I'm unlocking for u sir!!!!!");
[[objc_getClass("SBLockScreenManager") sharedInstance] unlockUIFromSource:0 withOptions:nil];

}

%end