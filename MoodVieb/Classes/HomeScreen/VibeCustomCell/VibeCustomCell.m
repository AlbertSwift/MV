//
//  VibeCustomCell.m
//  MoodVibe
//
//  Created by code-on on 8/10/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import "VibeCustomCell.h"
#import "AppDelegate.h"
@implementation VibeCustomCell
@synthesize imgCoveerPic,shareObj,lblTitle,horSlider,btnpercantage,imgpercantage,moreView,customTag;
- (void)awakeFromNib {
    // Initialization code
    if (g_IS_IOS_8) {
        self.contentView.preservesSuperviewLayoutMargins = NO;
    }
    appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    horSlider = [[RS_SliderView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 175) andOrientation:Horizontal];
    horSlider.delegate = self;
    [horSlider setColorsForBackground:[UIColor clearColor]
                           foreground:[UIColor clearColor]
                               handle:[UIColor colorWithPatternImage:[Theme sharedSingleton].vibeListslider]
                               border:[UIColor clearColor]];

//    [horSlider setValue:0.5 withAnimation:true completion:^(BOOL finished) {
//    }];
    [sliderView addSubview:horSlider];
    UITapGestureRecognizer *showhide =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(showHideViewMore)];
    [moreView addGestureRecognizer:showhide];

    
    [self setupThame];
}

