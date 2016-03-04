//
//  UITabBarCustom.h
//  iOSCodeStructure
//
//  Created by Nishant
//  Copyright (c) 2013 Ilesh. All rights reserved.
//  This is the main tabar in the Application

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MenuListVC.h"
#import "customTab.h"
#import "MydataVC.h"
#import "AboutVC.h"
#import "FavoriteVC.h"

#define RGB(r, g, b)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a)        [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@class AppDelegate;
@interface UITabBarCustom : UITabBarController <UITabBarControllerDelegate,AFSoundManagerDelegate> {
    AppDelegate *appDelegate;

    MenuListVC *SideMenu;
    

    // Following buttons are taken to behave like TabItems
    UIButton *btnTab1;
    UIButton *btnTab2;
    UIButton *btnTab3;
    UIButton *btnTab4;
    UIButton *btnTab5;
    UIImageView *imgTabBg;
    UIView *bottom_view;
    
    int y_position;
    int btn_x_position;
    int btn_y_position;
    int btn_width;
    int btn_height;
    int HeightTabbar;
    int noOfTab;
    
}
@property (nonatomic, retain) UIButton *btnTab1;
@property (nonatomic, retain) UIButton *btnTab2;
@property (nonatomic, retain) UIButton *btnTab3;
@property (nonatomic, retain) UIButton *btnTab4;
@property (nonatomic, retain) UIButton *btnTab5;
@property (nonatomic, retain) UIImageView *imgTabBg;

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) customTab *customTabobj;


-(void)hideOriginalTabBar;
-(void)addCustomElements;
-(void)addAllElements;
-(UIButton *)getGeneralTabButton:(int)pintTag isSelected:(BOOL)pbolIsSelected;
-(void)selectTab:(int)tabID;
-(void)showTabBar;
-(void)hideTabBar;

@end
