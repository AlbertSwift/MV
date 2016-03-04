//
//  PickerView.h
//  Parlez
//
//  Created by code-on on 16/03/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerViewNewDelegate <NSObject>
-(void)PickerViewSelectedValues:(NSString *)str;
-(void)PickerViewSelectedValuesAndID:(NSString *) str_Name :(NSString *)value;
-(void)PickerCancelClick;

@end
@interface PickerView : UIView
{
    NSMutableArray *arrdata;
}
@property (strong, nonatomic) IBOutlet UIPickerView  * pickerCountry;
@property (strong, nonatomic)  NSMutableArray *arrdata;
@property (assign) int selectedIndex;
@property (strong, nonatomic) id <PickerViewNewDelegate> Delegate;

-(IBAction)btnCancelClick:(id)sender;
-(IBAction)btnDoneClick:(id)sender;

-(void)IsDatePickerView:(BOOL)value;
@end
