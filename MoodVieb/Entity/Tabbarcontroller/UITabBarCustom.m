//
//  UITabBarCustom.m
//  iOSCodeStructure
//
//  Created by Nishant
//  Copyright (c) 2013 Nishant. All rights reserved.
//

#import "UITabBarCustom.h"
#import "AppDelegate.h"
@class AppDelegate;
@interface UITabBarCustom ()
{
    UINavigationController * navController;
}
@end

@implementation UITabBarCustom
@synthesize btnTab1, btnTab2, btnTab3, btnTab4,btnTab5;
@synthesize imgTabBg,customTabobj;
#pragma mark - This is the main Tabbar in the Application
#pragma mark - View Life Cycle
-(void)viewDidLoad
{
    [super viewDidLoad];
    HeightTabbar=85;
    noOfTab=0;
    appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self addCustomElements];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideOriginalTabBar];
}
#pragma mark - Hide Original TabBar - Add Custom TabBar
- (void)hideOriginalTabBar
{
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            view.hidden = YES;
            break;
        }
    }
}
-(void)addCustomElements
{
    //Add Bg Image
    if(imgTabBg != nil)
    {
        [imgTabBg removeFromSuperview];
    }
    float y = 0;//[UIScreen mainScreen].bounds.size.height-HeightTabbar;
    float w = [UIScreen mainScreen].bounds.size.width;
    float h =[UIScreen mainScreen].bounds.size.height;
    customTabobj = [self loadViewNib:@"customTab"];

    [customTabobj setupThame];
   // //open side menu
    [customTabobj.btnPopup addTarget:self action:@selector(OpenpopupClick) forControlEvents:UIControlEventTouchUpInside];
    
    //play button
    [customTabobj.btnPlay removeTarget:self action:@selector(btnPlayClick:) forControlEvents:UIControlEventTouchUpInside];
    [customTabobj.btnPlay addTarget:self action:@selector(btnPlayClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [customTabobj.btnPause removeTarget:self action:@selector(btnPauseClick:) forControlEvents:UIControlEventTouchUpInside];
    [customTabobj.btnPause addTarget:self action:@selector(btnPauseClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [customTabobj.btnSkip removeTarget:self action:@selector(btnSkipClick:) forControlEvents:UIControlEventTouchUpInside];
    [customTabobj.btnSkip addTarget:self action:@selector(btnSkipClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //favorite button
    [customTabobj.btnFavorite removeTarget:self action:@selector(btnFavClick:) forControlEvents:UIControlEventTouchUpInside];
    [customTabobj.btnFavorite addTarget:self action:@selector(btnFavClick:) forControlEvents:UIControlEventTouchUpInside];
    
    SideMenu = [self loadViewNib:@"MenuListVC"];
    SideMenu.frame = CGRectMake(w, 20, 250, h);
    [SideMenu.btnClose addTarget:self action:@selector(ClosepopupClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    //mydata click
    [SideMenu.btnMyData removeTarget:self action:@selector(mydataclick) forControlEvents:UIControlEventTouchUpInside];
    [SideMenu.btnMyData addTarget:self action:@selector(mydataclick) forControlEvents:UIControlEventTouchUpInside];

    //About click
    [SideMenu.btnAbout removeTarget:self action:@selector(aboutclick) forControlEvents:UIControlEventTouchUpInside];
    [SideMenu.btnAbout addTarget:self action:@selector(aboutclick) forControlEvents:UIControlEventTouchUpInside];
    
    //Disclamir click
    [SideMenu.btnDisclaimer removeTarget:self action:@selector(Disclamirclick) forControlEvents:UIControlEventTouchUpInside];
    [SideMenu.btnDisclaimer addTarget:self action:@selector(Disclamirclick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    bottom_view=[[UIView alloc] initWithFrame:CGRectMake(0,y,w,HeightTabbar)];
    customTabobj.frame = CGRectMake(0, 0, w, HeightTabbar);
    [self.view addSubview:customTabobj];
    [self.view addSubview:SideMenu];
    y_position=0;
    btn_y_position=01;
    btn_x_position=0;
    btn_width=w/noOfTab;
    btn_height=HeightTabbar;
    // [self addAllElements];
    
}


#pragma mark
-(void)OpenpopupClick{
    [UIView animateWithDuration:0.25 animations:^{
        SideMenu.frame = CGRectMake(75, 20, [UIScreen mainScreen].bounds.size.width-75, SideMenu.frame.size.height);
    }];
    
}


-(void)btnPlayClick:(id)sender{
    
    if(![[WebserviceCaller sharedSingleton] isconnectedToNetwork]){
        [[WebserviceCaller sharedSingleton] AjNotificationView:LocalizedString(@"KeyErrorInternet", nil) :AJNotificationTypeRed];
        return;
    }
    
    
    if ([AFSoundManager sharedManager].status == AFSoundManagerStatusPaused) {
        [[AFSoundManager sharedManager] resume];
        [customTabobj.btnPause setHidden:NO];
        [customTabobj.btnSkip setHidden:NO];
        [customTabobj.btnPlay setHidden:YES];
        return;
    }

    self.items= [[[DataManager shareddbSingleton] getMyTracks] mutableCopy];
    if (self.items != nil) {
        [customTabobj.btnPause setHidden:NO];
        [customTabobj.btnSkip setHidden:NO];
        [customTabobj.btnPlay setHidden:YES];
        
        int currentPlayIndex = [[[Singleton sharedSingleton] getUserDefault:CURRENTPLAYINDEX] intValue];
        
        if (currentPlayIndex >= [self.items count]) {
            [[Singleton sharedSingleton] setUserDefault:@"0" :CURRENTPLAYINDEX];
            currentPlayIndex = 0;
        
        }
        
        NSMutableDictionary *dict = [self.items objectAtIndex:currentPlayIndex];
        [self playstart:dict];
    }else{
       // [[WebserviceCaller sharedSingleton] AjNotificationView:@"Please Select vibe" :AJNotificationTypeRed];
    }

}

-(void)btnPauseClick:(id)sender{
    NSLog(@"%d",[AFSoundManager sharedManager].status);
    if ([AFSoundManager sharedManager].status == AFSoundManagerStatusPlaying) {
        [customTabobj.btnPause setHidden:YES];
        [customTabobj.btnSkip setHidden:YES];
        [customTabobj.btnPlay setHidden:NO];
        [[AFSoundManager sharedManager] pause];
    }else if ([AFSoundManager sharedManager].status == AFSoundManagerStatusFinished){
        [[AFSoundManager sharedManager] resume];
    }
    
}

-(void)btnSkipClick:(id)sender{
   
    if(![[WebserviceCaller sharedSingleton] isconnectedToNetwork]){
        [[WebserviceCaller sharedSingleton] AjNotificationView:LocalizedString(@"KeyErrorInternet", nil) :AJNotificationTypeRed];
        return;
    }
    
    self.items= [[[DataManager shareddbSingleton] getMyTracks] mutableCopy];
    if (self.items != nil) {

        int currentPlayIndex = [[[Singleton sharedSingleton] getUserDefault:CURRENTPLAYINDEX] intValue] + 1;
        
        if (currentPlayIndex >= [self.items count]) {
            [[Singleton sharedSingleton] setUserDefault:@"0" :CURRENTPLAYINDEX];
            currentPlayIndex = 0;
        }
        NSMutableDictionary *dict = [self.items objectAtIndex:currentPlayIndex];
        [[Singleton sharedSingleton] setUserDefault:[NSString stringWithFormat:@"%d",(currentPlayIndex)] :CURRENTPLAYINDEX];
        customTabobj.btnSkip.enabled = NO;
        [self playstart:dict];
    }
    
}


-(void)playstart:(NSMutableDictionary *)dict{
    NSLog(@"%@",dict);

    //check if any song play.
    tracksShare *shareobj= [[DataManager shareddbSingleton] trackDetail:[dict objectForKey:@"track_id"]];
    NSDictionary *viebDict = [[DataManager shareddbSingleton]getVibesDetail:[dict objectForKey:@"vieb_id"]];
    
    [[DataManager shareddbSingleton] addStatics:shareobj.tracksShare_id];
   
    
    NSString *url;
    if ([[NSString stringWithFormat:@"%@",shareobj.isDownloading] isEqualToString:@"2"]) {
        //offline play
        __block  int i=0;
        __block  int lastPer=0;
        url = [NSString stringWithFormat:@"%@",shareobj.offline_url];
        //lock screen
        
        
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        [songInfo setObject:shareobj.title forKey:MPMediaItemPropertyTitle];
        [songInfo setObject:shareobj.artist forKey:MPMediaItemPropertyArtist];
        [songInfo setObject:[viebDict objectForKey:@"title"] forKey:MPMediaItemPropertyAlbumTitle];
        [songInfo setObject:[NSString stringWithFormat:@"%@",shareobj.tracksShare_id] forKey:@"TrackId"];
        [songInfo setObject:[NSString stringWithFormat:@"%@",shareobj.vibes_id] forKey:@"ViebId"];
        if (shareobj.artist_image_offline != nil) {
            MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage: [[Singleton sharedSingleton] getLocalImage:shareobj.artist_image_offline]];
            [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
        }
        
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:ReloadPlayInfo object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:ReloadTable object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:ReloadPlayInfo1 object:nil];
        
        [[AFSoundManager sharedManager] startPlayingLocalFileWithName:url atPath:nil withCompletionBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
            
            if (!error) {
                customTabobj.lblPer.text = [NSString stringWithFormat:@"%d",percentage];
                // [[AFSoundManager sharedManager] resume];
              //  NSLog(@"Play Status:%d",[AFSoundManager sharedManager].status);
                if ([AFSoundManager sharedManager].status == AFSoundManagerStatusFinished) {
                    [[AFSoundManager sharedManager] resume];
                }
                if (lastPer == percentage) {
                    i++;
                    if (i>=25 && [AFSoundManager sharedManager].status != AFSoundManagerStatusPaused) {
                        i=0;
                        [[AFSoundManager sharedManager] resume];
                    }
                }else{
                    i=0;
                    lastPer = percentage;
                }
                
                
                if (percentage>=99) {
                    //put 99 because some time not reach at 100
                    if ([[WebserviceCaller sharedSingleton] isconnectedToNetwork]) {
                        [[WebserviceCaller sharedSingleton] updateStatstics];
                    }
                    int currentPlayIndex = [[[Singleton sharedSingleton] getUserDefault:CURRENTPLAYINDEX] intValue];
                    [[Singleton sharedSingleton] setUserDefault:[NSString stringWithFormat:@"%d",(currentPlayIndex+1)] :CURRENTPLAYINDEX];
                    [self.items removeAllObjects];
                    self.items= [[[DataManager shareddbSingleton] getMyTracks] mutableCopy];
                    
                    if (currentPlayIndex +1 >= [self.items count]) {
                        [[Singleton sharedSingleton] setUserDefault:@"0" :CURRENTPLAYINDEX];
                        if ([self.items count]>=1) {
                            //reset playlist song
                            NSMutableDictionary *dict = [self.items objectAtIndex:0];
                            //[[AFSoundManager sharedManager] stop];
                            [self playstart:dict];
                        }else{
                            [customTabobj.btnPlay setHidden:NO];
                            [customTabobj.btnPause setHidden:YES];
                            [customTabobj.btnSkip setHidden:YES];

                            //stop if there is no playlist song
                            [[AFSoundManager sharedManager] stop];
                            
                        }
                    }else{
                        NSMutableDictionary *dict = [self.items objectAtIndex:currentPlayIndex+1];
                        // [[AFSoundManager sharedManager] stop];
                        [self playstart:dict];
                    }
                }
            } else {
                NSLog(@"There has been an error playing the remote file: %@", [error description]);
            }

            
        }];
    }else{
        //online play
    
        url= shareobj.url;
        __block  int i=0;
        __block  int lastPer=0;
        
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        [songInfo setObject:shareobj.title forKey:MPMediaItemPropertyTitle];
        [songInfo setObject:shareobj.artist forKey:MPMediaItemPropertyArtist];
        [songInfo setObject:[viebDict objectForKey:@"title"] forKey:MPMediaItemPropertyAlbumTitle];
        
        NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* foofile = [documentsPath stringByAppendingPathComponent:shareobj.artist_image_offline];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
        if(fileExists){
            if (shareobj.artist_image_offline != nil) {
                MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage: [[Singleton sharedSingleton] getLocalImage:shareobj.artist_image_offline]];
                [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
            }
        }
        
        
        
        [songInfo setObject:[NSString stringWithFormat:@"%@",shareobj.tracksShare_id] forKey:@"TrackId"];
        [songInfo setObject:[NSString stringWithFormat:@"%@",shareobj.vibes_id] forKey:@"ViebId"];
        
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:ReloadPlayInfo object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:ReloadPlayInfo1 object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ReloadTable object:nil];
 
        [[AFSoundManager sharedManager] startStreamingRemoteAudioFromURL:shareobj.url andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
            if (!error) {
                customTabobj.lblPer.text = [NSString stringWithFormat:@"%d",percentage];
                // [[AFSoundManager sharedManager] resume];
               // NSLog(@"Play Status:%d",[AFSoundManager sharedManager].status);
                if ([AFSoundManager sharedManager].status == AFSoundManagerStatusFinished) {
                    [[AFSoundManager sharedManager] resume];
                }
                
                if (lastPer == percentage) {
                    i++;
                    if (i>=25 && [AFSoundManager sharedManager].status != AFSoundManagerStatusPaused) {
                        i=0;
                        [[AFSoundManager sharedManager] resume];
                    }
                }else{
                    i=0;
                    lastPer = percentage;
                }
                
                
                if (percentage>=99) {
                     //put 99 because some time not reach at 100
                    if ([[WebserviceCaller sharedSingleton] isconnectedToNetwork]) {
                        [[WebserviceCaller sharedSingleton] updateStatstics];
                    }
                    int currentPlayIndex = [[[Singleton sharedSingleton] getUserDefault:CURRENTPLAYINDEX] intValue];
                    [[Singleton sharedSingleton] setUserDefault:[NSString stringWithFormat:@"%d",(currentPlayIndex+1)] :CURRENTPLAYINDEX];
                    [self.items removeAllObjects];
                    self.items= [[[DataManager shareddbSingleton] getMyTracks] mutableCopy];
                    
                    if (currentPlayIndex +1 >= [self.items count]) {
                        [[Singleton sharedSingleton] setUserDefault:@"0" :CURRENTPLAYINDEX];
                        if ([self.items count]>=1) {
                            //reset playlist song
                            NSMutableDictionary *dict = [self.items objectAtIndex:0];
                            //[[AFSoundManager sharedManager] stop];
                            [self playstart:dict];
                        }else{
                            [customTabobj.btnPlay setHidden:NO];
                            [customTabobj.btnPause setHidden:YES];
                            [customTabobj.btnSkip setHidden:YES];

                            //stop if there is no playlist song
                            [[AFSoundManager sharedManager] stop];
                            
                        }
                    }else{
                        NSMutableDictionary *dict = [self.items objectAtIndex:currentPlayIndex+1];
                        // [[AFSoundManager sharedManager] stop];
                        [self playstart:dict];
                    }
                }
            } else {
                NSLog(@"There has been an error playing the remote file: %@", [error description]);
            }
        }];
    }
}

-(IBAction)btnFavClick:(id)sender{
    [appDelegate favClcik];
    
}

#pragma mark
#pragma mark - side menu click
-(void)ClosepopupClick{
    [UIView animateWithDuration:0.25 animations:^{
        SideMenu.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 20, [UIScreen mainScreen].bounds.size.width-75, SideMenu.frame.size.height);
    }];
    
}

-(void)mydataclick{
    MydataVC *obj = [[MydataVC alloc] initWithNibName:@"MydataVC" bundle:nil];;
    [self.navigationController presentViewController:obj animated:YES completion:^{
    }];
    
}

-(void)aboutclick{
    AboutVC *obj = [[AboutVC alloc] initWithNibName:@"AboutVC" bundle:nil];
    obj.pagetype = @"About";
    [self.navigationController presentViewController:obj animated:YES completion:^{
    }];
}

-(void)Disclamirclick{
    AboutVC *obj = [[AboutVC alloc] initWithNibName:@"AboutVC" bundle:nil];
    obj.pagetype = @"Disclaimer";
    [self.navigationController presentViewController:obj animated:YES completion:^{
    }];
    
}

-(void)addAllElements
{
    //Add Tab Buttons
    if(btnTab1 != nil)
        [btnTab1 removeFromSuperview];
    if (btnTab2 != nil)
        [btnTab2 removeFromSuperview];
    if(btnTab3 != nil)
        [btnTab3 removeFromSuperview];
    if (btnTab4 != nil)
        [btnTab4 removeFromSuperview];
    if (btnTab5 != nil)
        [btnTab5 removeFromSuperview];
    
    btnTab1 = [self getGeneralTabButton:0 isSelected:true];
    btnTab2 = [self getGeneralTabButton:1 isSelected:false];
    btnTab3 = [self getGeneralTabButton:2 isSelected:false];
    btnTab4 = [self getGeneralTabButton:3 isSelected:false];
    btnTab5 = [self getGeneralTabButton:4 isSelected:false];
    
    [bottom_view addSubview:btnTab1];
    [bottom_view addSubview:btnTab2];
    [bottom_view addSubview:btnTab3];
    [bottom_view addSubview:btnTab4];
    [bottom_view addSubview:btnTab5];
    
    // Setup event handlers so that the buttonClicked method will respond to the touch up inside event.
    [btnTab1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    [btnTab2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    [btnTab3 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    [btnTab4 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    [btnTab5 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    
}

-(UIButton *)getGeneralTabButton:(int)pintTag isSelected:(BOOL)pbolIsSelected
{
    UIImage *btnImage;
    UIImage *btnImageSelected;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTag:pintTag];
    [btn setSelected:pbolIsSelected];
    
    switch (pintTag) {
        case 0:	//Tab-1
            btnImage = [UIImage imageNamed:@"home.png"];
            btnImageSelected = [UIImage imageNamed:@"home_selected.png"];
            btn.frame = CGRectMake(btn_x_position,btn_y_position, btn_width, btn_height);
            break;
        case 1:	//Tab-2
            btnImage = [UIImage imageNamed:@"search.png"];
            btnImageSelected = [UIImage imageNamed:@"search_selected.png"];
            btn.frame = CGRectMake(btn_x_position+btn_width, btn_y_position, btn_width, btn_height);
            break;
        case 2:	//Tab-3
            btnImage = [UIImage imageNamed:@"add.png"];
            btnImageSelected = [UIImage imageNamed:@"add_selected.png"];
            btn.frame = CGRectMake(btn_x_position+(btn_width*2), btn_y_position, btn_width, btn_height);
            //[btn setTitleColor:RGB(62,40,97) forState:UIControlStateNormal];
            break;
        case 3:	//Tab-4
            btnImage = [UIImage imageNamed:@"chain.png"];
            btnImageSelected = [UIImage imageNamed:@"chain_selected.png"];
            btn.frame = CGRectMake(btn_x_position+(btn_width*3), btn_y_position, btn_width, btn_height);
            break;
        default://Tab-1
            btnImage = [UIImage imageNamed:@"man.png"];
            btnImageSelected = [UIImage imageNamed:@"man_selected.png"];
            btn.frame = CGRectMake(btn_x_position+(btn_width*4), btn_y_position, btn_width, btn_height);
            break;
    }
    
    [btn setImage:btnImage forState:UIControlStateNormal];
    [btn setImage:btnImageSelected forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageNamed:@"selectedbox"] forState:UIControlStateSelected];
    
    return btn;
}

#pragma mark - Select Tab
- (void)buttonClicked:(id)sender
{
    int tagNum =(int)[sender tag];
    [self selectTab:tagNum];
}
- (void)selectTab:(int)tabID
{
    switch(tabID)
    {
        case 0:
            [btnTab1 setSelected:true];
            [btnTab2 setSelected:false];
            [btnTab3 setSelected:false];
            [btnTab4 setSelected:false];
            [btnTab5 setSelected:false];
            break;
        case 1:
            [btnTab1 setSelected:false];
            [btnTab2 setSelected:true];
            [btnTab3 setSelected:false];
            [btnTab4 setSelected:false];
            [btnTab5 setSelected:false];
            break;
        case 2:
            [btnTab1 setSelected:false];
            [btnTab2 setSelected:false];
            [btnTab3 setSelected:true];
            [btnTab4 setSelected:false];
            [btnTab5 setSelected:false];
            break;
        case 3:
            [btnTab1 setSelected:false];
            [btnTab2 setSelected:false];
            [btnTab3 setSelected:false];
            [btnTab4 setSelected:true];
            [btnTab5 setSelected:false];
            break;
        case 4:
            [btnTab1 setSelected:false];
            [btnTab2 setSelected:false];
            [btnTab3 setSelected:false];
            [btnTab4 setSelected:false];
            [btnTab5 setSelected:true];
            break;
    }
    
    self.selectedIndex = tabID;
    if (self.selectedIndex == tabID)
    {
        if (appDelegate.isPopToAllView==FALSE){
            navController = (UINavigationController *)[self selectedViewController];
            [navController popToRootViewControllerAnimated:YES];
        }
        else{
            navController = (UINavigationController *)[self selectedViewController];
            [navController popToRootViewControllerAnimated:YES];
        }
    }else{
        self.selectedIndex = tabID;
    }
}
#pragma mark - Show/Hide TabBar
- (void)showTabBar
{
    self.imgTabBg.hidden = NO;
    self.btnTab1.hidden = NO;
    self.btnTab2.hidden = NO;
    self.btnTab3.hidden = NO;
    self.btnTab4.hidden = NO;
    self.btnTab5.hidden = NO;
    self.btnTab1.userInteractionEnabled=YES;
    self.btnTab2.userInteractionEnabled=YES;
    self.btnTab3.userInteractionEnabled=YES;
    self.btnTab4.userInteractionEnabled=YES;
    self.btnTab5.userInteractionEnabled=YES;
}
- (void)hideTabBar
{
    self.imgTabBg.hidden = YES;
    self.btnTab1.hidden = YES;
    self.btnTab2.hidden = YES;
    self.btnTab3.hidden = YES;
    self.btnTab4.hidden = YES;
    self.btnTab5.hidden = YES;
    self.btnTab1.userInteractionEnabled=NO;
    self.btnTab2.userInteractionEnabled=NO;
    self.btnTab3.userInteractionEnabled=NO;
    self.btnTab4.userInteractionEnabled=NO;
    self.btnTab5.userInteractionEnabled=NO;
}
#pragma mark -Load Nib
- (id)loadViewNib:(NSString *)nibName {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    if([nibs count] > 0) {
        return [nibs objectAtIndex:0];
    }
    return nil;
}
#pragma mark- player delegate method
-(void)pushSettingView
{
    
}
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:@"outputVolume"]) {
        NSLog(@"volume changed!");

    }
}


#pragma mark
-(void)currentPlayingStatusChanged:(AFSoundManagerStatus)status{
    NSLog(@"%d",status);
}
@end
