//
//  AboutVC.h
//  MoodVibe
//
//  Created by code-on on 8/10/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutVC : UIViewController{
    IBOutlet UILabel *lblHeading;
    IBOutlet UITextView *tvdesc;

}
@property(nonatomic,retain)NSString *pagetype;
@end
