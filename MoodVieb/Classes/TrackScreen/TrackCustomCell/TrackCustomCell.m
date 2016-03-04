//
//  TrackCustomCell.m
//  MoodVibe
//
//  Created by code-on on 8/11/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import "TrackCustomCell.h"

@implementation TrackCustomCell
@synthesize imgCoveerPic,lblTitle,lblArtist,shareObj,btnAbout,btnFavorite,btnLike,moreview;
- (void)awakeFromNib {
    // Initialization code
    
    if (g_IS_IOS_8) {
        self.contentView.preservesSuperviewLayoutMargins = NO;
    }
    
    moreview.alpha = 0;
    moreview.hidden = true;
    
    
    [btnFavorite setTitle:LocalizedString(@"KeyTrackbtnFavorite", nil) forState:UIControlStateNormal];
   /* [btnLike setTitle:LocalizedString(@"KeyTrackbtnLike", nil) forState:UIControlStateNormal];
    [btnAbout setTitle:LocalizedString(@"KeyTrackbtnAbout", nil) forState:UIControlStateNormal];
*/    [self setupThame];
    UITapGestureRecognizer *showhide =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(Hidemoreviewclick)];
    [moreview addGestureRecognizer:showhide];

}

-(void)setupThame{
    [self.btnMore setImage:[Theme sharedSingleton].TrackListMoreIcon forState:UIControlStateNormal];
   [self.btnHideMore setImage:[Theme sharedSingleton].TrackListMoreSelIcon forState:UIControlStateNormal];

    
    [self.btnFavorite setBackgroundImage:[Theme sharedSingleton].TrackListFavIcon forState:UIControlStateNormal];
    [self.btnFavorite setBackgroundImage:[Theme sharedSingleton].TrackListFavSelIcon forState:UIControlStateNormal];
    
    [self.btnLike setBackgroundImage:[Theme sharedSingleton].TrackListDislikeIcon forState:UIControlStateNormal];
    [self.btnLike setBackgroundImage:[Theme sharedSingleton].TrackListDislikeSelIcon forState:UIControlStateNormal];
    
    [self.btnAbout setBackgroundImage:[Theme sharedSingleton].TrackListAboutIcon forState:UIControlStateNormal];

    [self.moreview setBackgroundColor:[Theme sharedSingleton].TrackListMoreViewBGColor];
    
    [self.btnFavorite setTitleColor:[Theme sharedSingleton].TrackListFavTitleColor forState:UIControlStateNormal];
    [self.btnFavorite.titleLabel setFont:[Theme sharedSingleton].TrackListFavTitlefont];
    
    
    [self.btnLike setTitleColor:[Theme sharedSingleton].TrackListDislikeTitleColor forState:UIControlStateNormal];
    [self.btnLike.titleLabel setFont:[Theme sharedSingleton].TrackListDislikeTitlefont];
    
    
    [self.btnAbout setTitleColor:[Theme sharedSingleton].TrackListAboutTitleColor forState:UIControlStateNormal];
    [self.btnAbout.titleLabel setFont:[Theme sharedSingleton].TrackListAboutTitlefont];
    
    self.lblArtist.textColor =[Theme sharedSingleton].TrackListArtistColor;
    self.lblArtist.font = [Theme sharedSingleton].TrackListArtistfont;

    self.lblTitle.textColor =[Theme sharedSingleton].TrackListTitleColor;
    self.lblTitle.font = [Theme sharedSingleton].TrackListTitlefont;

    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)ApplyData{
     lblTitle.text = [shareObj.title uppercaseString];
    lblArtist.text = shareObj.artist;
    if ([[WebserviceCaller sharedSingleton] isconnectedToNetwork]) {
        if ([[Singleton sharedSingleton]CheckLocalImage:shareObj.artist_image_offline]) {
            [imgCoveerPic setImage:[[Singleton sharedSingleton] getLocalImage:shareObj.artist_image_offline]];
            
        }else{
            
        __block UIImageView *temp = imgCoveerPic;
        [imgCoveerPic setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:shareObj.artist_image]] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            temp.image = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        }];
        }
    }else{
        [imgCoveerPic setImage:[[Singleton sharedSingleton] getLocalImage:shareObj.artist_image_offline]];

    }
    
    if (shareObj.is_favorite == 1) {
//[btnFavorite setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
         [btnFavorite setBackgroundImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
    }else if (shareObj.is_favorite == 0){
        //[btnFavorite setImage:[UIImage imageNamed:@"un-favorite"] forState:UIControlStateNormal];
         [btnFavorite setBackgroundImage:[UIImage imageNamed:@"un-favorite"] forState:UIControlStateNormal];
    }
    
    if(shareObj.is_favorite == 1){
        btnLike.enabled = NO;
    }else{
        btnLike.enabled = YES;
    }

    
    
    if (shareObj.is_dislike == 1) {
       // [btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [btnLike setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
       //imgIsDislikeView.image =[self blurBackgroundImage:imgCoveerPic.image];
        [imgIsDislikeView setHidden:NO];
        [btnLike setTitle:LocalizedString(@"KeyTrackbtnLike", nil) forState:UIControlStateNormal];
        btnFavorite.enabled = NO;
        
    }else if (shareObj.is_dislike == 0){
       // [btnLike setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
        [btnLike setBackgroundImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];

        [imgIsDislikeView setHidden:YES];
        [btnLike setTitle:LocalizedString(@"KeyTrackbtnDisLike", nil) forState:UIControlStateNormal];
        btnFavorite.enabled = YES;

    }
    moreview.alpha = 0;
    moreview.hidden = true;
    
}

