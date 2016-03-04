//
//  LoginVC.m
//  MoodVibe
//
//  Created by code-on on 8/7/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    appdel =(AppDelegate *)[[UIApplication sharedApplication] delegate];

#ifdef DEBUG
    txtemail.text =@"test@test.com";
    txtActivation.text =@"test";
#endif

    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:self.class];
    txtemail.layer.borderColor = [[UIColor whiteColor] CGColor];
    txtemail.layer.borderWidth = 1;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
    UIImageView *imgview  = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 15, 13)];
    imgview.image = [UIImage imageNamed:@"mail_icon"];
    [paddingView addSubview:imgview];
    txtemail.leftView = paddingView;
    txtemail.leftViewMode=UITextFieldViewModeAlways;
    [txtemail setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    txtActivation.layer.borderColor = [[UIColor whiteColor] CGColor];
    txtActivation.layer.borderWidth = 1;
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 42, 40)];
    UIImageView *imgview1  = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 14, 18)];
    imgview1.image = [UIImage imageNamed:@"password_icon"];
    [paddingView1 addSubview:imgview1];
    txtActivation.leftView = paddingView1;
    txtActivation.leftViewMode=UITextFieldViewModeAlways;
    [txtActivation setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];

    [btnLogin setTitleShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8] forState:UIControlStateNormal];
    btnLogin.titleLabel.shadowOffset = CGSizeMake(0.0, -2.0);
    [self setLocalization];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[Singleton sharedSingleton] getUserDefault:userEMAIL]!=NULL) {
        appdel.isPopToAllView = 0;
        [appdel gotoDetailApp:0];
        [appdel tabbarselectindex:0];
        [self.navigationController pushViewController:appdel.objCustomTabBar animated:NO];
    }
}

-(void)setLocalization{
    txtemail.placeholder = LocalizedString(@"KeyLoginEmailPlaceholder", nil);
    txtActivation.placeholder = LocalizedString(@"KeyLoginActivationPlaceholder", nil);

    [btnLogin setTitle:LocalizedString(@"KeyLoginbtn", nil) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - button click
-(IBAction)btnLoginClick:(id)sender{
    NSString *email = txtemail.text;
    NSString *activationCode = txtActivation.text;
    if (email.length <=0) {
        //email wrong validation
        [[WebserviceCaller sharedSingleton] AjNotificationView:LocalizedString( @"KeyValidEmailBlank", nil) :AJNotificationTypeRed];
    }else if (activationCode.length<=0){
        //activation code validation
        [[WebserviceCaller sharedSingleton] AjNotificationView:LocalizedString( @"KeyValidActivationBlank", nil)  :AJNotificationTypeRed];
    }else if (![self validEmail:email]) {
        //email wrong validation
        [[WebserviceCaller sharedSingleton] AjNotificationView:LocalizedString( @"KeyValidEmail", nil) :AJNotificationTypeRed];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSMutableDictionary *param =[[NSMutableDictionary alloc] init];
        [param setValue:email forKey:@"email"];
        [param setValue:activationCode forKey:@"code"];
        [[WebserviceCaller sharedSingleton] BaseWsCallPOST:param :@"activation-check/" success:^(id responseData) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            [[Singleton sharedSingleton] setUserDefault:email :userEMAIL];
            [[Singleton sharedSingleton] setUserDefault:activationCode  :activatCode];
            NSDictionary *skin=[responseData objectForKey:@"skin"];
            [self DownloadTheme:[skin objectForKey:@"zipfile"]];
            
        } Failure:^(id responseData) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [[WebserviceCaller sharedSingleton] AjNotificationView:[responseData objectForKey:@"message"] :AJNotificationTypeRed];
        }];
    }
}

-(void)DownloadTheme:(NSString *)zipfileurl{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[WebserviceCaller sharedSingleton] downloadZipFile:zipfileurl success:^(id responseData) {
        NSLog(@"Completed");
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        NSString *documentsDirectory = nil;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];
        
        NSString *zipPath = [NSString stringWithFormat:@"%@/Images.zip",documentsDirectory];
        
        
        NSString *destinationPath = [NSString stringWithFormat:@"%@/Theme/",documentsDirectory];
        [Main unzipFileAtPath:zipPath
                toDestination:destinationPath];
        
        [Theme sharedSingleton];
   
        appdel.isPopToAllView = 0;
        [appdel gotoDetailApp:0];
        [appdel tabbarselectindex:0];
        [self.navigationController pushViewController:appdel.objCustomTabBar animated:YES];
        
        
    } progress:^(float responseData) {
        NSLog(@"%f",responseData);
    } Failure:^{
        NSLog(@"Fail");
    }];
    
    
    
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

#pragma mark
#pragma mark - text field

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO;
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
