//
//  AboutVC.m
//  MoodVibe
//
//  Created by code-on on 8/10/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC ()

@end

@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setLocalization];
}

-(void)setLocalization{
    if ([self.pagetype isEqualToString:@"About"]) {
       lblHeading.text = LocalizedString(@"KeyAboutHeading", nil);
        tvdesc.text = @"DJ-Matic nv Finlandstraat 11 9940 Evergem VAT BE 0473.014.857 RPR Gent \n\n\n Tel.: +32 (0) 9 220 71 41 \n Fax.: +32 (0) 9 220 73 33 \n info@dj-matic.be";
    }else if ([self.pagetype isEqualToString:@"Disclaimer"]){
       lblHeading.text = LocalizedString(@"KeyDisclaimerHeading", nil);
       tvdesc.text = @"Disclaimer Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    }

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
