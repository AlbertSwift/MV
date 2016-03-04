//
//  PickerView.m
//  Parlez
//
//  Created by code-on on 16/03/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import "PickerView.h"

@interface PickerView ()
{
    BOOL isDatePicker;
    UIDatePicker *datePicker;
}

@end

@implementation PickerView
@synthesize pickerCountry,arrdata,selectedIndex;

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
}
-(void)IsDatePickerView:(BOOL)value
{
    
    isDatePicker=value;
    if (value)
    {
        pickerCountry.hidden=YES;
        datePicker = [[UIDatePicker alloc]initWithFrame:pickerCountry.frame];
        [datePicker setDate:[NSDate date]];
        [datePicker setDatePickerMode:UIDatePickerModeDate];
    
        datePicker.maximumDate=[NSDate date];
        //[datePicker addTarget:self action:@selector(updateBirthdateField:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:datePicker];
    }
    else
    {
        [datePicker removeFromSuperview];
        [pickerCountry selectRow:selectedIndex inComponent:0 animated:YES];
        pickerCountry.hidden=NO;
    }
}
-(void)awakeFromNib
{
    
}
// --------------------------------------------------------------------

#pragma mark - UIPickerView DataSource Methods

// --------------------------------------------------------------------

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// --------------------------------------------------------------------


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //[pickerView selectRow:13 inComponent:0 animated:NO];
    return [arrdata count];
}

// --------------------------------------------------------------------

#pragma mark - UIPickerView Delegate Methods

// --------------------------------------------------------------------

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

// --------------------------------------------------------------------
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
//    DropDownlist *data = [arrdata objectAtIndex:row];
    return arrdata[row];
//return @"heloo";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    DropDownlist *data = [arrdata objectAtIndex:row];
//    NSLog(@"%@",data.strTitle);
}
#pragma Mark -Button ACtion
-(IBAction)btnCancelClick:(id)sender
{
    [self.Delegate PickerCancelClick];
}
-(IBAction)btnDoneClick:(id)sender
{
    if (isDatePicker)
    {
        NSDate *date = datePicker.date;
        NSDateFormatter * _dateFormat = [[NSDateFormatter alloc]init];
        [_dateFormat setDateFormat:@"MM/dd/yyyy"];
        [self.Delegate PickerViewSelectedValues:[_dateFormat stringFromDate:date]];
    }
    else
    {
        NSInteger index = [pickerCountry selectedRowInComponent:0];
//        DropDownlist *data = [arrdata objectAtIndex:index];
        [self.Delegate PickerViewSelectedValuesAndID:arrdata[index] :nil];
    }
    
}
@end
