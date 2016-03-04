//
//  VibeCustomCell.h
//  MoodVibe
//
//  Created by code-on on 8/10/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VibeShare.h"
#import "RS_SliderView.h"

@class AppDelegate;
@interface VibeCustomCell : UITableViewCell <RSliderViewDelegate>{
    
    IBOutlet UIView *sliderView;
    //RS_SliderView *horSlider;
    BOOL isAddClick;
    AppDelegate *appDel;
    
}
@property(nonatomic,retain)IBOutlet UIImageView *imgCoveerPic;
@property(nonatomic,retain)IBOutlet UIImageView *imglogoPic;
@property(nonatomic,retain)IBOutlet UIButton *btnDownload;

@property(nonatomic,retain)IBOutlet UILabel *lblTitle;
@property(nonatomic,retain)IBOutlet UILabel *lblpercentage;
@property(nonatomic,retain)RS_SliderView *horSlider;

@property(nonatomic,retain) VibeShare *shareObj;
@property(nonatomic,retain)IBOutlet UIButton *btnAddPlaylist;
@property(nonatomic,retain)IBOutlet UIButton *btnRemovePlaylist;
@property(nonatomic,retain)IBOutlet UIButton *btnDownloadVieb;
@property(nonatomic,retain)IBOutlet UIButton *btnunChacheVieb;
@property(nonatomic,retain)IBOutlet UIButton *btnMore;
@property(nonatomic,retain)IBOutlet UIButton *btnpercantage;
@property(nonatomic,retain)IBOutlet UIImageView *imgpercantage;
@property(nonatomic,retain)IBOutlet UIView *moreView;;
@property(nonatomic,assign)int customTag;

@property(nonatomic,retain)IBOutlet UILabel *lblCurrentSongTitle;

@property(nonatomic,retain)IBOutlet UILabel *lblCurrentSongArtist;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreviewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreviewHeightCon;
@property (nonatomic,retain)IBOutlet MBCircularProgressBarView *progressbar;

-(void)ApplyData;
@end
