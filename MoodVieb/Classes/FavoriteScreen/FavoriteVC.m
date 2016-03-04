//
//  FavoriteVC.m
//  MoodVibe
//
//  Created by code-on on 8/28/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import "FavoriteVC.h"
#import "AppDelegate.h"

@interface FavoriteVC ()

@end

@implementation FavoriteVC
@synthesize aryTrack;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [Singleton sharedSingleton].currentViebMoreClick = -1;
    [imgviebvertical setImage:[[Singleton sharedSingleton] getLocalImage:self.verticalImage]];
    [self hidead];
    AppDelegate *appDel =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel.objCustomTabBar.customTabobj.btnFavorite setSelected:YES];
    
    
    
    //display add only if internet is available
    if ([[WebserviceCaller sharedSingleton] isconnectedToNetwork]) {
        [self performSelector:@selector(loadAd) withObject:nil afterDelay:5];
    }
    
    [lblCurrentSongTitle setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
    [lblCurrentSongArtist setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
    

    [self updatePlayInfo];
}


-(void)viewDidLayoutSubviews{
    
    CGRect frame = lblCurrentSongTitle.frame;
    frame.origin.x=0;
    frame.origin.y =10;
    frame.size.width = 30;
    frame.size.height = 400;
    lblCurrentSongTitle.frame = frame;
    
    CGRect frame1 = lblCurrentSongArtist.frame;
    frame1.origin.x=18;
    frame1.origin.y =10;
    frame1.size.width = 30;
    frame1.size.height = 300;
    lblCurrentSongArtist.frame = frame1;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self updatePlayInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReloadPlayInfo object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlayInfo) name:ReloadPlayInfo object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReloadFavTable object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadTabel) name:ReloadFavTable object:nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReloadSingleCell object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSingleCell) name:ReloadSingleCell object:nil];

    
    //aryTrack = [[DataManager shareddbSingleton] getFavList];
    [Singleton sharedSingleton].currentTrackMoreClick=-1;
    
}


-(void)setupThame{
    
    [btnBack setImage:[Theme sharedSingleton].TrackListBackIcon forState:UIControlStateNormal];
    
    lblCurrentSongTitle.textColor =[Theme sharedSingleton].TrackListcurrentsongTitleColor;
    lblCurrentSongTitle.font = [Theme sharedSingleton].TrackListcurrentsongTitleFont;
    
    lblCurrentSongArtist.textColor =[Theme sharedSingleton].TrackListcurrentsongArtistColor;
    lblCurrentSongArtist.font = [Theme sharedSingleton].TrackListcurrentsongArtistFont;
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    AppDelegate *appDel =(AppDelegate *)[[UIApplication sharedApplication] delegate];
   __block int i = appDel.aryVibes.count;
    for (VibeShare *shareobj in appDel.aryVibes) {
        //check if there is any track found for that vibe not save track again. it's tack some time to check already added tracks.
        
        if([[DataManager shareddbSingleton] checkFavTrackAdded:shareobj.VibeShare_id]){
            [[DataManager shareddbSingleton] saveTrack:[shareobj.arytracks mutableCopy] :shareobj.VibeShare_id success:^(BOOL responseData) {
                NSLog(@"%d",i);
                i -= 1;
                if(i==0){
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [self  ReloadTabel];
                }
            }];
        }else{
            i -= 1;
            if(i==0){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self  ReloadTabel];
            }
        }
    }
    [self updatePlayInfo];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}


