//
//  MenuListVC.h
//  IdeaManagemenet
//
//  Created by code-on on 3/11/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;
@interface MenuListVC : UIView{
    AppDelegate *appDel;
}

@property(nonatomic,retain)IBOutlet UIButton *btnClose;
@property(nonatomic,retain)IBOutlet UIButton *btnMyData;
@property(nonatomic,retain)IBOutlet UIButton *btnAbout;
@property(nonatomic,retain)IBOutlet UIButton *btnDisclaimer;
@end
