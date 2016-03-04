//
//  customTab.m
//  MoodVibe
//
//  Created by code-on on 8/7/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import "customTab.h"

@implementation customTab
@synthesize btnPopup,btnFavorite,btnPause,btnPlay;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    // Drawing code

}
	
-(void)setupThame{
    [self setBackgroundColor:[Theme sharedSingleton].headerBgColor];
    self.imgCenterLogo.image =[Theme sharedSingleton].headerLogo;

    [self.btnPlay setImage:[Theme sharedSingleton].headerPlay forState:UIControlStateNormal];
    [self.btnPause setImage:[Theme sharedSingleton].headerPause forState:UIControlStateNormal];
    [self.btnSkip setImage:[Theme sharedSingleton].headerSkip forState:UIControlStateNormal];
    
    [self.btnPopup setImage:[Theme sharedSingleton].headerSide forState:UIControlStateNormal];
    [self.btnFavorite setImage:[Theme sharedSingleton].headerFav forState:UIControlStateNormal];
    [self.btnFavorite setImage:[Theme sharedSingleton].headerFavSel forState:UIControlStateHighlighted];
}

@end
