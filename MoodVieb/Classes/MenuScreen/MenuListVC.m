//
//  MenuListVC.m
//  IdeaManagemenet
//
//  Created by code-on on 3/11/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import "MenuListVC.h"
#import "AppDelegate.h"
@interface MenuListVC (){
}
@end

@implementation MenuListVC
@synthesize btnAbout,btnClose,btnDisclaimer,btnMyData;
- (void)awakeFromNib
{
    
//    appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [super awakeFromNib];
//   float width = [[UIScreen mainScreen] bounds].size.width - 17;
//    self.frame=CGRectMake(9, 36, width, self.frame.size.height);
//    [self MenuSelection];
    [self setLocalization];
}
-(void)setLocalization{
    [btnMyData setTitle:LocalizedString(@"KeyMenubtnMyData", nil) forState:UIControlStateNormal];
    [btnAbout setTitle:LocalizedString(@"KeyMenubtnAbout", nil) forState:UIControlStateNormal];
    [btnDisclaimer setTitle:LocalizedString(@"KeyMenubtnDisclaimer", nil) forState:UIControlStateNormal];
    
    [btnMyData setBackgroundImage:[self imageWithColor:[[Singleton sharedSingleton] colorFromHexString:@"#211608"]] forState:UIControlStateSelected];
    [btnAbout setBackgroundImage:[self imageWithColor:[[Singleton sharedSingleton] colorFromHexString:@"#211608"]] forState:UIControlStateSelected];
    [btnDisclaimer setBackgroundImage:[self imageWithColor:[[Singleton sharedSingleton] colorFromHexString:@"#211608"]] forState:UIControlStateSelected];
}

#pragma mark
#pragma mark - button click

-(IBAction)btnClick:(id)sender{
    
}

-(void)MenuSelection{
   
}


- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
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
