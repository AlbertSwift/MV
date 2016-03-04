//
//  FavoriteVC.h
//  MoodVibe
//
//  Created by code-on on 8/28/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackCustomCell.h"
@class  AppDelegate;
@interface FavoriteVC : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *tblView;
    IBOutlet UILabel *lblTrackTitle;
    IBOutlet UIImageView *imgviebvertical;
    IBOutlet UIImageView *imgAdBannr;
    IBOutlet UIImage *adImage;
    IBOutlet UILabel *lblCurrentSongTitle;
    IBOutlet UILabel *lblCurrentSongArtist;
    IBOutlet UIButton *btnBack;
    AppDelegate *appdel;
}
@property(nonatomic,retain)NSArray *aryTrack;
@property(nonatomic,retain)NSString *Tracktitle;
@property(nonatomic,retain)NSString *verticalImage;

@end