-(void)setupThame{
    
    self.imgpercantage.image =[Theme sharedSingleton].vibeListPlayIcon;
    
//    [self.btnAddPlaylist setBackgroundImage:[Theme sharedSingleton].vibeListAddIcon forState:UIControlStateNormal];
//    [self.btnRemovePlaylist setBackgroundImage:[Theme sharedSingleton].vibeListRemoveIcon forState:UIControlStateNormal];


    [self.btnAddPlaylist setImage:[Theme sharedSingleton].vibeListAddIcon forState:UIControlStateNormal];
    [self.btnAddPlaylist setImage:[Theme sharedSingleton].vibeListAddIcon forState:UIControlStateHighlighted];
    
    [self.btnRemovePlaylist setImage:[Theme sharedSingleton].vibeListRemoveIcon forState:UIControlStateNormal];
    [self.btnRemovePlaylist setImage:[Theme sharedSingleton].vibeListRemoveIcon forState:UIControlStateHighlighted];
    
    
    
    [self.self.btnDownloadVieb setBackgroundImage:[Theme sharedSingleton].vibeListDownloadIcon forState:UIControlStateNormal];

    [self.btnunChacheVieb setBackgroundImage:[Theme sharedSingleton].vibeListunDownloadIcon forState:UIControlStateNormal];

    [self.btnDownloadVieb setImage:[Theme sharedSingleton].vibeListOfflineIcon forState:UIControlStateHighlighted];
    
    self.lblCurrentSongTitle.textColor =[Theme sharedSingleton].vibeListcurrentsongTitleColor;
    self.lblCurrentSongTitle.font = [Theme sharedSingleton].vibeListcurrentsongTitleFont;
    
    self.lblCurrentSongArtist.textColor =[Theme sharedSingleton].vibeListcurrentsongArtistColor;
    self.lblCurrentSongArtist.font = [Theme sharedSingleton].vibeListcurrentsongArtistFont;

    self.lblTitle.textColor = [Theme sharedSingleton].vibeListTitleColor;
    self.lblTitle.font = [Theme sharedSingleton].vibeListTitlefont;

    [self.btnpercantage setTitleColor:[Theme sharedSingleton].vibeListPercentageColor forState:UIControlStateNormal];
    [self.btnpercantage.titleLabel setFont:[Theme sharedSingleton].vibeListPercentagefont];

    
    [self.btnAddPlaylist setTitleColor:[Theme sharedSingleton].vibeListAddTitleColor forState:UIControlStateNormal];
    [self.btnAddPlaylist.titleLabel setFont:[Theme sharedSingleton].vibeListAddTitlefont];
    
    
    [self.btnRemovePlaylist setTitleColor:[Theme sharedSingleton].vibeListRemoveTitleColor forState:UIControlStateNormal];
    [self.btnRemovePlaylist.titleLabel setFont:[Theme sharedSingleton].vibeListRemoveTitlefont];
    

    [self.btnDownloadVieb setTitleColor:[Theme sharedSingleton].vibeListDownloadTitleColor forState:UIControlStateNormal];
    [self.btnDownloadVieb.titleLabel setFont:[Theme sharedSingleton].vibeListDownloadTitlefont];
    
    [self.moreView setBackgroundColor:[Theme sharedSingleton].vibeListMoreViewBGColor];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)ApplyData{

    lblTitle.text = [shareObj.title uppercaseString];
    __block UIImageView *temp = imgCoveerPic;

    if ([[WebserviceCaller sharedSingleton] isconnectedToNetwork]) {
        
        if ([[Singleton sharedSingleton]CheckLocalImage:shareObj.image_offline]) {
            [imgCoveerPic setImage:[[Singleton sharedSingleton] getLocalImage:shareObj.image_offline]];

        }else{
            [imgCoveerPic setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:shareObj.image]] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                temp.image = image;
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            }];
        }
        
        
    }else{
        NSString *path = [NSString stringWithFormat:@"%@/Vieb_%@.png",shareObj.VibeShare_id,shareObj.VibeShare_id];
        [imgCoveerPic setImage:[[Singleton sharedSingleton] getLocalImage:path]];
        
    }
    
    shareObj =   [[DataManager shareddbSingleton]getPlayListDetail:shareObj];
    
    
    if (shareObj.isInPlaylist) {
     //   horSlider.value=shareObj.percentage;
        isAddClick =YES;
        [horSlider setValue:shareObj.percentage withAnimation:true completion:^(BOOL finished) {
          }];
        sliderView.hidden =YES;
        [btnpercantage setHidden:NO];
        [imgpercantage setHidden:NO];
        
        if (shareObj.isSliderShow) {
            sliderView.hidden=NO;
        }
        self.btnRemovePlaylist.enabled = YES;
        self.btnAddPlaylist.enabled= NO;
        [self.btnAddPlaylist setHidden:YES];
        [self.btnRemovePlaylist setHidden:NO];

    }else{
       
        if ([WebserviceCaller sharedSingleton].isconnectedToNetwork) {
            self.btnAddPlaylist.enabled= YES;
            [self.btnAddPlaylist setHidden:NO];
        }else{
            
            NSNumber *isOfflinenum= (NSNumber *)shareObj.isOffline;
            NSString *strisOfflinenum;
            if ([isOfflinenum isKindOfClass:[NSNumber class]]) {
                strisOfflinenum = [isOfflinenum stringValue];
            }else{
                strisOfflinenum = shareObj.isOffline;
            }
            
            if ([strisOfflinenum isEqualToString:@"2"]) {
                self.btnAddPlaylist.enabled= YES;
                [self.btnAddPlaylist setHidden:NO];
            }else{
                //self.btnAddPlaylist.enabled= NO;
                [self.btnAddPlaylist setHidden:NO];
            }
        }
       
        
        
        sliderView.hidden =YES;
        [btnpercantage setHidden:YES];
        [imgpercantage setHidden:YES];
        self.btnRemovePlaylist.enabled = NO;
        [self.btnRemovePlaylist setHidden:YES];
    }
    self.lblpercentage.text = [NSString stringWithFormat:@"%d%%",(int)([[NSString stringWithFormat:@"%0.2f",shareObj.percentage] floatValue] * 100)];
    int percantage =(int)([[NSString stringWithFormat:@"%0.2f",shareObj.percentage] floatValue] * 100);
    [btnpercantage setTitle:[NSString stringWithFormat:@"%d%%",percantage] forState:UIControlStateNormal];

    NSNumber *isOfflinenum= (NSNumber *)shareObj.isOffline;
    NSString *strisOfflinenum;
    if ([isOfflinenum isKindOfClass:[NSNumber class]]) {
        strisOfflinenum = [isOfflinenum stringValue];
    }else{
        strisOfflinenum = shareObj.isOffline;
    }
    
    self.progressbar.tag = [shareObj.VibeShare_id intValue];
    self.progressbar.maxValue = [shareObj.arytracks count];
    NSLog(@"%f",self.progressbar.maxValue);
    self.progressbar.value = [[DataManager shareddbSingleton] undownloadAudio:shareObj.VibeShare_id];
    NSLog(@"%f",self.progressbar.value);
    if ([strisOfflinenum isEqualToString:@"2"]) {
            [self.imglogoPic setHidden:NO];
        [self.btnDownload setHidden:NO];
        [self.btnunChacheVieb setHidden:NO];
        [self.progressbar setHidden:YES];
    }else if ([strisOfflinenum isEqualToString:@"1"]) {
        [self.imglogoPic setHidden:NO];
        [self.btnDownload setHidden:NO];
        [self.btnunChacheVieb setHidden:NO];
        [self.progressbar setHidden:NO];
        
    }else{
         [self.imglogoPic setHidden:YES];
        [self.btnDownload setHidden:YES];
        [self.btnunChacheVieb setHidden:YES];
        [self.progressbar setHidden:YES];
    }

    if (self.progressbar.value == self.progressbar.maxValue) {
       // [self.progressbar setHidden:YES];
    }

    //[self.btnDownload setHidden:NO];

    
    NSDictionary *currentPlayInfo= [[MPNowPlayingInfoCenter defaultCenter]nowPlayingInfo];
    NSString *viebid;
    if ([shareObj.VibeShare_id isKindOfClass:[NSNumber class]]) {
        viebid = [(NSNumber *)shareObj.VibeShare_id stringValue];
        
    }else{
        viebid =shareObj.VibeShare_id;
    }
    
    if ([viebid isEqualToString:[currentPlayInfo objectForKey:@"ViebId"]]) {
        self.lblCurrentSongArtist.text = [currentPlayInfo objectForKey:@"artist"];
        self.lblCurrentSongTitle.text = [[currentPlayInfo objectForKey:@"title"] uppercaseString];
    }else{
        self.lblCurrentSongArtist.text = @"";
        self.lblCurrentSongTitle.text = @"";
    }

    if (shareObj.percentage >= 1) {
        horSlider.disabe = YES;
    }
    
    
}


