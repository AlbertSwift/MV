//
//  HomeVC.h
//  MoodVibe
//
//  Created by code-on on 8/7/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VibeShare.h"
#import "tracksShare.h"
#import "VibeCustomCell.h"
#import "TrackVC.h"
#import "FulladsVC.h"
@class AppDelegate;
@interface HomeVC : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *tblview;
    NSMutableArray *aryVibe;
    NSMutableArray *aryAd;
    UIImage *adImage;
   IBOutlet UIImageView *imgView;
    int currentVibe;
    AppDelegate *appdel;
}

@end
