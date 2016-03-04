//
//  LoginVC.h
//  MoodVibe
//
//  Created by code-on on 8/7/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@class  AppDelegate;
@interface LoginVC : UIViewController<UITextFieldDelegate>{
    AppDelegate *appdel;
    IBOutlet UITextField *txtemail;
    IBOutlet UITextField *txtActivation;
    IBOutlet UIButton *btnLogin;
    
    IBOutlet UIImageView *imgBg;
    IBOutlet UIImageView *imgLogo;

}

@end
