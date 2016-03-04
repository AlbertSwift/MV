//
//  TrackCustomCell.h
//  MoodVibe
//
//  Created by code-on on 8/11/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tracksShare.h"
#import "ArtistDetailVC.h"
@interface TrackCustomCell : UITableViewCell{

    IBOutlet UIImageView *imgCoveerPic;
    IBOutlet UIImageView *imgIsDislikeView;
}
@property(nonatomic,retain)IBOutlet UIImageView *imgCoveerPic;
@property(nonatomic,retain)IBOutlet UILabel *lblTitle;
@property(nonatomic,retain)IBOutlet UILabel *lblArtist;
@property(nonatomic,retain) tracksShare *shareObj;
@property(nonatomic,retain)IBOutlet UIView *moreview;
@property(nonatomic,retain)IBOutlet UIButton *btnMore;
@property(nonatomic,retain)IBOutlet UIButton *btnHideMore;


@property(nonatomic,retain)IBOutlet UIButton *btnFavorite;
@property(nonatomic,retain)IBOutlet UIButton *btnLike;
@property(nonatomic,retain)IBOutlet UIButton *btnAbout;
@property(nonatomic,retain)IBOutlet NSString *strIsFromFav;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constTop;

-(void)ApplyData;
@end
