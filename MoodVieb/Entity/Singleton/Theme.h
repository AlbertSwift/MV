//
//  Theme.h
//  MoodVibe
//
//  Created by Tops on 9/26/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Theme : NSObject{
    NSMutableDictionary *dictplist;
    NSString *docPath;
}
+ (Theme *)sharedSingleton;

//header
@property(nonatomic,retain)UIColor *headerBgColor;
@property(nonatomic,retain) UIImage *headerLogo;
@property(nonatomic,retain) UIImage *headerPlay;
@property(nonatomic,retain) UIImage *headerPause;
@property(nonatomic,retain) UIImage *headerSkip;
@property(nonatomic,retain) UIImage *headerFav;
@property(nonatomic,retain) UIImage *headerFavSel;
@property(nonatomic,retain) UIImage *headerSide;

//vibe listing.
//images
@property(nonatomic,retain) UIImage *vibeListPlayIcon;
@property(nonatomic,retain) UIImage *vibeListAddIcon;
@property(nonatomic,retain) UIImage *vibeListRemoveIcon;
@property(nonatomic,retain) UIImage *vibeListDownloadIcon;
@property(nonatomic,retain) UIImage *vibeListunDownloadIcon;
@property(nonatomic,retain) UIImage *vibeListMoreIcon;
@property(nonatomic,retain) UIImage *vibeListOfflineIcon;
@property(nonatomic,retain) UIImage *vibeListslider;

//colors
@property(nonatomic,retain)UIColor *vibeListcurrentsongTitleColor;
@property(nonatomic,retain)UIColor *vibeListcurrentsongArtistColor;
@property(nonatomic,retain)UIColor *vibeListPercentageColor;
@property(nonatomic,retain)UIColor *vibeListMoreViewBGColor;
@property(nonatomic,retain)UIColor *vibeListTitleColor;
@property(nonatomic,retain)UIColor *vibeListAddTitleColor;
@property(nonatomic,retain)UIColor *vibeListRemoveTitleColor;
@property(nonatomic,retain)UIColor *vibeListDownloadTitleColor;


//uifonts

@property(nonatomic,retain)UIFont *vibeListcurrentsongTitleFont;
@property(nonatomic,retain)UIFont *vibeListcurrentsongArtistFont;
@property(nonatomic,retain)UIFont *vibeListTitlefont;
@property(nonatomic,retain)UIFont *vibeListPercentagefont;
@property(nonatomic,retain)UIFont *vibeListAddTitlefont;
@property(nonatomic,retain)UIFont *vibeListRemoveTitlefont;
@property(nonatomic,retain)UIFont *vibeListDownloadTitlefont;


//Track listing.
//images
@property(nonatomic,retain) UIImage *TrackListBackIcon;
@property(nonatomic,retain) UIImage *TrackListDownloadIcon;
@property(nonatomic,retain) UIImage *TrackListMoreIcon;
@property(nonatomic,retain) UIImage *TrackListFavIcon;
@property(nonatomic,retain) UIImage *TrackListDislikeIcon;
@property(nonatomic,retain) UIImage *TrackListFavSelIcon;
@property(nonatomic,retain) UIImage *TrackListDislikeSelIcon;
@property(nonatomic,retain) UIImage *TrackListAboutIcon;
@property(nonatomic,retain) UIImage *TrackListMoreSelIcon;

//color
@property(nonatomic,retain)UIColor *TrackListMoreViewBGColor;
@property(nonatomic,retain)UIColor *TrackListcurrentsongTitleColor;
@property(nonatomic,retain)UIColor *TrackListcurrentsongArtistColor;
@property(nonatomic,retain)UIFont *TrackListcurrentsongTitleFont;
@property(nonatomic,retain)UIFont *TrackListcurrentsongArtistFont;

@property(nonatomic,retain)UIColor *TrackListFavTitleColor;
@property(nonatomic,retain)UIFont *TrackListFavTitlefont;

@property(nonatomic,retain)UIColor *TrackListDislikeTitleColor;
@property(nonatomic,retain)UIFont *TrackListDislikeTitlefont;

@property(nonatomic,retain)UIColor *TrackListAboutTitleColor;
@property(nonatomic,retain)UIFont *TrackListAboutTitlefont;

@property(nonatomic,retain)UIColor *TrackListTitleColor;
@property(nonatomic,retain)UIFont *TrackListTitlefont;

@property(nonatomic,retain)UIColor *TrackListArtistColor;
@property(nonatomic,retain)UIFont *TrackListArtistfont;


@end
