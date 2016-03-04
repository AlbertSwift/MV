//
//  Theme.m
//  MoodVibe
//
//  Created by Tops on 9/26/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

#import "Theme.h"

@implementation Theme

static Theme *singletonObj = NULL;

+ (Theme *)sharedSingleton {
    @synchronized(self) {
        if (singletonObj == NULL)
            singletonObj = [[self alloc] init];
    }
    return(singletonObj);
}

-(instancetype)init{
    self = [super init];
    if(self)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource: @"Theme" ofType: @"plist"];
       dictplist =[[[NSMutableDictionary alloc] initWithContentsOfFile:path] objectForKey:@"Theme"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        docPath = [documentsDirectory stringByAppendingPathComponent:@"Theme/"];
        [self setupHeader];
        [self setupVibeList];
        [self setupTrackList];
    }
    return self;
}

-(UIFont *)convertFont:(NSString *)fontName :(int)fontSize{
    return [UIFont fontWithName:fontName size:fontSize];
}

//header
-(void)setupHeader{
    
    NSMutableDictionary *headerDict= [dictplist objectForKey:@"Header"];
    self.headerBgColor =[[Singleton sharedSingleton] colorFromHexString:[headerDict objectForKey:@"Header_bgColor"]];
    
    //  Image Name
    self.headerLogo =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/NavigationBar/%@",docPath, [headerDict valueForKey:@"Header_Logo"]]];
    self.headerPlay =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/NavigationBar/%@",docPath, [headerDict valueForKey:@"Header_playIcon"]]];
    
    self.headerPause =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/NavigationBar/%@",docPath, [headerDict valueForKey:@"Header_puaseIcon"]]];
    
    self.headerSkip =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/NavigationBar/%@",docPath, [headerDict valueForKey:@"Header_skipIcon"]]];


    self.headerFav =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/NavigationBar/%@",docPath, [headerDict valueForKey:@"Header_favoriteIcon"]]];

    self.headerFavSel =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/NavigationBar/%@",docPath, [headerDict valueForKey:@"Header_favoriteSelIcon"]]];

    self.headerSide =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/NavigationBar/%@",docPath, [headerDict valueForKey:@"Header_sidebarIcon"]]];
    
}
-(void)setupVibeList{

    NSMutableDictionary *VibeDict= [dictplist objectForKey:@"VibeList"];
     self.vibeListPlayIcon =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/HomeScreen/%@",docPath, [VibeDict valueForKey:@"Vibe_playicon"]]];

    self.vibeListAddIcon =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/HomeScreen/%@",docPath, [VibeDict valueForKey:@"Vibe_addicon"]]];

    self.vibeListRemoveIcon =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/HomeScreen/%@",docPath, [VibeDict valueForKey:@"Vibe_removeicon"]]];

    self.vibeListDownloadIcon =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/HomeScreen/%@",docPath, [VibeDict valueForKey:@"Vibe_downloadicon"]]];

    
    self.vibeListunDownloadIcon =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/HomeScreen/%@",docPath, [VibeDict valueForKey:@"Vibe_undownloadicon"]]];

    
    self.vibeListMoreIcon =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/HomeScreen/%@",docPath, [VibeDict valueForKey:@"Vibe_moreicon"]]];

    self.vibeListOfflineIcon =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/HomeScreen/%@",docPath, [VibeDict valueForKey:@"Vibe_offlineicon"]]];
    
    self.vibeListslider =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/HomeScreen/%@",docPath, [VibeDict valueForKey:@"Vibe_slidericon"]]];

    
    self.vibeListMoreViewBGColor =[[Singleton sharedSingleton] colorFromHexString:[VibeDict objectForKey:@"vibe_MoreViewbgColor"]];
    
    NSMutableDictionary *CurrentSongTitleDic =[VibeDict objectForKey:@"vibe_CurrentSongTitle"];
    self.vibeListcurrentsongTitleColor=[[Singleton sharedSingleton] colorFromHexString:[CurrentSongTitleDic objectForKey:@"color"]];
    self.vibeListcurrentsongTitleFont =[self convertFont:[CurrentSongTitleDic objectForKey:@"font"] :[[CurrentSongTitleDic objectForKey:@"size"] integerValue]];
    
    NSMutableDictionary *CurrentSongArtistDic =[VibeDict objectForKey:@"vibe_CurrentSongArtist"];
    self.vibeListcurrentsongArtistColor=[[Singleton sharedSingleton] colorFromHexString:[CurrentSongArtistDic objectForKey:@"color"]];
    self.vibeListcurrentsongArtistFont =[self convertFont:[CurrentSongArtistDic objectForKey:@"font"] :[[CurrentSongArtistDic objectForKey:@"size"] integerValue]];
    
    
     NSMutableDictionary *TitleDic =[VibeDict objectForKey:@"vibe_Title"];
    self.vibeListTitleColor=[[Singleton sharedSingleton] colorFromHexString:[TitleDic objectForKey:@"color"]];
    self.vibeListTitlefont=[self convertFont:[TitleDic objectForKey:@"font"] :[[TitleDic objectForKey:@"size"] integerValue]];

    
    NSMutableDictionary *PercentageDic =[VibeDict objectForKey:@"vibe_Percentage"];

    self.vibeListPercentageColor=[[Singleton sharedSingleton] colorFromHexString:[PercentageDic objectForKey:@"color"]];
    self.vibeListTitlefont=[self convertFont:[TitleDic objectForKey:@"font"] :[[PercentageDic objectForKey:@"size"] integerValue]];
    
    NSMutableDictionary *AddDic =[VibeDict objectForKey:@"vibe_AddTitle"];
    self.vibeListAddTitleColor=[[Singleton sharedSingleton] colorFromHexString:[AddDic objectForKey:@"color"]];
    self.vibeListAddTitlefont=[self convertFont:[AddDic objectForKey:@"font"] :[[AddDic objectForKey:@"size"] integerValue]];

    
    NSMutableDictionary *RemoveDic =[VibeDict objectForKey:@"vibe_RemoveTitle"];

    self.vibeListRemoveTitleColor=[[Singleton sharedSingleton] colorFromHexString:[RemoveDic objectForKey:@"color"]];
    self.vibeListRemoveTitlefont=[self convertFont:[RemoveDic objectForKey:@"font"] :[[RemoveDic objectForKey:@"size"] integerValue]];

   NSMutableDictionary *DownloadDic =[VibeDict objectForKey:@"vibe_DownloadTitle"];
    self.vibeListDownloadTitleColor=[[Singleton sharedSingleton] colorFromHexString:[DownloadDic objectForKey:@"color"]];
    self.vibeListDownloadTitlefont=[self convertFont:[DownloadDic objectForKey:@"font"] :[[DownloadDic objectForKey:@"size"] integerValue]];
    
}

