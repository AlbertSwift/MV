//
//  HomeVC.m
//  MoodVibe
//
//  Created by code-on on 8/7/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import "HomeVC.h"
#import "AppDelegate.h"
@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    appdel =(AppDelegate *)[[UIApplication sharedApplication] delegate];

    //reseet current more button tag
    //[Singleton sharedSingleton].currentViebMoreClick=-1;
    
    if ([[WebserviceCaller sharedSingleton] isconnectedToNetwork]) {
     
        NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
       [dic setObject:[[Singleton sharedSingleton] getUserDefault:userEMAIL] forKey:@"email"];
       [dic setObject:[[Singleton sharedSingleton] getUserDefault:activatCode] forKey:@"code"];
       [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       [[WebserviceCaller sharedSingleton] BaseWsCallGET:dic :@"vibes/" success:^(id responseData) {
           
           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
           aryVibe = [[NSMutableArray alloc] init];
           aryVibe =[[DataManager shareddbSingleton] getVibes];
           
           if([[DataManager shareddbSingleton] getVibes].count >= 1){
               aryVibe =[[DataManager shareddbSingleton] getVibes];
           }else{
               aryVibe =[[WebserviceCaller sharedSingleton] convertArray:[responseData objectForKey:@"vibes"] :@"VibeShare"];
           }
           
           [tblview reloadData];
           aryAd = [[NSMutableArray alloc] init];
           aryAd =[[WebserviceCaller sharedSingleton] convertArray:[responseData objectForKey:@"ads"] :@"AdShare"];
           [[Singleton sharedSingleton] setAdArray:aryAd];
           [self performSelector:@selector(loadAd) withObject:nil afterDelay:5];
           currentVibe = 0;
           appdel.aryVibes = [[WebserviceCaller sharedSingleton] convertArray:[responseData objectForKey:@"vibes"] :@"VibeShare"];
           
           [[Singleton sharedSingleton] setUserDefault:[responseData objectForKey:@"vibes"] :@"Listing"];
           __block int counter = (int)appdel.aryVibes.count;
           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
               for ( VibeShare *shareobj in appdel.aryVibes) {
                   [[DataManager shareddbSingleton] saveVibes:shareobj success:^(BOOL responseData) {
                       [[DataManager shareddbSingleton] downloadImages:shareobj success:^(BOOL responseData) {
                           counter -=1;
                           if(counter == 0){
                               [self Tracks];
                           }
                       }];
                   }];
              }
           });
           
           /*
           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
               for ( VibeShare *shareobj in aryVibe) {
                   [[DataManager shareddbSingleton] saveVibes:shareobj success:^(BOOL status) {
                       [[DataManager shareddbSingleton] downloadImages:shareobj success:^(BOOL responseData) {
                           
                           [[DataManager shareddbSingleton] saveTrack:[shareobj.arytracks mutableCopy] :shareobj.VibeShare_id success:^(BOOL responseData) {
                           }];
                           
                       }];
                   }];
               }
           });*/

        } Failure:^(id responseData) {
            
        }];
        
    }else{
        aryVibe =[[DataManager shareddbSingleton] getVibes];
        appdel.aryVibes = [[WebserviceCaller sharedSingleton] convertArray:[NSMutableArray arrayWithArray:[[Singleton sharedSingleton] getUserDefault:@"Listing"]] :@"VibeShare"];

        [[WebserviceCaller sharedSingleton] AjNotificationView:LocalizedString(@"KeyErrorInternet", nil) :AJNotificationTypeRed];
        
    }

    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReloadPlayInfo1 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:ReloadPlayInfo1 object:nil];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:homeReloadCell object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCell:) name:homeReloadCell object:nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReloadTable object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:ReloadTable object:nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReloadSingleCell object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSingleCell) name:ReloadSingleCell object:nil];
    

    [[NSNotificationCenter defaultCenter] removeObserver:self name:reorderCell object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReorderCell:) name:reorderCell object:nil];


    [[NSNotificationCenter defaultCenter] removeObserver:self name:reloadAllSlider object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadAllSlider:) name:reloadAllSlider object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Tablescroll object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TableScrollEnable) name:Tablescroll object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TablescrollDisable object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TableScrollDisable) name:TablescrollDisable object:nil];
    
    
}


