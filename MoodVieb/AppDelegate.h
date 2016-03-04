//
//  AppDelegate.h
//  MoodVibe
//
//  Created by code-on on 8/7/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginVC.h"
#import "HomeVC.h"
#import "UITabBarCustom.h"
#import "Main.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,ZipArchiveDelegate>
{
    Reachability *reachability;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navController;
@property (nonatomic, readonly) int networkStatus;
@property (nonatomic) BOOL isPopToAllView;
@property (nonatomic, retain) UITabBarCustom *objCustomTabBar;
@property (nonatomic, strong) UINavigationController *navHome;
@property (nonatomic, strong) NSArray *aryVibes;
#pragma mark-tab bar controller
-(void)gotoDetailApp:(int)pintTabId;
-(void)hidetabar;
-(void)Showtabar;
-(void)tabbarselectindex:(int)index;
-(void)favClcik;

@end

