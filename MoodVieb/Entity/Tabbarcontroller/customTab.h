//
//  customTab.h
//  MoodVibe
//
//  Created by code-on on 8/7/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customTab : UIView{
    
}
@property(nonatomic,retain)IBOutlet UIButton *btnPopup;
@property(nonatomic,retain)IBOutlet UIButton *btnPlay;
@property(nonatomic,retain)IBOutlet UIButton *btnPause;
@property(nonatomic,retain)IBOutlet UIButton *btnSkip;
@property(nonatomic,retain)IBOutlet UIButton *btnFavorite;
@property(nonatomic,retain)IBOutlet UILabel *lblPer;
@property(nonatomic,retain)IBOutlet UIImageView *imgCenterLogo;
-(void)setupThame;
@end
