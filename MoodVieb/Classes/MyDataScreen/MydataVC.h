//
//  MydataVC.h
//  MoodVibe
//
//  Created by code-on on 8/8/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "PickerView.h"
@interface MydataVC : UIViewController<UITextFieldDelegate>{
    IBOutlet UILabel *lblHeading;
    IBOutlet UITextField *txtname;
    IBOutlet UITextField *txtemail;
    IBOutlet UIButton *btngender;
    IBOutlet UIButton *btnage;
    IBOutlet UIButton *btnSubmit;
    PickerView *pickerViewObj;
    IBOutlet UIView *ViewPick;
}

@end