#pragma mark
#pragma mark - table view delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [aryVibe count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    VibeCustomCell *cell = (VibeCustomCell *)[tableView dequeueReusableCellWithIdentifier:@""];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VibeCustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    cell.shareObj =[aryVibe objectAtIndex:indexPath.row];
    [cell ApplyData];
    cell.customTag  = indexPath.row;
    cell.tag = indexPath.row;
    UITapGestureRecognizer *panGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];

    [cell setUserInteractionEnabled:YES];
    cell.imgCoveerPic.tag = indexPath.row;
    [cell.imgCoveerPic addGestureRecognizer:panGesture];
    
    cell.horSlider.tag = indexPath.row+100;
    cell.lblpercentage.tag = indexPath.row + 10000;
    cell.btnpercantage.tag =indexPath.row + 10000;
    cell.btnMore.tag = indexPath.row + 100000;
    cell.moreView.tag = indexPath.row +1000000;
    return cell;
}
-(IBAction)handlePanGesture:(UITapGestureRecognizer *)sender
{

    VibeCustomCell *view = (VibeCustomCell *)sender.view;
    int taptag = (int)view.tag;
    int appdeltaptag= taptag;
    //check selected vibe index
    VibeShare *srobj = [aryVibe objectAtIndex:taptag];
    int i = 0;
    for (VibeShare *tempshare in appdel.aryVibes) {
        if([srobj.title isEqualToString:tempshare.title]){
            appdeltaptag = i;
            break;
        }
        i++;
    }
    
    VibeShare *shareobj = [appdel.aryVibes objectAtIndex:appdeltaptag];
    
    
    [[DataManager shareddbSingleton] saveTrack:[shareobj.arytracks mutableCopy] :shareobj.VibeShare_id success:^(BOOL responseData) {
        
        TrackVC *trackDetailObj =[[TrackVC alloc] initWithNibName:@"TrackVC" bundle:nil];
        VibeShare *shareObj =[aryVibe objectAtIndex:taptag];
        trackDetailObj.aryTrack = shareObj.arytracks;
        trackDetailObj.Tracktitle = shareObj.title;
        trackDetailObj.viebId = shareObj.VibeShare_id;
        if ([[WebserviceCaller sharedSingleton] isconnectedToNetwork]) {
            trackDetailObj.verticalImage = shareObj.vertical_image;
            
        }else{
            trackDetailObj.verticalImage = shareObj.vertical_image_offline;
        }
        [self.navigationController pushViewController:trackDetailObj animated:YES];
        [[DataManager shareddbSingleton] downloadTrackImages:[[[DataManager shareddbSingleton] getTrackList:shareobj.VibeShare_id] mutableCopy] success:^(BOOL responseData) {
            
        }];
    }];

    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    TrackVC *trackDetailObj =[[TrackVC alloc] initWithNibName:@"TrackVC" bundle:nil];
    VibeShare *shareObj =[aryVibe objectAtIndex:indexPath.row];
    trackDetailObj.aryTrack = shareObj.arytracks;
    trackDetailObj.Tracktitle = shareObj.title;
    trackDetailObj.viebId = shareObj.VibeShare_id;
    if ([[WebserviceCaller sharedSingleton] isconnectedToNetwork]) {
        trackDetailObj.verticalImage = shareObj.vertical_image;

    }else{
        trackDetailObj.verticalImage = shareObj.vertical_image_offline;
    }
    [self.navigationController pushViewController:trackDetailObj animated:YES];*/
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    int oldMoreClick=[Singleton sharedSingleton].currentViebMoreClick;
    if (oldMoreClick!=-1 && oldMoreClick == (indexPath.row +100000)) {
        int indexpathrow = oldMoreClick - 100000;
        int viewmoretag = indexpathrow + +1000000;
        UIView *moreview = (UIView *)[self.view viewWithTag:viewmoretag];
        [moreview setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark
#pragma mark - advertisement
-(void)loadAd{
    AdShare *shareobj =[[Singleton sharedSingleton] getAd:@"fullscreen"];
    __weak typeof(self) weakSelf = self;
    [imgView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:shareobj.image]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        adImage = image;
        [weakSelf Showad];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"error");
    }];
    
}

-(void)Showad{
    FulladsVC *adObj = [[FulladsVC alloc] initWithNibName:@"FulladsVC" bundle:nil];
    adObj.adImage = adImage;
    [self presentViewController:adObj animated:YES completion:^{
        
    }];
}

-(void)reloadSimpleCell:(NSNotification*)notification{
    
    int i=0;
    NSDictionary* userInfo = notification.userInfo;
    for (VibeShare *share in aryVibe) {
        if (share.VibeShare_id == [userInfo objectForKey:@"currentVieb"]) {\
            NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:i inSection:0];
            NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
            [tblview reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
            
        }
        i++;
    }
}

