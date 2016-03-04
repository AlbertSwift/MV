//
//  TrackVC.h
//  MoodVibe
//
//  Created by code-on on 8/11/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackCustomCell.h"
@interface TrackVC : UIViewController<UITableViewDataSource,UITableViewDelegate>{

    IBOutlet UITableView *tblView;
    IBOutlet UILabel *lblTrackTitle;
    IBOutlet UIImageView *imgviebvertical;
    IBOutlet UIImageView *imgAdBannr;
    IBOutlet UIImage *adImage;
    IBOutlet UILabel *lblCurrentSongTitle;
    IBOutlet UILabel *lblCurrentSongArtist;
    IBOutlet UIButton *btnDownload;
    IBOutlet UIButton *btnBack;
    
}
@property(nonatomic,retain)NSArray *aryTrack;
@property(nonatomic,retain)NSString *Tracktitle;
@property(nonatomic,retain)NSString *verticalImage;
@property(nonatomic,retain)NSString *viebId;
@end