-(void)setupTrackList{
    
    NSMutableDictionary *VibeDict= [dictplist objectForKey:@"TrackList"];
    
    self.TrackListDownloadIcon =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Trackscreen/%@",docPath, [VibeDict valueForKey:@"track_downloadicon"]]];
    self.TrackListBackIcon =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Trackscreen/%@",docPath, [VibeDict valueForKey:@"track_backicon"]]];
    
    self.TrackListFavIcon =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Trackscreen/%@",docPath, [VibeDict valueForKey:@"track_Favoriteicon"]]];
    
    self.TrackListFavSelIcon =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Trackscreen/%@",docPath, [VibeDict valueForKey:@"track_Favoriteselectedicon"]]];
    
    self.TrackListDislikeIcon =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Trackscreen/%@",docPath, [VibeDict valueForKey:@"track_Dislikeicon"]]];
    
    self.TrackListDislikeSelIcon =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Trackscreen/%@",docPath, [VibeDict valueForKey:@"track_DislikeSelectedicon"]]];
    
    self.TrackListAboutIcon =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Trackscreen/%@",docPath, [VibeDict valueForKey:@"track_AboutArtisticon"]]];
    
    self.TrackListMoreIcon =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/HomeScreen/%@",docPath, [VibeDict valueForKey:@"track_moreicon"]]];

    self.TrackListMoreSelIcon =  [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Trackscreen/%@",docPath, [VibeDict valueForKey:@"track_moreSelicon"]]];
    
    self.TrackListMoreViewBGColor =[[Singleton sharedSingleton] colorFromHexString:[VibeDict objectForKey:@"track_MoreViewbgColor"]];
    
    
    NSMutableDictionary *CurrentSongTitleDic =[VibeDict objectForKey:@"track_CurrentSongTitle"];
    self.TrackListcurrentsongTitleColor=[[Singleton sharedSingleton] colorFromHexString:[CurrentSongTitleDic objectForKey:@"color"]];
    self.TrackListcurrentsongTitleFont =[self convertFont:[CurrentSongTitleDic objectForKey:@"font"] :[[CurrentSongTitleDic objectForKey:@"size"] integerValue]];
    
    NSMutableDictionary *CurrentSongArtistDic =[VibeDict objectForKey:@"track_CurrentSongArtist"];
    self.TrackListcurrentsongArtistColor=[[Singleton sharedSingleton] colorFromHexString:[CurrentSongArtistDic objectForKey:@"color"]];
    self.TrackListcurrentsongArtistFont =[self convertFont:[CurrentSongArtistDic objectForKey:@"font"] :[[CurrentSongArtistDic objectForKey:@"size"] integerValue]];
    


    NSMutableDictionary *FavDic =[VibeDict objectForKey:@"track_Favorite"];
    self.TrackListFavTitleColor=[[Singleton sharedSingleton] colorFromHexString:[FavDic objectForKey:@"color"]];
    self.TrackListFavTitlefont=[self convertFont:[FavDic objectForKey:@"font"] :[[FavDic objectForKey:@"size"] integerValue]];
    
    
    NSMutableDictionary *LikeDic =[VibeDict objectForKey:@"track_Dislike"];
    self.TrackListDislikeTitleColor=[[Singleton sharedSingleton] colorFromHexString:[LikeDic objectForKey:@"color"]];
    self.TrackListDislikeTitlefont=[self convertFont:[LikeDic objectForKey:@"font"] :[[LikeDic objectForKey:@"size"] integerValue]];
    
    NSMutableDictionary *AboutDic =[VibeDict objectForKey:@"track_About"];
    self.TrackListAboutTitleColor=[[Singleton sharedSingleton] colorFromHexString:[AboutDic objectForKey:@"color"]];
    self.TrackListAboutTitlefont=[self convertFont:[AboutDic objectForKey:@"font"] :[[AboutDic objectForKey:@"size"] integerValue]];
    
    NSMutableDictionary *TitleDic =[VibeDict objectForKey:@"track_Title"];
    self.TrackListTitleColor=[[Singleton sharedSingleton] colorFromHexString:[TitleDic objectForKey:@"color"]];
    self.TrackListTitlefont=[self convertFont:[TitleDic objectForKey:@"font"] :[[TitleDic objectForKey:@"size"] integerValue]];
    
    NSMutableDictionary *AristDic =[VibeDict objectForKey:@"track_Artist"];
    self.TrackListArtistColor=[[Singleton sharedSingleton] colorFromHexString:[AristDic objectForKey:@"color"]];
    self.TrackListArtistfont=[self convertFont:[AristDic objectForKey:@"font"] :[[AristDic objectForKey:@"size"] integerValue]];
    
}
@end