-(IBAction)btnMoreClick:(id)sender{
    
    int oldMoreClick=[Singleton sharedSingleton].currentTrackMoreClick;
    if (oldMoreClick!=-1 && oldMoreClick != [sender tag]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ReloadSingleCell object:nil userInfo:nil];
    }
    
    moreview.alpha = 0;
    moreview.hidden = true;
    
    CGRect frame = moreview.frame;
    frame.size.height = 0;
    frame.origin.y = 110;
    moreview.frame = frame;

    
    CGRect btnLikeframe = self.btnLike.frame;
    btnLikeframe.size.height=0;
    btnLikeframe.origin.y =20;
    self.btnLike.frame = btnLikeframe;
    self.btnLike.alpha = 0;


    CGRect btnFavoriteframe = self.btnFavorite.frame;
    btnFavoriteframe.size.height=0;
    btnFavoriteframe.origin.y =20;
    self.btnFavorite.frame = btnFavoriteframe;
    self.btnFavorite.alpha = 0;

    CGRect btnAboutframe = self.btnAbout.frame;
    btnAboutframe.size.height=0;
    btnAboutframe.origin.y =20;
    self.btnAbout.frame = btnAboutframe;
    self.btnAbout.alpha = 0;
    
    self.btnHideMore.alpha=0;
   [UIView animateWithDuration:0.5 animations:^{
       moreview.alpha = 1;
       moreview.hidden = false;
       CGRect frame = moreview.frame;
       frame.size.height = 110;
       frame.origin.y = 0;
       moreview.frame = frame;
       
       CGRect btnLikeframe = self.btnLike.frame;
       btnLikeframe.size.height=56;
       btnLikeframe.origin.y =20;
       self.btnLike.frame = btnLikeframe;
       self.btnLike.alpha = 1;

       CGRect btnFavoriteframe = self.btnFavorite.frame;
       btnFavoriteframe.size.height=56;
       btnFavoriteframe.origin.y =20;
       self.btnFavorite.frame = btnFavoriteframe;
       self.btnFavorite.alpha = 1;
       
       CGRect btnAboutframe = self.btnAbout.frame;
       btnAboutframe.size.height=56;
       btnAboutframe.origin.y =20;
       self.btnAbout.frame = btnAboutframe;
       self.btnAbout.alpha = 1;
       self.btnHideMore.alpha=1;
       
        [moreview layoutIfNeeded];
    }completion:^(BOOL finished) {
        moreview.hidden = false;

    }];
    
    if (oldMoreClick!=-1 && oldMoreClick == [sender tag]) {
    
       [Singleton sharedSingleton].currentTrackMoreClick = -1;
        
    }else{
       
        [Singleton sharedSingleton].currentTrackMoreClick = [sender tag];

    }
    
    
}
-(IBAction)btnMoreHideClick:(id)sender{
    moreview.alpha = 1;
    moreview.hidden = false;
    
    moreview.alpha = 1;
    moreview.hidden = false;
    CGRect frame = moreview.frame;
    frame.size.height = 110;
    frame.origin.y = 0;
    moreview.frame = frame;
    
    CGRect btnLikeframe = self.btnLike.frame;
    btnLikeframe.size.height=56;
    btnLikeframe.origin.y =20;
    self.btnLike.frame = btnLikeframe;
    self.btnLike.alpha = 1;
    
    CGRect btnFavoriteframe = self.btnFavorite.frame;
    btnFavoriteframe.size.height=56;
    btnFavoriteframe.origin.y =20;
    self.btnFavorite.frame = btnFavoriteframe;
    self.btnFavorite.alpha = 1;
    
    CGRect btnAboutframe = self.btnAbout.frame;
    btnAboutframe.size.height=56;
    btnAboutframe.origin.y =20;
    self.btnAbout.frame = btnAboutframe;
    self.btnAbout.alpha = 1;
    self.btnHideMore.alpha=0;

    [UIView animateWithDuration:0.5 animations:^{
        [moreview layoutIfNeeded];
        CGRect frame = moreview.frame;
        frame.size.height = 00;
        frame.origin.y = 110;
        moreview.frame = frame;
        
        CGRect btnLikeframe = self.btnLike.frame;
        btnLikeframe.size.height=0;
        btnLikeframe.origin.y =20;
        self.btnLike.frame = btnLikeframe;
        self.btnLike.alpha = 0;
        
        CGRect btnFavoriteframe = self.btnFavorite.frame;
        btnFavoriteframe.size.height=0;
        btnFavoriteframe.origin.y =20;
        self.btnFavorite.frame = btnFavoriteframe;
        self.btnFavorite.alpha = 0;
        
        CGRect btnAboutframe = self.btnAbout.frame;
        btnAboutframe.size.height=0;
        btnAboutframe.origin.y =20;
        self.btnAbout.frame = btnAboutframe;
        self.btnAbout.alpha = 0;
        
    }completion:^(BOOL finished) {
        moreview.hidden = true;
    }];

    
    int oldMoreClick=[Singleton sharedSingleton].currentTrackMoreClick;
    
    if (oldMoreClick!=-1 && oldMoreClick == [sender tag]) {
        [Singleton sharedSingleton].currentTrackMoreClick = -1;
        
    }else{
        [Singleton sharedSingleton].currentTrackMoreClick = [sender tag];
        
    }
    
}