-(IBAction)btnMoreClick:(id)sender{

    int i = 0;
    int appdeltaptag= 0;
    for (VibeShare *tempshare in appDel.aryVibes) {
        if([self.shareObj.title isEqualToString:tempshare.title]){
            appdeltaptag = i;
            break;
        }
        i++;
    }
    
    VibeShare *shareobj = [appDel.aryVibes objectAtIndex:appdeltaptag];
    
    [[DataManager shareddbSingleton] saveTrack:[shareobj.arytracks mutableCopy] :self.shareObj.VibeShare_id success:^(BOOL responseData) {
        
        
        
        int oldMoreClick=[Singleton sharedSingleton].currentViebMoreClick;
        if (oldMoreClick!=-1 && oldMoreClick != [sender tag]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ReloadSingleCell object:nil userInfo:nil];
        }
        
        [self showHideViewMore];
        if (oldMoreClick!=-1 && oldMoreClick == [sender tag]) {
            [Singleton sharedSingleton].currentViebMoreClick = -1;
            
        }else{
            [Singleton sharedSingleton].currentViebMoreClick = [sender tag];
            
        }
        [[DataManager shareddbSingleton] downloadTrackImages:[[[DataManager shareddbSingleton] getTrackList:shareobj.VibeShare_id] mutableCopy] success:^(BOOL responseData) {
            
        }];
    }];
    
    
}


