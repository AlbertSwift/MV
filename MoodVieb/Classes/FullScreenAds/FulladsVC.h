//
//  FulladsVC.h
//  MoodVibe
//
//  Created by code-on on 8/10/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FulladsVC : UIViewController{
    IBOutlet UIImageView *imgAd;
    IBOutlet UIButton *btnClose;
}
@property(nonatomic,retain)UIImage *adImage;
@end