-(void)Hidemoreviewclick{
    [self.btnHideMore sendActionsForControlEvents:UIControlEventTouchUpInside];
}
-(IBAction)btnFavClick:(id)sender{
    if(![[WebserviceCaller sharedSingleton] isconnectedToNetwork]){
        [[WebserviceCaller sharedSingleton] AjNotificationView:LocalizedString(@"KeyErrorInternet", nil) :AJNotificationTypeRed];
        return;
    }
    
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  [dict setObject:[[Singleton sharedSingleton] getUserDefault:userEMAIL] forKey:@"email"];
  [dict setObject:[[Singleton sharedSingleton] getUserDefault:activatCode] forKey:@"code"];
  [dict setObject:shareObj.tracksShare_id forKey:@"track"];
    if (shareObj.is_favorite == 1) {
        
        //remove favorite track
        [[DataManager shareddbSingleton] updateFav:shareObj.tracksShare_id :@"0" :@"1"];
        shareObj.is_favorite = 0;
        //[btnFavorite setImage:[UIImage imageNamed:@"un-favorite"] forState:UIControlStateNormal];
        [btnFavorite setBackgroundImage:[UIImage imageNamed:@"un-favorite"] forState:UIControlStateNormal];
        [[DataManager shareddbSingleton] favTrack:shareObj.tracksShare_id :@"0"];
       

        if ([[WebserviceCaller sharedSingleton] isconnectedToNetwork]) {
            [[WebserviceCaller sharedSingleton] BaseWsCallPOST:dict :@"remove-favorite/" success:^(id responseData) {
                [self.btnHideMore sendActionsForControlEvents:UIControlEventTouchUpInside];
            [[DataManager shareddbSingleton] updateFav:shareObj.tracksShare_id :@"0" :@"0"];
            btnFavorite.enabled =YES;
            btnLike.enabled = YES;
                 [[NSNotificationCenter defaultCenter] postNotificationName:ReloadFavTable object:nil userInfo:nil];
            } Failure:^(id responseData) {
                btnFavorite.enabled =YES;
            }];
        }
        
    }else if (shareObj.is_favorite == 0){
        //add into favorite
        [[DataManager shareddbSingleton] updateFav:shareObj.tracksShare_id :@"1" :@"1"];
        shareObj.is_favorite = 1;
        // [btnFavorite setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
        [btnFavorite setBackgroundImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
        [[DataManager shareddbSingleton] favTrack:shareObj.tracksShare_id :@"1"];

        if ([[WebserviceCaller sharedSingleton] isconnectedToNetwork]) {
            [[WebserviceCaller sharedSingleton] BaseWsCallPOST:dict :@"add-favorite/" success:^(id responseData) {
            [[DataManager shareddbSingleton] updateFav:shareObj.tracksShare_id :@"1" :@"0"];
            btnFavorite.enabled =YES;
            btnLike.enabled = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:ReloadFavTable object:nil userInfo:nil];
        } Failure:^(id responseData) {
            btnFavorite.enabled =YES;
      }];
            }
    }
}