-(IBAction)btnAddPlaylistClick:(id)sender{
    
    
    if(![[WebserviceCaller sharedSingleton] isconnectedToNetwork]){
        [[WebserviceCaller sharedSingleton] AjNotificationView:LocalizedString(@"KeyErrorInternet", nil) :AJNotificationTypeRed];
        return;
    }
    
    
   [Singleton sharedSingleton].currentViebMoreClick =-1;
    NSArray *playAry =[[DataManager shareddbSingleton]getListOfAllPlaylist];
    
    if ([playAry count]==0) {
        //reset to 0 current play
        [[Singleton sharedSingleton] setUserDefault:@"0" :CURRENTPLAYINDEX];
    }
    
    if ([playAry count]+1<=4) {
        if ([[DataManager shareddbSingleton] checkId:@"vieb_id" :shareObj.VibeShare_id :@"myPlayList"]) {
            [[WebserviceCaller sharedSingleton] AjNotificationView:@"Vibe Already in list" :AJNotificationTypeRed];
        }else{
        //sliderView.hidden =NO;
            shareObj.isInPlaylist = YES;
            [btnpercantage setHidden:NO];
            [imgpercantage setHidden:NO];
            [self showHideViewMore];

//        int totalSelVibe = [[DataManager shareddbSingleton] CountSelectedPlaylist]+1;
            int totalSelVibe = [playAry count] + 1;
          
        shareObj.percentage =(float) 1.0/totalSelVibe;
            
        [[DataManager shareddbSingleton] addintoPlaylist:[shareObj.VibeShare_id intValue] :shareObj.percentage];

        isAddClick = YES;
        [[DataManager shareddbSingleton] updateAllMyPlaylist:[playAry count]+1];

        [horSlider setValue:shareObj.percentage withAnimation:true completion:^(BOOL finished) {
            int percantage =(int)([[NSString stringWithFormat:@"%0.2f",shareObj.percentage] floatValue] * 100);
            [btnpercantage setTitle:[NSString stringWithFormat:@"%d%%",percantage] forState:UIControlStateNormal];
            
        }];

            NSMutableDictionary *dict =[[NSMutableDictionary alloc] init];
            [dict setValue:[NSString stringWithFormat:@"%d",customTag] forKey:@"from"];
            [dict setValue:0 forKey:@"to"];
            [[Singleton sharedSingleton] createPlaylist];
            
/*            [[NSNotificationCenter defaultCenter] postNotificationName:reorderCell object:nil userInfo:dict];

            [btnpercantage sendActionsForControlEvents:UIControlEventTouchUpInside];
*/
            NSMutableDictionary *info=[[NSMutableDictionary alloc] init];
            if (sliderView.isHidden) {
                sliderView.hidden = NO;
                [info setValue:@"1" forKey:@"isShow"];
                [[Singleton sharedSingleton] startTimer];
                [[NSNotificationCenter defaultCenter] postNotificationName:reloadAllSlider object:nil userInfo:info];
            }
        }
    }else{
        [[WebserviceCaller sharedSingleton] AjNotificationView:@"You can not add more than 4 Vibes" :AJNotificationTypeRed];
    }

}

-(IBAction)btnRemovePlaylistClick:(id)sender{
    [Singleton sharedSingleton].currentViebMoreClick =-1;

    sliderView.hidden =YES;
    shareObj.isInPlaylist = NO;
    shareObj.percentage = 0;

    [[DataManager shareddbSingleton] removePlaylist:[shareObj.VibeShare_id intValue]];
    
    [[DataManager shareddbSingleton] updatePercentage:[shareObj.VibeShare_id intValue] :0];
    
    //[[Singleton sharedSingleton] createPlaylist];
    //reset current play to 0
    NSArray *ary= [[[DataManager shareddbSingleton] getMyTracksV1] mutableCopy];
    if ([ary count]==0) {
        [[Singleton sharedSingleton] setUserDefault:@"0" :CURRENTPLAYINDEX];
    }
    [btnpercantage setHidden:YES];
    [imgpercantage setHidden:YES];
    [self showHideViewMore];

  //  NSDictionary* userInfo = @{@"currentVieb": shareObj.VibeShare_id};
    self.lblpercentage.text =@"0%";
    [btnpercantage setTitle:@"0%" forState:UIControlStateNormal];
   // [[NSNotificationCenter defaultCenter] postNotificationName:homeReloadCell object:nil userInfo:userInfo];

    NSMutableDictionary *dict =[[NSMutableDictionary alloc] init];
    [dict setValue:[NSString stringWithFormat:@"%d",customTag] forKey:@"from"];
    [dict setValue:0 forKey:@"to"];
    
    [[Singleton sharedSingleton] createPlaylist];
   // [[NSNotificationCenter defaultCenter] postNotificationName:reorderCell object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotificationName:ReloadTable object:nil];

    
}

-(IBAction)btnDownloadViebClick:(id)sender{
    
    //check if download more than 4 ?
    
    if ([[DataManager shareddbSingleton] checkDownloadCounter]) {
        [[WebserviceCaller sharedSingleton] AjNotificationView:@"Can not download more than 4 vibes." :AJNotificationTypeRed];
        return;
    }
    
    
    NSNumber *isOfflinenum= (NSNumber *)shareObj.isOffline;
    NSString *strisOfflinenum;
    if ([isOfflinenum isKindOfClass:[NSNumber class]]) {
        strisOfflinenum = [isOfflinenum stringValue];
    }else{
        strisOfflinenum = shareObj.isOffline;
    }
    if ([strisOfflinenum isEqualToString:@"2"]) {
        [self.btnDownload sendActionsForControlEvents:UIControlEventTouchUpInside];
    }else{
    //refect content because if downloading start from track then share object not updated so refect the data.
    NSDictionary *dict = [[DataManager shareddbSingleton] getVibesDetail:shareObj.VibeShare_id];
    VibeShare *shareObj1=[[WebserviceCaller sharedSingleton] convertDictonary:[dict mutableCopy] :@"VibeShare"];

    shareObj=shareObj1;
    NSString *offline;
    if ([shareObj.isOffline isKindOfClass:[NSNumber class]]) {
        offline = [(NSNumber *)shareObj.isOffline stringValue];
    }else{
      offline =shareObj.isOffline;
    }
    
    if ([offline  isEqualToString:@"0"]) {
        if ([[WebserviceCaller sharedSingleton] isconnectedToNetwork]) {
            shareObj.isOffline=@"1";
            [[DataManager shareddbSingleton] downloadvieboffline:shareObj.VibeShare_id];
            
            
        }else{
            [[WebserviceCaller sharedSingleton] AjNotificationView:@"Connect Internet for offline listen" :AJNotificationTypeRed];
        }
        
    }
}
    
    
}

