//
//  UITabBarCustom.m
//  iOSCodeStructure
//
//  Created by Nishant
//  Copyright (c) 2013 Nishant. All rights reserved.
//

#import "UITabBarCustom.h"
#import "AppDelegate.h"
@class AppDelegate;
@interface UITabBarCustom ()
{
    UINavigationController * navController;
}
@end

@implementation UITabBarCustom
@synthesize btnTab1, btnTab2, btnTab3, btnTab4,btnTab5;
@synthesize imgTabBg;
#pragma mark - This is the main Tabbar in the Application
#pragma mark - View Life Cycle
-(void)viewDidLoad
{
    [super viewDidLoad];
    HeightTabbar=85;
    noOfTab=5;
    appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self addCustomElements];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideOriginalTabBar];
}
#pragma mark - Hide Original TabBar - Add Custom TabBar
- (void)hideOriginalTabBar
{
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            view.hidden = YES;
            break;
        }
    }
}
-(void)addCustomElements
{
    //Add Bg Image
    if(imgTabBg != nil)
    {
        [imgTabBg removeFromSuperview];
    }
    float y = 0;//[UIScreen mainScreen].bounds.size.height-HeightTabbar;
    float w = [UIScreen mainScreen].bounds.size.width;
    float h =[UIScreen mainScreen].bounds.size.height;
    customTabobj = [self loadViewNib:@"customTab"];
    [customTabobj.btnPopup addTarget:self action:@selector(OpenpopupClick) forControlEvents:UIControlEventTouchUpInside];
    
    SideMenu = [self loadViewNib:@"MenuListVC"];
    SideMenu.frame = CGRectMake(w, 0, 250, h);
    [SideMenu.btnClose addTarget:self action:@selector(ClosepopupClick) forControlEvents:UIControlEventTouchUpInside];
    
    bottom_view=[[UIView alloc] initWithFrame:CGRectMake(0,y,w,HeightTabbar)];
    customTabobj.frame = CGRectMake(0, 0, w, HeightTabbar);
    [self.view addSubview:customTabobj];
    [self.view addSubview:SideMenu];
    y_position=0;
    btn_y_position=01;
    btn_x_position=0;
    btn_width=w/noOfTab;
    btn_height=HeightTabbar;
   // [self addAllElements];
}

#pragma mark
-(void)OpenpopupClick{
    [UIView animateWithDuration:0.25 animations:^{
        SideMenu.frame = CGRectMake(75, 0, [UIScreen mainScreen].bounds.size.width-75, SideMenu.frame.size.height);
    }];
    
}


#pragma mark
#pragma mark - side menu click
-(void)ClosepopupClick{
    [UIView animateWithDuration:0.25 animations:^{
        SideMenu.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width-75, SideMenu.frame.size.height);
    }];
    
}

-(void)mydataclick{
    LoginVC *obj = [[LoginVC alloc] init];
    [self.navigationController presentViewController:obj animated:YES completion:^{
    }];

}


#pragma mark - Show/Hide TabBar
- (void)showTabBar
{
    
}
- (void)hideTabBar
{
    
}

#pragma mark -Load Nib
- (id)loadViewNib:(NSString *)nibName {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    if([nibs count] > 0) {
        return [nibs objectAtIndex:0];
    }
    return nil;
}
#pragma mark- player delegate method
-(void)pushSettingView
{

}
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:@"outputVolume"]) {
        NSLog(@"volume changed!");

    }
    
}
@end
