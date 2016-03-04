//
//  MydataVC.m
//  MoodVibe
//
//  Created by code-on on 8/8/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import "MydataVC.h"

@interface MydataVC () <PickerViewNewDelegate>

@end

@implementation MydataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:self.class];
    [self setLocalization];

    txtname.layer.borderColor = [[UIColor whiteColor] CGColor];
    txtname.layer.borderWidth = 1;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    txtname.leftView = paddingView;
    txtname.leftViewMode=UITextFieldViewModeAlways;
    [txtname setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    txtname.text =[[Singleton sharedSingleton] getUserDefault:@"name"];
    
    txtemail.layer.borderColor = [[UIColor whiteColor] CGColor];
    txtemail.layer.borderWidth = 1;
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    txtemail.leftView = paddingView1;
    txtemail.leftViewMode=UITextFieldViewModeAlways;
    [txtemail setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    txtemail.text =[[Singleton sharedSingleton] getUserDefault:userEMAIL];
    btngender.layer.borderColor = [[UIColor whiteColor] CGColor];
    btngender.layer.borderWidth = 1;
    
    NSString *strgender = [[Singleton sharedSingleton] getUserDefault:@"gender"];
    if ([strgender isEqualToString:@"m"]) {
        strgender =@"Male";
    }else if ([strgender isEqualToString:@"f"]){
        strgender =@"Female";
    }else{
        strgender =@"Gender";
    }

    [btngender setTitle:strgender forState:UIControlStateNormal];
    btngender.titleLabel.text = strgender;
    
    btnage.layer.borderColor = [[UIColor whiteColor] CGColor];
    btnage.layer.borderWidth = 1;

    NSNumber *strage =(NSNumber *) [[Singleton sharedSingleton] getUserDefault:@"age"];
    NSString *strAge;
    if (strage == nil) {
        strAge =@"Age";
    }else{
        strAge = [strage stringValue];
    }
    [btnage setTitle:strAge forState:UIControlStateNormal];
    btnage.titleLabel.text = [strage stringValue];
    
    [btnSubmit setTitleShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8] forState:UIControlStateNormal];
    btnSubmit.titleLabel.shadowOffset = CGSizeMake(0.0, -2.0);
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self setLocalization];

    
    [self PickerViewHide];

}
-(void)setLocalization{
    lblHeading.text = LocalizedString(@"KeyMyDataHeading", nil);
    txtname.placeholder = LocalizedString(@"KeyMyDatatxtName", nil);
    txtemail.placeholder = LocalizedString(@"KeyMyDatatxtEmail", nil);
    
    [btngender setTitle: LocalizedString(@"KeyMyDatabtnGender", nil) forState:UIControlStateNormal];

    [btnage setTitle: LocalizedString(@"KeyMyDatabtnAge", nil) forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark
#pragma mark - button click
-(IBAction)btnClose:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
-(IBAction)btnGenderClick:(id)sender{
    [self.view endEditing:YES];
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"PickerView" owner:nil options:nil];
    pickerViewObj =[subviewArray objectAtIndex:0];
    [pickerViewObj setFrame:ViewPick.bounds];
    [pickerViewObj IsDatePickerView:NO];
    pickerViewObj.arrdata=[@[@"Male",@"Female"]mutableCopy];
    NSString *strgender = [[Singleton sharedSingleton] getUserDefault:@"gender"];
    if ([strgender isEqualToString:@"m"]) {
        pickerViewObj.selectedIndex =0;
    }else if ([strgender isEqualToString:@"f"]){
        pickerViewObj.selectedIndex =1;
    }
    pickerViewObj.Delegate=self;
    [pickerViewObj.pickerCountry reloadAllComponents];
    [ViewPick addSubview:pickerViewObj];
    [self PickerViewShow];

}

-(IBAction)btnAgeClick:(id)sender{
    [self.view endEditing:YES];
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"PickerView" owner:nil options:nil];
    pickerViewObj =[subviewArray objectAtIndex:0];
    [pickerViewObj setFrame:ViewPick.bounds];
    [pickerViewObj IsDatePickerView:NO];
    NSMutableArray *aryAge = [[NSMutableArray alloc] init];
    for (int i =18; i<=80; i++) {
        [aryAge addObject:[NSString stringWithFormat:@"%d",i]];
    }
    pickerViewObj.arrdata=aryAge;
    pickerViewObj.selectedIndex = [[[Singleton sharedSingleton] getUserDefault:@"age"] intValue]-18;
    pickerViewObj.Delegate=self;
    [pickerViewObj.pickerCountry reloadAllComponents];
    [ViewPick addSubview:pickerViewObj];
    [self PickerViewShow];
}