-(void)showHideViewMore{
    if (moreView.hidden) {
        //show more view
        moreView.alpha = 0;
        moreView.hidden = true;

        CGRect frame = moreView.frame;
        frame.size.height = 0;
        frame.origin.y = 175;
        moreView.frame = frame;

        CGRect addframe = self.btnAddPlaylist.frame;
        addframe.size.height=0;
        addframe.origin.y =15;
        self.btnAddPlaylist.frame = addframe;
        self.btnAddPlaylist.alpha=0;

        
        CGRect DownloadViebframe = self.btnDownloadVieb.frame;
        DownloadViebframe.size.height=0;
        DownloadViebframe.origin.y =15;
        self.btnDownloadVieb.frame = DownloadViebframe;
        self.btnDownloadVieb.alpha = 0;

        CGRect Removeframe = self.btnRemovePlaylist.frame;
        Removeframe.size.height=0;
        Removeframe.origin.y =15;
        self.btnRemovePlaylist.frame = Removeframe;
        self.btnRemovePlaylist.alpha = 0;

        
        CGRect ChacheViebframe = self.btnunChacheVieb.frame;
        ChacheViebframe.size.height=0;
        ChacheViebframe.origin.y =15;
        self.btnunChacheVieb.frame = ChacheViebframe;
        self.btnunChacheVieb.alpha = 0;

        [UIView animateWithDuration:0.5 animations:^{
            [moreView layoutIfNeeded];

            moreView.alpha = 1;
            moreView.hidden = false;
            CGRect frame = moreView.frame;
            frame.size.height = 175;
            frame.origin.y = 0;
            moreView.frame = frame;
            
            CGRect addframe = self.btnAddPlaylist.frame;
            addframe.size.height=116;
            addframe.origin.y =15;
            self.btnAddPlaylist.frame = addframe;
            self.btnAddPlaylist.alpha=1;
            
            CGRect DownloadViebframe = self.btnDownloadVieb.frame;
            DownloadViebframe.size.height=116;
            DownloadViebframe.origin.y =15;
            self.btnDownloadVieb.frame = DownloadViebframe;
            self.btnDownloadVieb.alpha = 1;

            CGRect Removeframe = self.btnRemovePlaylist.frame;
            Removeframe.size.height=116;
            Removeframe.origin.y =15;
            self.btnRemovePlaylist.frame = Removeframe;
            self.btnRemovePlaylist.alpha = 1;
            
            
            CGRect ChacheViebframe = self.btnunChacheVieb.frame;
            ChacheViebframe.size.height=116;
            ChacheViebframe.origin.y =15;
            self.btnunChacheVieb.frame = ChacheViebframe;
            self.btnunChacheVieb.alpha = 1;
            

        }completion:^(BOOL finished) {
            self.btnunChacheVieb.alpha = 1;

        }];
    }else{
        //hide more view
        moreView.alpha = 1;
        moreView.hidden = false;
        CGRect frame = moreView.frame;
        frame.size.height = 175;
        frame.origin.y = 0;
        moreView.frame = frame;
        
        CGRect addframe = self.btnAddPlaylist.frame;
        addframe.size.height=116;
        addframe.origin.y =15;
        self.btnAddPlaylist.frame = addframe;
        self.btnAddPlaylist.alpha=1;

        CGRect DownloadViebframe = self.btnDownloadVieb.frame;
        DownloadViebframe.size.height=116;
        DownloadViebframe.origin.y =15;
        self.btnDownloadVieb.frame = DownloadViebframe;
        self.btnDownloadVieb.alpha = 1;

        CGRect Removeframe = self.btnRemovePlaylist.frame;
        Removeframe.size.height=116;
        Removeframe.origin.y =15;
        self.btnRemovePlaylist.frame = Removeframe;
        self.btnRemovePlaylist.alpha = 1;

        CGRect ChacheViebframe = self.btnunChacheVieb.frame;
        ChacheViebframe.size.height=116;
        ChacheViebframe.origin.y =15;
        self.btnunChacheVieb.frame = ChacheViebframe;
        self.btnunChacheVieb.alpha = 1;
        
        [UIView animateWithDuration:0.5 animations:^{
            [moreView layoutIfNeeded];
            CGRect frame = moreView.frame;
            frame.size.height = 00;
            frame.origin.y = 175;
            moreView.frame = frame;
            
            CGRect addframe = self.btnAddPlaylist.frame;
            addframe.size.height=0;
            addframe.origin.y =0;
            self.btnAddPlaylist.frame = addframe;
            self.btnAddPlaylist.alpha=0;
            
            
            CGRect DownloadViebframe = self.btnDownloadVieb.frame;
            DownloadViebframe.size.height=0;
            DownloadViebframe.origin.y =0;
            self.btnDownloadVieb.frame = DownloadViebframe;
            self.btnDownloadVieb.alpha = 0;
            
            CGRect Removeframe = self.btnRemovePlaylist.frame;
            Removeframe.size.height=0;
            Removeframe.origin.y =0;
            self.btnRemovePlaylist.frame = Removeframe;
            self.btnRemovePlaylist.alpha = 0;
            
            CGRect ChacheViebframe = self.btnunChacheVieb.frame;
            ChacheViebframe.size.height=0;
            ChacheViebframe.origin.y =0;
            self.btnunChacheVieb.frame = ChacheViebframe;
            self.btnunChacheVieb.alpha = 0;
            
        }completion:^(BOOL finished) {
            moreView.hidden = true;
        }];

    }
}