-(void)reloadCell:(NSNotification*)notification{

  /*  NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:1 inSection:0];
    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [tblview reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
  */
    //get the index of vide
    
    int i=0;
    NSDictionary* userInfo = notification.userInfo;
    
    for (VibeShare *share in aryVibe) {
        if (share.isInPlaylist == YES && share.VibeShare_id != [userInfo objectForKey:@"currentVieb"]) {
            RS_SliderView *slider1 = (RS_SliderView *)[self.view viewWithTag:i+100];
            VibeShare *pershare = [[DataManager shareddbSingleton] getPlayListDetail:share];
            float per = pershare.percentage;
            
           // NSLog(@"Slider Tag:%d,Slider old value:%f,Slider %f",slider1.tag,slider1.value,per);
            
            if (slider1.value != per) {
                [slider1 setValue:per withAnimation:true completion:^(BOOL finished) {
                    //share.percentage  = per;
                    UIButton *lbl =(UIButton *)[self.view viewWithTag:i+10000];
                    [lbl setTitle:[NSString stringWithFormat:@"%d%%",(int)([[NSString stringWithFormat:@"%0.2f",per] floatValue] * 100)] forState:UIControlStateNormal];
                    
                }];
            }
        }
        i++;
    }
 
}

-(void)reloadTable:(id)sender{
    //reset aryvibe
    aryVibe =[[DataManager shareddbSingleton] getVibes];
    [tblview reloadData];

}

-(void)reloadSingleCell{
    int oldMoreClick=[Singleton sharedSingleton].currentViebMoreClick;
    NSLog(@"%d",oldMoreClick);
    
    int indexpathrow = oldMoreClick - 100000;
    int viewmoretag = indexpathrow + +1000000;

    UIView *moreView = (UIView *)[self.view viewWithTag:viewmoretag];
    moreView.hidden = true;

    [UIView animateWithDuration:1 animations:^{
        CGRect frame = moreView.frame;
        frame.size.height = 00;
        frame.origin.y = 175;
        moreView.frame = frame;
        [moreView layoutIfNeeded];
    }completion:^(BOOL finished) {
        moreView.hidden = true;
    }];
}


-(void)ReorderCell:(NSNotification *) notification{
   //  NSDictionary* userInfo = notification.userInfo;
/*    int from =[[userInfo objectForKey:@"from"] integerValue];
    [tblview moveRowAtIndexPath:0 toIndexPath:[NSIndexPath indexPathForRow:from inSection:0]];
  */
    
    aryVibe =[[DataManager shareddbSingleton] getVibes];
    [tblview reloadData];

    /*
    id object = [aryVibe objectAtIndex:from];
    [aryVibe removeObjectAtIndex:from];
    [aryVibe insertObject:object atIndex:0];*/
}

-(void)ReloadAllSlider:(NSNotification *) notification{
    NSDictionary* userInfo = notification.userInfo;
    aryVibe =[[DataManager shareddbSingleton] getVibes];
    for (VibeShare *shareObj in aryVibe) {
        if (shareObj.isInPlaylist) {
            //NSLog(@"%@",shareObj.VibeShare_id);
            
            if ([[userInfo objectForKey:@"isShow"] boolValue]) {
                shareObj.isSliderShow=YES;
            }else{
                shareObj.isSliderShow=NO;
            }
        }
    }
    
    [tblview reloadData];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:homeReloadCell object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReloadTable object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReloadSingleCell object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:reloadAllSlider object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:Tablescroll object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:TablescrollDisable object:nil];

    [super viewDidDisappear:animated];
    
}


-(void)TableScrollEnable{
    tblview.scrollEnabled=YES;
}
-(void)TableScrollDisable{
    tblview.scrollEnabled=NO;
}


-(void)Tracks{
    //download tracks if internet is availble
   __block int index;
    if([[[Singleton sharedSingleton] getUserDefault:@"Index"]  isEqual: @""]){
        index = 0;
    }else{
        index = [[[Singleton sharedSingleton] getUserDefault:@"Index"] intValue];
    }
  NSMutableArray *ary = [[WebserviceCaller sharedSingleton] convertArray:[NSMutableArray arrayWithArray:[[Singleton sharedSingleton] getUserDefault:@"Listing"]] :@"VibeShare"];
    if(ary.count > index){
        VibeShare *shareobj = [ary objectAtIndex:index];
        [[DataManager shareddbSingleton] downloadTrackImages1:[shareobj.arytracks mutableCopy] :shareobj.VibeShare_id success:^(BOOL responseData) {
            index += 1;
            NSLog(@"Index:%d",index);
            [[Singleton sharedSingleton] setUserDefault:[NSString stringWithFormat:@"%d",index] :@"Index"];
            [self Tracks];
        }];
    }
    
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
