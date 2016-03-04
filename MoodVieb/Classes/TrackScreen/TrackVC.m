//
//  TrackVC.m
//  MoodVibe
//
//  Created by code-on on 8/11/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import "TrackVC.h"

@interface TrackVC ()

@end

@implementation TrackVC
@synthesize aryTrack;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    lblTrackTitle.text = [self.Tracktitle uppercaseString];
    
    //[Singleton sharedSingleton].currentViebMoreClick=-1;
    
    if ([[WebserviceCaller sharedSingleton] isconnectedToNetwork]) {
        [imgviebvertical setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.verticalImage] ] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            imgviebvertical.image = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        }];
    }else{
        NSString *path = [NSString stringWithFormat:@"%@/Vieb_vertical_%@.png",self.viebId,self.viebId];
        [imgviebvertical setImage:[[Singleton sharedSingleton] getLocalImage:self.verticalImage]];
    }
    [self updatePlayInfo];
    [self hidead];
    
    //display add only if internet is available
    if ([[WebserviceCaller sharedSingleton] isconnectedToNetwork]) {
        [self performSelector:@selector(loadAd) withObject:nil afterDelay:5];
    }
    
    [lblCurrentSongTitle setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
    [lblCurrentSongArtist setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
    
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
    
    aryTrack=[[DataManager shareddbSingleton] getTrackList:self.viebId];
    
    [tblView reloadData];
    [self updatePlayInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReloadPlayInfo object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlayInfo) name:ReloadPlayInfo object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReloadSingleCell object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSingleCell) name:ReloadSingleCell object:nil];
    
    [Singleton sharedSingleton].currentTrackMoreClick=-1;
    [tblView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updatePlayInfo];
    
}


-(void)setupThame{

    [btnDownload setImage:[Theme sharedSingleton].TrackListDownloadIcon forState:UIControlStateNormal];
    [btnBack setImage:[Theme sharedSingleton].TrackListBackIcon forState:UIControlStateNormal];
    
    lblCurrentSongTitle.textColor =[Theme sharedSingleton].TrackListcurrentsongTitleColor;
    lblCurrentSongTitle.font = [Theme sharedSingleton].TrackListcurrentsongTitleFont;
    
    lblCurrentSongArtist.textColor =[Theme sharedSingleton].TrackListcurrentsongArtistColor;
    lblCurrentSongArtist.font = [Theme sharedSingleton].TrackListcurrentsongArtistFont;
    
    
 
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

-(IBAction)btnDownloadView:(id)sender{
    
    NSString *offline;
    NSDictionary *dict = [[DataManager shareddbSingleton] getVibesDetail:self.viebId];
    VibeShare *shareObj=[[WebserviceCaller sharedSingleton] convertDictonary:[dict mutableCopy] :@"VibeShare"];
    
    if ([shareObj.isOffline isKindOfClass:[NSNumber class]]) {
        offline = [(NSNumber *)shareObj.isOffline stringValue];
    }else{
        offline =shareObj.isOffline;
    }
    
    
    if ([offline isEqualToString:@"0"]) {
        if ([[DataManager shareddbSingleton] checkDownloadCounter]) {
            [[WebserviceCaller sharedSingleton] AjNotificationView:@"Can not download more than 4 vibes." :AJNotificationTypeRed];
            return;
        }
    }
    
    if ([offline  isEqualToString:@"0"]) {
        if ([[WebserviceCaller sharedSingleton] isconnectedToNetwork]) {
            shareObj.isOffline=@"1";
            [[DataManager shareddbSingleton] downloadvieboffline:shareObj.VibeShare_id];
        }else{
            [[WebserviceCaller sharedSingleton] AjNotificationView:@"Connect Internet for offline listen" :AJNotificationTypeRed];
        }
        
    }else if ([offline  isEqualToString:@"2"] || [offline isEqualToString:@"1"]){
         shareObj.isOffline=@"0";
        [[DataManager shareddbSingleton] unDownloadvibe:shareObj.VibeShare_id];
        [[WebserviceCaller sharedSingleton] cancelDownload];
        [[NSNotificationCenter defaultCenter] postNotificationName:ReloadPlayInfo1 object:nil];
        
    }

}

-(void)reloadSingleCell{
    int oldMoreClick=[Singleton sharedSingleton].currentTrackMoreClick;
    
    int indexpathrow = oldMoreClick - 100000;
    int viewmoretag = indexpathrow + +1000000;
    
    UIView *moreView = (UIView *)[self.view viewWithTag:viewmoretag];
    [UIView animateWithDuration:0.25 animations:^{
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