#pragma mark
#pragma mark - rs slider 
-(void)sliderValueChanged:(RS_SliderView *)sender {
    
    if (!isAddClick) {
        if (sender.tag == [Singleton sharedSingleton].isCurrentSliderTouch) {
            [[DataManager shareddbSingleton] updatePercentage:[shareObj.VibeShare_id intValue] :sender.value];
            self.lblpercentage.text = [NSString stringWithFormat:@"%d%%",(int)([[NSString stringWithFormat:@"%0.2f",sender.value] floatValue] * 100)];
            [btnpercantage setTitle:[NSString stringWithFormat:@"%d%%",(int)([[NSString stringWithFormat:@"%0.2f",sender.value] floatValue] * 100)] forState:UIControlStateNormal];
                        NSDictionary* userInfo = @{@"currentVieb": shareObj.VibeShare_id};
            
             [[NSNotificationCenter defaultCenter] postNotificationName:homeReloadCell object:nil userInfo:userInfo];
            
        }
    }else{
        isAddClick= NO;
    }
    
}

-(void)sliderValueChangeEnded:(RS_SliderView *)sender {
    NSLog(@"Changed");
    [[NSNotificationCenter defaultCenter] postNotificationName:Tablescroll object:nil];
    [[Singleton sharedSingleton] createPlaylist];
   
}

-(IBAction)btnPercantageClick:(id)sender{
    
    NSMutableDictionary *info=[[NSMutableDictionary alloc] init];
    if (sliderView.isHidden) {
        sliderView.hidden = NO;
        [info setValue:@"1" forKey:@"isShow"];
        [[Singleton sharedSingleton] startTimer];

        [[NSNotificationCenter defaultCenter] postNotificationName:reloadAllSlider object:nil userInfo:info];
        //[[NSNotificationCenter defaultCenter] postNotificationName:ReloadTable object:nil];

    }else{
        sliderView.hidden = YES;
        [[Singleton sharedSingleton] endTimer];
        [info setValue:@"0" forKey:@"isShow"];
        [[NSNotificationCenter defaultCenter] postNotificationName:reloadAllSlider object:nil userInfo:info];
//        [[NSNotificationCenter defaultCenter] postNotificationName:ReloadTable object:nil];

    }

}


-(IBAction)btnunDownloadClick:(id)sender{
    shareObj.isOffline=@"0";
    [[DataManager shareddbSingleton] unDownloadvibe:shareObj.VibeShare_id];
    [[WebserviceCaller sharedSingleton] cancelDownload];
    [self ApplyData];
}

@end
