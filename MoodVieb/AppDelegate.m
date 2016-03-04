//
//  AppDelegate.m
//  MoodVibe
//
//  Created by code-on on 8/7/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import "AppDelegate.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    reachability = [Reachability reachabilityForInternetConnection];
    // Start Monitoring
    [reachability startNotifier];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkNetworkStatus:)
                                                 name:kReachabilityChangedNotification object:nil];

    //basic array configeration
    
    if ([[Singleton sharedSingleton] getUserDefault:CURRENTPLAYINDEX] ==nil) {
        [[Singleton sharedSingleton] setUserDefault:@"0" :CURRENTPLAYINDEX];
    }
    
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    //copy database to document directory
    [DataManager shareddbSingleton];
    NSLog(@"app dir: %@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    
    // Unzip Operation

     
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    LoginVC *loginobj = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController:loginobj];
    [self.navController.navigationBar setHidden:YES];
    self.navController.interactivePopGestureRecognizer.enabled = NO;
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
    if ([[WebserviceCaller sharedSingleton] isconnectedToNetwork]) {
        [[DataManager shareddbSingleton] startDownloading];
        [[WebserviceCaller sharedSingleton] updateStatstics];
        [[WebserviceCaller sharedSingleton] SyncLikes];
        [[WebserviceCaller sharedSingleton] SyncFav];
        
    }
    
    
    for (NSString* family in [UIFont familyNames])
    {
    //    NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
     //       NSLog(@"  %@", name);
        }
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark- custom tab bar
-(void)gotoDetailApp:(int)pintTabId{
    [self setTabBar];
    self.objCustomTabBar.delegate=self;
    //  [self.navController pushViewController:self.objCustomTabBar animated:YES];
    [self.objCustomTabBar setSelectedIndex:pintTabId];
    [self.objCustomTabBar selectTab:pintTabId];
}


-(void)setTabBar
{
    
    //Note: Use this method and respective variables when there is TabBar in the app.
    self.objCustomTabBar=[[UITabBarCustom alloc]init];
    // first
    HomeVC *homeObj =[[HomeVC alloc] initWithNibName:@"HomeVC" bundle:Nil];
    self.navHome = [[UINavigationController alloc] initWithRootViewController:homeObj];
    
    self.objCustomTabBar.viewControllers =@[self.navHome];
    [self.navHome setNavigationBarHidden:TRUE];
    
}

-(void)hidetabar{
    [self.objCustomTabBar hideTabBar];
}
-(void)tabbarselectindex:(int)index{
    [self.objCustomTabBar setSelectedIndex:index];
    [self.objCustomTabBar selectTab:index];
}

-(void)Showtabar{
    [self.objCustomTabBar showTabBar];
}



-(void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
    NSLog(@"received event!");
    if (receivedEvent.type == UIEventTypeRemoteControl)
    {
        switch (receivedEvent.subtype)
        {
            case UIEventSubtypeRemoteControlPlay:
                //  play the video
                if ([AFSoundManager sharedManager].status == AFSoundManagerStatusPaused) {
                    //[[AFSoundManager sharedManager]resume];
                    [self.objCustomTabBar.customTabobj.btnPlay sendActionsForControlEvents:UIControlEventTouchUpInside];
                }

                break;
                
            case  UIEventSubtypeRemoteControlPause:
                // pause the video
                if ([AFSoundManager sharedManager].status == AFSoundManagerStatusPlaying) {
                    //[[AFSoundManager sharedManager] pause];
                    [self.objCustomTabBar.customTabobj.btnPause sendActionsForControlEvents:UIControlEventTouchUpInside];
                    
                }
                break;
                
            case  UIEventSubtypeRemoteControlNextTrack:
                // to change the video
                break;
                
            case  UIEventSubtypeRemoteControlPreviousTrack:
                // to play the privious video 
                break;
                
            default:
                break;
        }
    }
}

-(void)favClcik{
    
    if(![self.navHome.topViewController isKindOfClass:[FavoriteVC class]]) {
        NSArray *ary=self.navHome.viewControllers;
        int i=0;
        BOOL isFound=NO;
        for (UIViewController *vc in ary) {
            if (vc.class == [FavoriteVC class]) {
                isFound=YES;
                break;
            }
            i++;
        }
        if (isFound) {
            [self.navHome popToViewController:[ary objectAtIndex:i] animated:YES];
        }else{
            FavoriteVC *favObj=[[FavoriteVC alloc] initWithNibName:@"FavoriteVC" bundle:nil];
            [self.navHome pushViewController:favObj animated:YES];
        }
    }
}


- (void)checkNetworkStatus:(NSNotification *)notice {
    // called after network status changes
    
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            [self.objCustomTabBar.customTabobj.btnPause sendActionsForControlEvents:UIControlEventTouchUpInside];
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI");
            if ([[WebserviceCaller sharedSingleton] isconnectedToNetwork]) {
                //[[DataManager shareddbSingleton] startDownloading];
                [[WebserviceCaller sharedSingleton] updateStatstics];
                [[WebserviceCaller sharedSingleton] SyncLikes];
                [[WebserviceCaller sharedSingleton] SyncFav];
            }
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN!");
            break;
        }
    }
}

@end