#pragma mark
#pragma mark - table view delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [aryTrack count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TrackCustomCell *cell = (TrackCustomCell *)[tableView dequeueReusableCellWithIdentifier:@""];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TrackCustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.strIsFromFav =@"1";
    cell.shareObj =[aryTrack objectAtIndex:indexPath.row];
    [cell ApplyData];
    
    //setbutton actons
    cell.btnAbout.tag = indexPath.row;
    [cell.btnAbout removeTarget:self action:@selector(btnAboutArtistClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnAbout addTarget:self action:@selector(btnAboutArtistClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnMore.tag = indexPath.row + 100000;
    cell.btnHideMore.tag = indexPath.row + 100000;
    cell.moreview.tag = indexPath.row +1000000;

    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    tracksShare *shareobje = [aryTrack objectAtIndex:indexPath.row];
    
    NSLog(@"%@",shareobje.artist);
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int oldMoreClick=[Singleton sharedSingleton].currentTrackMoreClick;
    
    if (oldMoreClick!=-1 && oldMoreClick == (indexPath.row +100000)) {
        
        int indexpathrow = oldMoreClick - 100000;
        int viewmoretag = indexpathrow + +1000000;
        UIView *moreview = (UIView *)[self.view viewWithTag:viewmoretag];
        [moreview setHidden:NO];
        moreview.alpha = 1;
    }
}

#pragma mark
#pragma mark - button click
-(IBAction)btnBackClick:(id)sender{
    AppDelegate *appDel =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel.objCustomTabBar.customTabobj.btnFavorite setSelected:NO];

    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark
#pragma mark- advertisement methos

-(void)loadAd{
    AdShare *shareobj =[[Singleton sharedSingleton] getAd:@"sidebar"];
    __weak typeof(self) weakSelf = self;
    [imgAdBannr setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:shareobj.image]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        adImage = image;
        [weakSelf Showad];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    
}

-(void)Showad{
    [imgAdBannr setHidden:NO];
    [imgAdBannr setImage:adImage];
    [self performSelector:@selector(hidead) withObject:nil afterDelay:5];
    
}

-(void)hidead{
    [imgAdBannr setHidden:YES];
}


#pragma mark
#pragma mark - cell button click
-(IBAction)btnAboutArtistClick:(id)sender{
    
    tracksShare *shareObj =[aryTrack objectAtIndex:[sender tag]];
    
    ArtistDetailVC *artisDetailObj =[[ArtistDetailVC alloc] initWithNibName:@"ArtistDetailVC" bundle:nil];
    artisDetailObj.strArtistid = shareObj.artist_id;
    [self presentViewController:artisDetailObj animated:YES completion:^{
    }];
    
}

-(void)updatePlayInfo{
    NSDictionary *currentPlayInfo= [[MPNowPlayingInfoCenter defaultCenter]nowPlayingInfo];
    /*
     {
     albumTitle = "Vibe #1";
     artist = "Artist #1";
     artwork = "<MPMediaItemArtwork: 0x79687cc0>";
     title = "Track #1";
     }
     */
    lblCurrentSongArtist.text = [currentPlayInfo objectForKey:@"artist"];
    lblCurrentSongTitle.text = [[currentPlayInfo objectForKey:@"title"] uppercaseString];
    //get the current view from trackid;
    NSDictionary *dict=[[DataManager shareddbSingleton] getVibesDetail:[currentPlayInfo objectForKey:@"ViebId"]];
    NSString *verticalPath =[dict objectForKey:@"vertical_image_offline"];
    
    if (verticalPath !=nil) {
        [imgviebvertical setImage:[[Singleton sharedSingleton] getLocalImage:verticalPath]];
    }
     [self setupThame];
}
-(void)ReloadTabel{

    aryTrack = [[DataManager shareddbSingleton] getFavList];
    [tblView reloadData];

}

-(IBAction)btnDownloadView:(id)sender{

    // [[DataManager shareddbSingleton] downloadvieboffline:shareObj.VibeShare_id];

}

-(void)reloadSingleCell{
    int oldMoreClick=[Singleton sharedSingleton].currentTrackMoreClick;
    NSLog(@"%d",oldMoreClick);
    
    int indexpathrow = oldMoreClick - 100000;
    int viewmoretag = indexpathrow + +1000000;
    
    UIView *moreView = (UIView *)[self.view viewWithTag:viewmoretag];
    [UIView animateWithDuration:1 animations:^{
        moreView.alpha = 0;
        [moreView layoutIfNeeded];
    }completion:^(BOOL finished) {
        moreView.hidden = true;
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReloadPlayInfo object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReloadFavTable object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReloadSingleCell object:nil];
    
    [super viewWillDisappear:animated];
}
@end
