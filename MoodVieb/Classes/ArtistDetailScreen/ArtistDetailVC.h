//
//  ArtistDetailVC.h
//  MoodVibe
//
//  Created by code-on on 8/11/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtistDetailVC : UIViewController{
    IBOutlet UILabel *lblArtistName;
    IBOutlet UIImageView *imgArtist;
    IBOutlet UITextView *tvDesc;
}

@property(nonatomic,retain)NSString *strArtistid;
@end
