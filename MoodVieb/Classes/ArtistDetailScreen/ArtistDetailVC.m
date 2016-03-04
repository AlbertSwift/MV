//
//  ArtistDetailVC.m
//  MoodVibe
//
//  Created by code-on on 8/11/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import "ArtistDetailVC.h"

@interface ArtistDetailVC ()

@end

@implementation ArtistDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    imgArtist.layer.cornerRadius = imgArtist.layer.frame.size.width/2;
    imgArtist.layer.masksToBounds = YES;
    
    NSString *url =[NSString stringWithFormat:@"artist/%@/",self.strArtistid];
    [[WebserviceCaller sharedSingleton] BaseWsCallGET:nil :url success:^(id responseData) {
        
        tvDesc.text = [responseData objectForKey:@"description"];
        lblArtistName.text =[responseData objectForKey:@"name"];
        __block UIImageView *temp = imgArtist;
        [imgArtist setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[responseData objectForKey:@"image"]]] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            temp.image = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        }];
        
    } Failure:^(id responseData) {
    }];
    
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
