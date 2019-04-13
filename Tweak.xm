#import <UIKit/UIKit.h>

@interface SBWallpaperEffectView : UIView
@end

@interface _UIBackdropView : UIView
- (void)transitionToStyle:(NSInteger)style;
@end

@interface SBFloatingDockPlatterView : UIView
@property (nonatomic,retain) _UIBackdropView * backgroundView;
@end

@interface SBDockView : UIView
@property(retain, nonatomic) SBWallpaperEffectView *_backgroundView;
-(void)setBackgroundAlpha:(double)arg1;
@end

BOOL enabled;
BOOL dockEnabled;
BOOL labelEnabled;
BOOL dpkgInvalid = false;

%group main
%hook SBDockView

-(void)setBackgroundAlpha: (double)arg1 {
	%orig;
	if(enabled && dockEnabled) {
		if(arg1 == 0.0) {
			%orig(0.0);
		} else {
			MSHookIvar<SBWallpaperEffectView *>(self, "_backgroundView").alpha = 0.0f;

			NSTimeInterval milisecondedDate = ([[NSDate date] timeIntervalSince1970] * 1000);
			NSNumber *timeStampObj = [NSNumber numberWithLong: milisecondedDate];
			long long int timestamp = [timeStampObj longLongValue];
			float hue = fmod((timestamp / 15000.0),1.0);
			UIColor *color = [UIColor colorWithHue: hue saturation: 1 brightness: 1 alpha: 1];
			self.backgroundColor = color;

			dispatch_async(dispatch_get_main_queue(), ^{
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
					[self setBackgroundAlpha:nil];
				});
			});
		}
	} else {

	}
}
%end

%hook SBFloatingDockPlatterView

-(void)layoutSubviews {
	%orig;
	if(enabled && dockEnabled) {

		NSTimeInterval milisecondedDate = ([[NSDate date] timeIntervalSince1970] * 1000);
		NSNumber *timeStampObj = [NSNumber numberWithLong: milisecondedDate];
		long long int timestamp = [timeStampObj longLongValue];
		float hue = fmod((timestamp / 15000.0),1.0);
		UIColor *color = [UIColor colorWithHue: hue saturation: 1 brightness: 1 alpha: 1];

		_UIBackdropView *backgroundView = MSHookIvar<_UIBackdropView*>(self, "_backgroundView");
		backgroundView.backgroundColor = color;
		backgroundView.alpha = 1.0f;
		backgroundView.layer.cornerRadius = 26.5;
		[backgroundView transitionToStyle : -2];

		dispatch_async(dispatch_get_main_queue(), ^{
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
				[self layoutSubviews];
			});
		});
	} else {

	}
}
%end

%hook UILabel
- (void)setTextColor: (UIColor *)textColor {
	if(enabled && labelEnabled) {
		NSTimeInterval milisecondedDate = ([[NSDate date] timeIntervalSince1970] * 1000);
		NSNumber *timeStampObj = [NSNumber numberWithLong: milisecondedDate];
		long long int timestamp = [timeStampObj longLongValue];
		float hue = fmod((timestamp / 15000.0),1.0);
		UIColor *color = [UIColor colorWithHue: hue saturation: 1 brightness: 1 alpha: 1];

		%orig(color);

		dispatch_async(dispatch_get_main_queue(), ^{
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
				[self setTextColor:nil];
			});
		});
	} else {
		%orig(textColor);
	}
}
%end
%end

%group IntegrityFail

%hook SpringBoard

-(void)applicationDidFinishLaunching: (id)arg1 {
	%orig;
	if (!dpkgInvalid) return;
	UIAlertController *alertController = [UIAlertController
	                                      alertControllerWithTitle:@"😡😡😡"
	                                      message:@"The build of Chromaaa you're using comes from an untrusted source. Pirate repositories can distribute malware and you will get subpar user experience using any tweaks from them.\nRemember: Chromaaa is free. Uninstall this build and install the proper version of Chromaaa from:\nhttps://repo.conorthedev.com/\n"
	                                      preferredStyle:UIAlertControllerStyleAlert
	                                     ];

	[alertController addAction:[UIAlertAction actionWithTitle:@"OK!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
	                                    [((UIApplication*)self).keyWindow.rootViewController dismissViewControllerAnimated:YES completion:NULL];
				    }]];

	[((UIApplication*)self).keyWindow.rootViewController presentViewController:alertController animated:YES completion:NULL];
}

%end

%end

static void loadPrefs() {
	NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.conorthedev.chromaaaprefs.plist"];

	enabled = [settings objectForKey:@"kEnabled"] ?[[settings objectForKey:@"kEnabled"] boolValue] : YES;
	labelEnabled = [settings objectForKey:@"kLabelEnabled"] ?[[settings objectForKey:@"kLabelEnabled"] boolValue] : YES;
	dockEnabled = [settings objectForKey:@"kDockEnabled"] ?[[settings objectForKey:@"kDockEnabled"] boolValue] : YES;
}

%ctor {
	dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.conorthedev.chromaaa.list"];

	if (dpkgInvalid) {
		%init(IntegrityFail);
		return;
	} else {
		%init(main);
	}
	loadPrefs();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.conorthedev.chromaaaprefs/saved"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}