-(IBAction)btnSubmit:(id)sender{

    NSString *email = txtemail.text;
    NSString *name = txtname.text;
    NSString *gender = [btngender titleForState:UIControlStateNormal];
    NSString *Age = [btnage titleForState:UIControlStateNormal];
    int age = [Age intValue];
    if (name.length <=0) {
        //email wrong validation
        [[WebserviceCaller sharedSingleton] AjNotificationView:LocalizedString( @"KeyValidNameBlank", nil) :AJNotificationTypeRed];
    }else if (email.length <=0) {
        //email wrong validation
        [[WebserviceCaller sharedSingleton] AjNotificationView:LocalizedString( @"KeyValidEmailBlank", nil) :AJNotificationTypeRed];
    }else if (name.length<=0){
        //activation code validation
        [[WebserviceCaller sharedSingleton] AjNotificationView:LocalizedString( @"KeyValidActivationBlank", nil)  :AJNotificationTypeRed];
    }else if (![self validEmail:email]) {
        //email wrong validation
        [[WebserviceCaller sharedSingleton] AjNotificationView:LocalizedString( @"KeyValidEmail", nil) :AJNotificationTypeRed];
    }else{
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:email forKey:@"email"];
        [param setObject:name forKey:@"name"];
        if ([gender isEqualToString:@"Male"]) {
            [param setObject:@"m" forKey:@"gender"];
        }else if ([gender isEqualToString:@"Female"]){
            [param setObject:@"f" forKey:@"gender"];

        }
        [param setObject:[NSString stringWithFormat:@"%d",age] forKey:@"age"];
        
        [[WebserviceCaller sharedSingleton] BaseWsCallPOST:param :@"personal-details/" success:^(id responseData) {
            NSLog(@"Sucess");
            
            [[Singleton sharedSingleton] setUserDefault:[responseData objectForKey:@"age"] :@"age"];
            [[Singleton sharedSingleton] setUserDefault:[responseData objectForKey:@"gender"] :@"gender"];
            [[Singleton sharedSingleton] setUserDefault:[responseData objectForKey:@"name"] :@"name"];

            [[WebserviceCaller sharedSingleton] AjNotificationView:@"Data Save Successfully" :AJNotificationTypeGreen];
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        } Failure:^(id responseData) {
            NSLog(@"Fail");
        }];
    }
}
#pragma mark - validation
- (BOOL) validEmail:(NSString*) emailString {
    if([emailString length]==0){
        return NO;
    }
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark -piker controller
-(void)PickerViewSelectedValues:(NSString *)str
{
    [self PickerViewHide];

}
-(void)PickerViewSelectedValuesAndID:(NSString *) str_Name :(NSString *)value
{
    if ([str_Name isEqualToString:@"Male"] || [str_Name isEqualToString:@"Female"]) {
        [btngender setTitle:str_Name forState:UIControlStateNormal];
    }else{
        [btnage setTitle:str_Name forState:UIControlStateNormal];
    }
    
    [self PickerViewHide];
}
-(void)PickerCancelClick
{
    [self PickerViewHide];
}
-(void)PickerViewHide{
    ViewPick.hidden=YES;
    int y = 10000;
    [self setFrameofView:y :ViewPick];
    [pickerViewObj removeFromSuperview];
}
-(void)PickerViewShow{
    ViewPick.hidden=NO;
    int y =[UIScreen mainScreen].bounds.size.height-ViewPick.frame.size.height;
    [self setFrameofView:y :ViewPick];
    
}
-(void)setFrameofView :(int)yPosition :(UIView *)viewObj
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    viewObj.frame = CGRectMake(viewObj.frame.origin.x,yPosition, viewObj.frame.size.width, viewObj.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
