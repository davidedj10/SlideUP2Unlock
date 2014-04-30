@interface SpringBoard : UIApplication
- (void)_relaunchSpringBoardNow;
- (void)reboot;
- (void)powerDown;
@end

#import <Preferences/Preferences.h>

@interface SlideUP2UnlockPrefsListController: PSListController {
}
@end

@implementation SlideUP2UnlockPrefsListController
    
- (id)specifiers {

    //not sure if this is the better place for this crap...
    UIImage *image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/SlideUP2UnlockPrefs.bundle/Logo.png"];
    UIImageView *Canvas = [[UIImageView alloc] initWithImage:image];
    CGRect frame = CGRectMake(0, 15, 640, 129);
    UIView *ls = [[UIView alloc] initWithFrame:frame];
    [ls addSubview:Canvas];
    [self.view  addSubview:ls];

	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"SlideUP2UnlockPrefs" target:self] retain];
	}
	return _specifiers;
}

 - (void)viewWillAppear:(BOOL)animated {
    
    self.title = nil;
    [self reload];
}

-(void)Follow:(PSSpecifier*)spec
{
    
   if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"tweetbot:"]]){
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tweetbot://user_profile/davidedj10"]];
    }else if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"tweetings:"]]){
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tweetings:///user?screen_name=davidedj10"]];
    }else if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"twitter:"]]){
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"twitter://user?screen_name=davidedj10"]];
    }else{
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://twitter.com/davidedj10"]];
    }           
    
}

-(void)Respring:(PSSpecifier*)spec
{
    
    system("killall SpringBoard");
       
}

-(void)Github:(PSSpecifier*)spec
{
    
    NSURL *url = [[NSURL alloc] initWithString:@"https://github.com/davidedj10/SlideUP2Unlock"];
	[[UIApplication sharedApplication] openURL:url];
    
}

-(void)Donate:(PSSpecifier*)spec
{
    
    NSURL *url = [[NSURL alloc] initWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=davidedj10%40live%2eit&lc=IT&item_name=Davide%20Fresilli&currency_code=EUR&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted"];
	[[UIApplication sharedApplication] openURL:url];
    
}

@end

// vim:ft=objc