-(IBAction)btnLikeClick:(id)sender{
    
    if(![[WebserviceCaller sharedSingleton] isconnectedToNetwork]){
        [[WebserviceCaller sharedSingleton] AjNotificationView:LocalizedString(@"KeyErrorInternet", nil) :AJNotificationTypeRed];
        return;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[[Singleton sharedSingleton] getUserDefault:userEMAIL] forKey:@"email"];
    [dict setObject:[[Singleton sharedSingleton] getUserDefault:activatCode] forKey:@"code"];
    [dict setObject:shareObj.tracksShare_id forKey:@"track"];
    
    if (shareObj.is_dislike == 1) {
        //remove favorite track
        [[DataManager shareddbSingleton] updateLike:shareObj.tracksShare_id :@"0" :@"1"];
        shareObj.is_dislike = 0;
        // [btnLike setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
        [btnLike setBackgroundImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
        
        [btnLike setTitle:LocalizedString(@"KeyTrackbtnDisLike", nil) forState:UIControlStateNormal];
        [imgIsDislikeView setHidden:YES];
        [[DataManager shareddbSingleton] likeTrack:shareObj.tracksShare_id :@"0"];
        if ([[WebserviceCaller sharedSingleton] isconnectedToNetwork]) {
            btnLike.enabled =NO;
        [[WebserviceCaller sharedSingleton] BaseWsCallPOST:dict :@"remove-dislike/" success:^(id responseData) {
           [[DataManager shareddbSingleton] updateLike:shareObj.tracksShare_id :@"0" :@"0"];
            btnLike.enabled =YES;
            btnFavorite.enabled = YES;
        } Failure:^(id responseData) {
            btnLike.enabled =YES;
        }];
       }
    }else if (shareObj.is_dislike == 0){
        //add into favorite
        [[DataManager shareddbSingleton] updateLike:shareObj.tracksShare_id :@"1" :@"1"];
        shareObj.is_dislike = 1;
        //[btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [btnLike setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        
        [btnLike setTitle:LocalizedString(@"KeyTrackbtnLike", nil) forState:UIControlStateNormal];
       // imgIsDislikeView.image =[self blurBackgroundImage:imgCoveerPic.image];
        [imgIsDislikeView setHidden:NO];
        [[DataManager shareddbSingleton] likeTrack:shareObj.tracksShare_id :@"1"];

        if ([[WebserviceCaller sharedSingleton] isconnectedToNetwork]) {
            btnLike.enabled =NO;
            [[WebserviceCaller sharedSingleton] BaseWsCallPOST:dict :@"add-dislike/" success:^(id responseData) {
                [[DataManager shareddbSingleton] updateLike:shareObj.tracksShare_id :@"1" :@"0"];
                btnLike.enabled =YES;
                btnFavorite.enabled = NO;

            } Failure:^(id responseData) {
                btnLike.enabled =YES;
            }];
        }
    }
}

-(UIImage *) blurBackgroundImage:(UIImage *)imgBG  {
    //blur
    UIImage *img = imgBG;
    CGRect frame = CGRectMake(0,0 , img.size.width, img.size.height);
    img=[img applyBlurWithRadius:50 iterationsCount:1 tintColor:nil saturationDeltaFactor:1 maskImage:nil atFrame:frame];
    return img;
}


@end
