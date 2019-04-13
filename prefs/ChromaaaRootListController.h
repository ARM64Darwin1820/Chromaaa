#import <Preferences/PSListController.h>
#import <CepheiPrefs/HBRootListController.h>
#import <Cephei/HBPreferences.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import "NSTask.h"

@interface ChromaaaRootListController : HBRootListController
- (void)respring;
@property(nonatomic, retain) UIBarButtonItem *respringButton;
@end

@interface ChromaaaCreditsController : HBRootListController

@end
