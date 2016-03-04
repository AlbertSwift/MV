//
//  DataManager.m
//  IdeaManagemenet
//
//  Created by code-on on 4/3/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

/*
 Notes:
 is_publish 
 = 0 =>Not sync
 = 1 =>sync with server
 */

#import "DataManager.h"

@implementation DataManager
static DataManager *singletonObj = NULL;
static SKDatabase *db = NULL;

+ (DataManager *)shareddbSingleton {
    @synchronized(self) {
        if (singletonObj == NULL)
            singletonObj = [[self alloc] init];
            db=[[SKDatabase alloc]initWithFile:@"MoodVieb.sqlite"];
    }
    return(singletonObj);
}
-(void)saveVibes:(VibeShare *)vibeshare success:(DBMasterSuccessBlock)successBlock{
    
    NSString *Vibe_id = vibeshare.VibeShare_id;
    NSString *Vibe_title = [vibeshare.title stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
    
    NSString *Vibe_image = vibeshare.image;
    NSString *vertical_image = vibeshare.vertical_image;
    NSString *qry;
    if ([self checkId:@"id" :Vibe_id :@"vibes"]) {
        /*NSString *getimage = [NSString stringWithFormat:@"select * from vibes where id='%@'",Vibe_id];
        NSDictionary *dict = [db lookupRowForSQL:getimage];
        int change=0;
        if (Vibe_image != [dict objectForKey:@"image"]) {
            change=1;
        }
        if (vertical_image != [dict objectForKey:@"vertical_image"]) {
            change=1;
        }
        qry =[NSString stringWithFormat:@"update vibes set title='%@',image='%@',vertical_image='%@',is_update='%d' where id = '%@'",Vibe_title,Vibe_image,vertical_image,change,Vibe_id];*/
        successBlock(true);
    }else{
        
        qry =[NSString stringWithFormat:@"insert into vibes(id,title,image,vertical_image,is_update) values('%@',\"%@\",'%@','%@','1')",Vibe_id,Vibe_title,Vibe_image,vertical_image];
        //[self saveTracks:[dict objectForKey:@"tracks"] :Vibe_id];
        [db performSQL:qry];
        
        successBlock(true);
    }


//    [self saveTrack:[vibeshare.arytracks mutableCopy] :vibeshare.VibeShare_id success:^(BOOL responseData) {
//        successBlock(true);
//     }];

    
    //    [self downloadImages:vibeshare success:^(BOOL responseData) {
//                    successBlock(true);
//    }];
    
}


-(void)saveTrack:(NSMutableArray *)ary :(NSString *)Vibe_id success:(DBMasterSuccessBlock)successBlock{

    if ([ary count] >= 1) {
        tracksShare *dict = [ary objectAtIndex:0];
        //NSString *Vibe_id = [[dict objectForKey:@"id"] stringValue];
        //[self saveTracks:[dict objectForKey:@"tracks"] :Vibe_id];
        NSLog(@"%@",Vibe_id);
        [self saveTracks:dict :Vibe_id success:^(BOOL responseData) {
            [ary removeObjectAtIndex:0];
            [self saveTrack:ary :Vibe_id success:^(BOOL responseData) {
                successBlock(TRUE);
            }];
        }];
    }else{
        successBlock(true);
        //[self downloadImages];
    }

}
-(void)saveTracks:(tracksShare *)trackshare :(NSString *)viebId success:(DBMasterSuccessBlock)successBlock{

    NSString *track_id = trackshare.tracksShare_id;
    NSString *track_title = trackshare.title;
    track_title = [track_title stringByReplacingOccurrencesOfString:@"'" withString:@""];
    NSString *track_artist = trackshare.artist;
    NSString *track_artist_image = trackshare.artist_image;
    NSString *track_artist_id = trackshare.artist_id;
    NSString *track_url;
    track_url = trackshare.url;
    
#ifdef DEBUG
    // track_url = @"http://www.noiseaddicts.com/samples_1w72b820/2553.mp3";
#endif
    
    NSString *track_is_favorite = [NSString stringWithFormat:@"%u",trackshare.is_favorite];
    NSString *track_is_dislike = [NSString stringWithFormat:@"%u",trackshare.is_dislike];
    NSString *qry;
    if ([self checkId:@"id" :track_id :@"tracks"]) {
        
        /*NSString *getimage = [NSString stringWithFormat:@"select artist_image from tracks where id='%@'",track_id];
        NSDictionary *dict = [db lookupRowForSQL:getimage];
        int change=0;
        if (track_artist_image != [dict objectForKey:@"artist_image"]) {
            change=1;
        }
        
        
        qry=[NSString stringWithFormat:@"update tracks set title='%@',artist_id='%@',artist='%@',artist_image='%@',url='%@',is_favorite='%@',is_dislike='%@',set is_update='%d' where id='%@' and vibes_id='%@'",track_title,track_artist_id,track_artist,track_artist_image,track_url,track_is_favorite,track_is_dislike,change,track_id,viebId];
        //[db performSQL:qry];*/
            successBlock(true);
    }else{
        
        NSString *guidName =[[track_artist_image componentsSeparatedByString:@"/"] lastObject];
        NSString *offlineguidName = [NSString stringWithFormat:@"%@/%@",viebId,guidName];

        qry =[NSString stringWithFormat:@"insert into tracks(id,title,artist,artist_image,url,is_favorite,is_dislike,vibes_id,artist_id,isDownloading,artist_image_offline,is_update) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','0','%@','1')",track_id,track_title,track_artist,track_artist_image,track_url,track_is_favorite,track_is_dislike,viebId,track_artist_id,offlineguidName];
        [db performSQL:qry];
        successBlock(true);
        //[self saveFavorite:track_id :track_is_favorite];
        //[self saveLikes:track_id :track_is_dislike];
        
    }

}


-(void)downloadImages:(VibeShare *)shareobj success:(DBMasterSuccessBlock)successBlock{

    NSString *guidName =[NSString stringWithFormat:@"Vieb_%@.png",shareobj.VibeShare_id];
    //vertical images
    NSString *VerticalguidName =[NSString stringWithFormat:@"Vieb_vertical_%@.png",shareobj.VibeShare_id];
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* foofile = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",shareobj.VibeShare_id,guidName]];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];

    if(fileExists){
        successBlock(true);
    }else{
        [[WebserviceCaller sharedSingleton] downloadImage:shareobj.image :guidName :shareobj.VibeShare_id :-1 success:^(id responseData) {
            NSString *viebId = [responseData objectForKey:@"vieb_id"];
            NSString *fileName = [NSString stringWithFormat:@"%@/%@",viebId,[responseData objectForKey:@"imageName"]];
            NSString *updateqry = [NSString stringWithFormat:@"update vibes set is_update='0',image_offline='%@' where id='%@'",fileName,viebId];
            [db performSQL:updateqry];
            
            [[WebserviceCaller sharedSingleton] downloadImage:shareobj.vertical_image :VerticalguidName :shareobj.VibeShare_id :-1 success:^(id responseData) {
                
                NSString *viebId = [responseData objectForKey:@"vieb_id"];
                NSString *fileName = [NSString stringWithFormat:@"%@/%@",viebId,[responseData objectForKey:@"imageName"]];
                NSString *updateqry = [NSString stringWithFormat:@"update vibes set is_update='0',vertical_image_offline='%@' where id='%@'",fileName,viebId];
                [db performSQL:updateqry];
                successBlock(true);
            }];
        }];
    }
    
   
    
}

-(void)downloadTrackImages:(NSMutableArray *)ary success:(DBMasterSuccessBlock)successBlock{
    
    if ([ary count] >= 1) {
        tracksShare *dict = [ary objectAtIndex:0];
        [self downloadTrackImage:dict success:^(BOOL responseData) {
            [ary removeObjectAtIndex:0];
            [self downloadTrackImages:ary success:^(BOOL responseData) {
                successBlock(true);
            }];
        }];
    }else{
        successBlock(true);
        //[self downloadImages];
    }
}

-(void)downloadTrackImage:(tracksShare *)shareobj success:(DBMasterSuccessBlock)successBlock{
    
    NSString *guidName =[[shareobj.artist_image componentsSeparatedByString:@"/"] lastObject];
    int directory = [shareobj.vibes_id intValue];

    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* foofile = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",shareobj.vibes_id,guidName]];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
    
    if(fileExists){
        successBlock(true);
    }else{
        [[WebserviceCaller sharedSingleton] downloadImage:shareobj.artist_image :guidName :shareobj.tracksShare_id :directory success:^(id responseData) {
            successBlock(true);
        }];
    }
    
    
    
    /*
    //check if artist image already downloaded.
    NSArray *aryartist = [self checkArtistImageDownload:shareobj.artist_id];
    if ([aryartist count] >= 1){
        NSDictionary *dict = [aryartist objectAtIndex:0];
        NSString *viebId    = [dict objectForKey:@"id"];
        NSString *fileName  = [dict objectForKey:@"artist_image_offline"];
        NSString *updateqry = [NSString stringWithFormat:@"update tracks set is_update='0',artist_image_offline='%@' where id='%@'",fileName,viebId];
        [db performSQL:updateqry];
        successBlock(true);
    }else{
        NSString *guidName =[NSString stringWithFormat:@"track_%@.png",shareobj.tracksShare_id];
        int directory = [shareobj.vibes_id intValue];
        [[WebserviceCaller sharedSingleton] downloadImage:shareobj.artist_image :guidName :shareobj.tracksShare_id :directory success:^(id responseData) {
            //NSLog(@"%@",responseData);
            NSString *viebId = [responseData objectForKey:@"vieb_id"];
            NSString *fileName = [NSString stringWithFormat:@"%@/%@",[NSString stringWithFormat:@"%d",directory],[responseData objectForKey:@"imageName"]];
            NSString *updateqry = [NSString stringWithFormat:@"update tracks set is_update='0',artist_image_offline='%@' where id='%@'",fileName,viebId];
            [db performSQL:updateqry];
            successBlock(true);
        }];
    }*/
}


-(void)downloadTrackImages1:(NSMutableArray *)ary :(NSString *)vibeid success:(DBMasterSuccessBlock)successBlock{
    
    if ([ary count] >= 1) {
        tracksShare *dict = [ary objectAtIndex:0];
        [self downloadTrackImage1:dict :vibeid success:^(BOOL responseData) {
            [ary removeObjectAtIndex:0];
            [self downloadTrackImages1:ary :vibeid success:^(BOOL responseData) {
                successBlock(true);
            }];
        }];
    }else{
        successBlock(true);
        //[self downloadImages];
    }
}

-(void)downloadTrackImage1:(tracksShare *)shareobj :(NSString *)vibeid success:(DBMasterSuccessBlock)successBlock{
    
    NSString *guidName =[[shareobj.artist_image componentsSeparatedByString:@"/"] lastObject];
    int directory = [vibeid intValue];
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* foofile = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",vibeid,guidName]];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
    
    if(fileExists){
        successBlock(true);
    }else{
        [[WebserviceCaller sharedSingleton] downloadImage:shareobj.artist_image :guidName :shareobj.tracksShare_id :directory success:^(id responseData) {
            successBlock(true);
        }];
    }
    
}


/*
-(void)saveVibes:(NSMutableDictionary *)dict success:(DBMasterSuccessBlock)successBlock{
 
    //if ([ary count]>=1) {
        //NSMutableDictionary *dict = [ary objectAtIndex:0];
        NSString *Vibe_id = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        NSString *Vibe_title = [dict objectForKey:@"title"];
        NSString *Vibe_image = [dict objectForKey:@"image"];
        NSString *vertical_image = [dict objectForKey:@"vertical_image"];
        
        NSString *qry;
        if ([self checkId:@"id" :Vibe_id :@"vibes"]) {
            //update content
            //check if image change
            
            NSString *getimage = [NSString stringWithFormat:@"select * from vibes where id='%@'",Vibe_id];
            NSDictionary *dict = [db lookupRowForSQL:getimage];
            int change=0;
            if (Vibe_image != [dict objectForKey:@"image"]) {
                change=1;
            }
            if (vertical_image != [dict objectForKey:@"vertical_image"]) {
                change=1;
            }
            
            qry =[NSString stringWithFormat:@"update vibes set title='%@',image='%@',vertical_image='%@',is_update='%d' where id = '%@'",Vibe_title,Vibe_image,vertical_image,change,Vibe_id];
            //[self saveTracks:[dict objectForKey:@"tracks"] :Vibe_id ];
        }else{
            //save content
            qry =[NSString stringWithFormat:@"insert into vibes(id,title,image,vertical_image,is_update) values('%@','%@','%@','%@','1')",Vibe_id,Vibe_title,Vibe_image,vertical_image];
            //[self saveTracks:[dict objectForKey:@"tracks"] :Vibe_id];
        }
        [db performSQL:qry];
        
    [self saveTrack:[[dict objectForKey:@"tracks"] mutableCopy] :Vibe_id success:^(BOOL responseData) {
            /*NSLog(@"%@",[dict valueForKey:@"id"]);
            [ary removeObjectAtIndex:0];
            [self saveVibes:ary success:^(BOOL responseData) {
                successBlock(TRUE);
            }];
        }];
//    }else{
//        successBlock(TRUE);
//    }
    
    //download all images in background
    //[self saveTrack:[ary mutableCopy]];
    //[self downloadImages];
    //[self downloadTrackImages:@"1"];
}


-(void)saveTrack:(NSMutableArray *)ary :(NSString *)Vibe_id success:(DBMasterSuccessBlock)successBlock{
   
    if ([ary count] >= 1) {
        NSMutableDictionary *dict = [ary objectAtIndex:0];
        //NSString *Vibe_id = [[dict objectForKey:@"id"] stringValue];
        //[self saveTracks:[dict objectForKey:@"tracks"] :Vibe_id];
        NSLog(@"%@",Vibe_id);
        [self saveTracks:dict :Vibe_id success:^(BOOL responseData) {
                [ary removeObjectAtIndex:0];
            [self saveTrack:ary :Vibe_id success:^(BOOL responseData) {
                    successBlock(TRUE);
                }];
            }];

        
    }else{
        successBlock(true);
       //[self downloadImages];
    }
}

-(void)saveTracks:(NSDictionary *)dict :(NSString *)viebId success:(DBMasterSuccessBlock)successBlock{

        @try {
            NSLog(@"%@",dict);
            //NSDictionary *dict = (NSDictionary *)[ary objectAtIndex:0];
            // NSString *Vibe_id = [[dict objectForKey:@"id"] stringValue];
                NSString *track_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
                
                
                NSString *track_title = [dict objectForKey:@"title"];
                track_title = [track_title stringByReplacingOccurrencesOfString:@"'" withString:@""];
                
                NSString *track_artist = [dict objectForKey:@"artist"];
                NSString *track_artist_image = [dict objectForKey:@"artist_image"];
                NSString *track_artist_id = (NSString *)[dict objectForKey:@"artist_id"];
                
                NSString *track_url;
                track_url = [dict objectForKey:@"url"];
                
#ifdef DEBUG
                // track_url = @"http://www.noiseaddicts.com/samples_1w72b820/2553.mp3";
#endif
                
                NSString *track_is_favorite = [[dict objectForKey:@"is_favorite"] stringValue];
                NSString *track_is_dislike = [[dict objectForKey:@"is_dislike"] stringValue];
                NSString *qry;
                if ([self checkId:@"id" :track_id :@"tracks"]) {
                    
                    NSString *getimage = [NSString stringWithFormat:@"select * from tracks where id='%@'",track_id];
                    NSDictionary *dict = [db lookupRowForSQL:getimage];
                    int change=0;
                    if (track_artist_image != [dict objectForKey:@"artist_image"]) {
                        change=1;
                    }
                    
                    
                    qry=[NSString stringWithFormat:@"update tracks set title='%@',artist_id='%@',artist='%@',artist_image='%@',url='%@',is_favorite='%@',is_dislike='%@',set is_update='%d' where id='%@' and vibes_id='%@'",track_title,track_artist_id,track_artist,track_artist_image,track_url,track_is_favorite,track_is_dislike,change,track_id,viebId];
                    [db performSQL:qry];
                }else{
                    qry =[NSString stringWithFormat:@"insert into tracks(id,title,artist,artist_image,url,is_favorite,is_dislike,vibes_id,artist_id,isDownloading,is_update) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','0','1')",track_id,track_title,track_artist,track_artist_image,track_url,track_is_favorite,track_is_dislike,viebId,track_artist_id];
                    [db performSQL:qry];
                    
                    //[self saveFavorite:track_id :track_is_favorite];
                    //[self saveLikes:track_id :track_is_dislike];
                 
                }
                successBlock(true);
            }
            @catch (NSException *exception) {
                NSLog(@"Exception:%@",exception);
            }
    
}
*/

-(BOOL)checkId :(NSString *)strcolId :(NSString *)strId :(NSString *)tableName{
    NSString *strNameTemp = (NSString *)tableName;
    NSString *strStrcolIDT = (NSString *)strcolId;
    NSString *strIDT= (NSString *)strId;
    NSString *qry = [NSString stringWithFormat:@"select * from %@ where %@='%@'",strNameTemp,strStrcolIDT,strIDT];
    NSArray *ary =[db lookupAllForSQL:qry];
    
    if ([ary count]>=1) {
        return true;
    }else{
        return false;
    }
}



-(NSMutableArray *)getVibes{
    NSMutableArray *returnary =[[NSMutableArray alloc] init];
    NSString *playqry =@"select vieb_id from myPlayList order by rowid desc";
    NSArray *playlistary = [db lookupAllForSQL:playqry];
    for (NSMutableDictionary *dict in playlistary) {
        NSDictionary *vibedict = [self getVibesDetail:[dict objectForKey:@"vieb_id"]];
        VibeShare *shareobj = [[WebserviceCaller sharedSingleton] convertDictonary:[vibedict mutableCopy] :@"VibeShare"];
        shareobj.isInPlaylist=YES;
        NSString *trackQry =[NSString stringWithFormat:@"select * from tracks where vibes_id ='%@'",[dict objectForKey:@"vieb_id"]];
        NSArray *trackary=[db lookupAllForSQL:trackQry];
        shareobj.arytracks =[[WebserviceCaller sharedSingleton] convertArray:trackary :@"tracksShare"];
        [returnary addObject:shareobj];
        
    }
    
    NSString *qry =@"select * from vibes  where id not  in(select vieb_id from myPlayList ) order by id";
    NSArray *ary =[db lookupAllForSQL:qry];
    for (NSMutableDictionary *dict in ary) {
        VibeShare *shareobj = [[WebserviceCaller sharedSingleton] convertDictonary:dict :@"VibeShare"];
        NSString *trackQry =[NSString stringWithFormat:@"select * from tracks where vibes_id ='%@'",[dict objectForKey:@"id"]];
        NSArray *trackary=[db lookupAllForSQL:trackQry];
        shareobj.arytracks =[[WebserviceCaller sharedSingleton] convertArray:trackary :@"tracksShare"];
        [returnary addObject:shareobj];
    }
    
    return returnary;
}
-(NSDictionary *)getVibesDetail:(NSString *)viebId{
    NSString *qry = [NSString stringWithFormat:@"select * from vibes where id='%@'",viebId];
    NSDictionary *dict = [db lookupRowForSQL:qry];
    return dict;
}

-(NSArray *)getListOfTrackFromPer:(NSString *)vieb_id :(float)percantage{
    
    NSString *per = [NSString stringWithFormat:@"select    round((count(*)*%f)) as total from tracks where vibes_id='%@' and is_dislike !='1'",percantage,vieb_id];
    NSDictionary *limitDic =[db lookupRowForSQL:per];
    int total =[[limitDic objectForKey:@"total"] intValue];
    NSString *trackQry =[NSString stringWithFormat:@"select id,vibes_id from tracks where vibes_id ='%@'and is_dislike !='1' order by RANDOM() limit 0,%d",vieb_id,total];
    NSArray *trackary=[db lookupAllForSQL:trackQry];
    NSMutableArray *shareAry= [[WebserviceCaller sharedSingleton] convertArray:trackary :@"tracksShare"];
    return shareAry;

}

-(NSArray *)getTrackList:(NSString *)viebId{
    
    NSString *qry =[NSString stringWithFormat:@"select * from tracks where vibes_id='%@'",viebId];
    NSArray *ary =[db lookupAllForSQL:qry];
    NSArray *trackList =[[WebserviceCaller sharedSingleton] convertArray:ary :@"tracksShare"];
    return trackList;
}

#pragma mark
#pragma mark - playlist 
//new based on client chagne
-(void)updateAllMyPlaylist:(int)totalSelVibe{
    
    float per;
    //int totalSelVibe = [[DataManager shareddbSingleton] CountSelectedPlaylist];
    per =(float) 1.0/totalSelVibe;
    NSString *qry=[NSString stringWithFormat:@"update myPlayList set per='%.2f'",per];
    [db performSQL:qry];
    
}

-(void)addintoPlaylist:(int)vibeId :(float)per{
    
    NSString *qry;
    //first check if data exists
    if ([self checkId:@"vieb_id" :[NSString stringWithFormat:@"%d",vibeId] :@"myPlayList"]) {
        //update percantage
        qry=[NSString stringWithFormat:@"update myPlayList set per='%.2f' where vieb_id='%d'",per,vibeId];
    }else{
        //insert data with percantage
        qry = [NSString stringWithFormat:@"insert into myPlayList(vieb_id,per) values('%d','%.2f')",vibeId,per];
    }
    [db performSQL:qry];
}

-(void)removePlaylist:(int)vibeId{
    NSString *qry =[NSString stringWithFormat:@"delete from myPlayList where vieb_id='%d'",vibeId];
    [db performSQL:qry];
    
    NSString *removeTrack =[NSString stringWithFormat:@"delete from myTrack where vieb_id ='%d'",vibeId];
    [db performSQL:removeTrack];
   
    //check is there any other vibe in list if not then remove all track (favorite songs)
    NSString *qryVi=[NSString stringWithFormat:@"select count(*)as counter from myPlayList"];
    NSDictionary *dict = [db lookupRowForSQL:qryVi];
    if ([[dict objectForKey:@"counter"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
        NSLog(@"Reemove");
        NSString *removeTrack1 =[NSString stringWithFormat:@"delete from myTrack"];
        [db performSQL:removeTrack1];
    }
    
    
}

-(VibeShare *)getPlayListDetail:(VibeShare *)shareobj{
    NSString *qry =[NSString stringWithFormat:@"select * from myPlayList where vieb_id='%@'",shareobj.VibeShare_id];
    NSArray *ary =[db lookupAllForSQL:qry];
    if ([ary count] > 0 ) {
        NSMutableDictionary *dict = [ary objectAtIndex:0];
        shareobj.isInPlaylist =YES;
        shareobj.percentage = [[dict objectForKey:@"per"] floatValue];
    }else{
        shareobj.isInPlaylist =NO;
        shareobj.percentage =0;
    }
    return shareobj;
}
-(int)CountSelectedPlaylist{
    NSString *qry =[NSString stringWithFormat:@"select count(*) as sum from myPlayList"];
    NSMutableDictionary *dict = [[db lookupRowForSQL:qry] mutableCopy];
    return [[dict objectForKey:@"sum"] floatValue];
}

-(float)getTotalPercentage{
    NSString *qry =[NSString stringWithFormat:@"select sum(per) as sum from myPlayList"];
 NSMutableDictionary *dict = [[db lookupRowForSQL:qry] mutableCopy];
    return [[dict objectForKey:@"sum"] floatValue];
}


-(NSArray *)getListOfAllPlaylist{
    
    NSString *qry =[NSString stringWithFormat:@"select vieb_id,per from myPlayList"];
    NSArray *ary = [db lookupAllForSQL:qry];
    return ary;
    
}

//update playlist percentage
-(void)updatePercentage:(int)vibeId :(float)per{
    
    double per1 = [[NSString stringWithFormat:@"%0.2f",per] floatValue];
    NSString *qry =[NSString stringWithFormat:@"update myPlayList set per='%.2f' where vieb_id='%d'",per,vibeId];
    [db performSQL:qry];
    float remaningPer =  1.0f - per1;
    NSString *totalRemaningQry = [NSString stringWithFormat:@"select sum(per) as sum,count(*) as counter from myPlayList where vieb_id != '%d'",vibeId];
    NSDictionary *dic = [db lookupRowForSQL:totalRemaningQry];
    float sum = [[dic objectForKey:@"sum"] floatValue];
    int counter =[[dic objectForKey:@"counter"] intValue];
    float incremented = (sum - remaningPer)/counter;
   // NSLog(@"sum:%f,increment:%f",sum,incremented);
    NSString *remaningPlaylistQry =[NSString stringWithFormat:@"select * from myPlayList where vieb_id != '%d'",vibeId];
    for (NSMutableDictionary *dict in [db lookupAllForSQL:remaningPlaylistQry]) {
       float per =  [[dict objectForKey:@"per"] floatValue] - incremented;
        if (per<0) {
            per = -per;
        }else if (per>1) {
            per = per -1;
        }
        
        NSString *updateqry =[NSString stringWithFormat:@"update myPlayList set per = '%.2f' where vieb_id='%@'",per,[dict objectForKey:@"vieb_id"]];
        [db performSQL:updateqry];
        
    }
    
}


#pragma mark - favorite track

-(void)favTrack:(NSString *)trackid :(NSString *)favStatus{
    NSString *qry =[NSString stringWithFormat:@"update tracks set is_favorite='%@' where id='%@'",favStatus,trackid];
    [db performSQL:qry];
    
    //remove track from my playslit if exists
    if ([favStatus isEqualToString:@"0"]) {
        NSString *playlistQry= [NSString stringWithFormat:@"delete from myTrack where track_id='%@'",trackid];
        [db performSQL:playlistQry];
    }
}

-(void)likeTrack:(NSString *)trackid :(NSString *)likeStatus{
   
    NSString *qry =[NSString stringWithFormat:@"update tracks set is_dislike='%@' where id='%@'",likeStatus,trackid];
    if ([likeStatus isEqualToString:@"1"]) {
        //check if song in playlist then remove from playlist
        NSString *checkqry=[NSString stringWithFormat:@"delete from myTrack where track_id='%@'",trackid];
        [db performSQL:checkqry];
    }
    [db performSQL:qry];
}

#pragma mark -myplay track
-(void)addtrack:(NSString *)vieb_id :(NSString *)trackid{
    
    NSString *countQry = [NSString stringWithFormat:@"select count(*)as counter from myTrack where vieb_id='%@' and track_id='%@'",vieb_id,trackid];
    NSDictionary *Countdict = [db lookupRowForSQL:countQry];
    
    if ([[Countdict objectForKey:@"counter"] integerValue]>=1) {
        //update
    }else{
        //insert
        NSString *insQry = [NSString stringWithFormat:@"insert into myTrack(vieb_id,track_id) values('%@','%@')",vieb_id,trackid];
        [db performSQL:insQry];
    }
    
}

-(void)clearTrack{
    NSString *qry =@"delete from myTrack";
    [db performSQL:qry];
    
}

-(NSArray *)getMyTracks{
    
    NSString *qry = @"select * from myPlayList";
    NSArray *ary = [db lookupAllForSQL:qry];
    if ([ary count]>=1) {
        NSString *qry = @"select * from myTrack";
        NSArray *ary1 = [db lookupAllForSQL:qry];
        if ([ary1 count]>=1) {
            return ary1;
        }else{
            [[WebserviceCaller sharedSingleton] AjNotificationView:@"No Tracks in selected Vibes" :AJNotificationTypeRed];
            return nil;
        }
    }else{
        [[WebserviceCaller sharedSingleton] AjNotificationView:@"Slect Vibes" :AJNotificationTypeRed];
        return nil;
    }
    return nil;
    
}
-(NSArray *)getMyTracksV1{
    NSString *qry = @"select * from myTrack";
    NSArray *ary1 = [db lookupAllForSQL:qry];
    return ary1;
}

-(tracksShare *)trackDetail:(NSString *)trackid{
    NSString *str = [NSString stringWithFormat:@"select * from tracks where id ='%@'",trackid];
    NSDictionary *dict = [db lookupRowForSQL:str];
  tracksShare *shareobj =[[WebserviceCaller sharedSingleton] convertDictonary:[dict mutableCopy] :@"tracksShare"];
    return shareobj;
}


#pragma mark
#pragma mark -  offline 

-(void)downloadvieboffline:(NSString *)viebId{
    NSString *qry =[NSString stringWithFormat:@"update vibes set isOffline ='1' where id ='%@'",viebId];
    [db performSQL:qry];
    
    NSString *trackqry =[NSString stringWithFormat:@"update tracks set isDownloading ='1' where vibes_id ='%@'",viebId];
    [db performSQL:trackqry];
     [self startDownloading];
}

-(void)updateTrackOffline:(NSString *)offline_url :(NSString *)isDownloading :(NSString *)track_id{
    NSString *trackqry =[NSString stringWithFormat:@"update tracks set offline_url ='%@' , isDownloading ='%@' where id ='%@'",offline_url,isDownloading,track_id];
    [db performSQL:trackqry];
   
    
}



-(void)startDownloading{
    if ([[WebserviceCaller sharedSingleton]isconnectedToNetwork]) {
        NSString *findAudioForDwqry =[NSString stringWithFormat:@"select * from tracks where isDownloading='1' limit 0,1"];
        NSArray *downloadary = [db lookupAllForSQL:findAudioForDwqry];
        
        if ([downloadary count]==1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ReloadTable object:nil];

            NSMutableDictionary *dict = [downloadary objectAtIndex:0];
            NSString *fileName = [NSString stringWithFormat:@"tracks_%@_%@.mp3",[dict objectForKey:@"vibes_id"],[dict objectForKey:@"id"]];
            NSString *name =[NSString stringWithFormat:@"%@/%@",[dict objectForKey:@"vibes_id"],fileName];
           [[WebserviceCaller sharedSingleton] downloadAudioFile:[dict objectForKey:@"url"] :name :[dict objectForKey:@"id"] success:^(id responseData) {
               [self startDownloading];
           } progress:^(float responseData) {
               
           } Failure:^{
               [self startDownloading];
           }];
        }
    }
}

-(void)updateDownLoadStatus:(NSString *)trackId :(NSString *)isDownloading :(NSString *)offline_url{
    
    NSString *qry = [NSString stringWithFormat:@"update tracks set isDownloading='%@',offline_url='%@' where id ='%@'",isDownloading,offline_url,trackId];
    [db performSQL:qry];
    
    //get vieb id from track id
    NSString *viebQury=[NSString stringWithFormat:@"select vibes_id from tracks where id='%@' limit 0,1",trackId];
    NSDictionary *dict=[db lookupRowForSQL:viebQury];
    NSString *viebId = [dict objectForKey:@"vibes_id"];

    //check if any track is in que
    NSString *checkQue=[NSString stringWithFormat:@"select * from tracks where vibes_id='%@' and isDownloading='1'",viebId];
    NSArray *ary =[db lookupAllForSQL:checkQue];
    
    if ([ary count]==0) {
        //all vieb downloaded
        NSString *qry =[NSString stringWithFormat:@"update vibes set isOffline='2' where id='%@'",viebId];
        [db performSQL:qry];
        
        [[WebserviceCaller sharedSingleton] AjNotificationView:@"Vibe downloaded" :AJNotificationTypeGreen];
        [[NSNotificationCenter defaultCenter] postNotificationName:ReloadTable object:nil];
    }else{
        //some vieb in queae for downloading.
    }
    
}

-(int)isVibeDownloaded:(NSString *)viebid{
    
    NSString *qry =[NSString stringWithFormat:@"select count(*) as counter from tracks where vibes_id='%@' and isDownloading!='2'",viebid];
    NSDictionary *dic =[db lookupRowForSQL:qry];
    return [[dic objectForKey:@"counter"] intValue];

    
}



#pragma mark
#pragma mark - playback statics
-(void)addStatics:(NSString *)trackid{
    NSString *currentTime = @"SELECT strftime('%s', 'now') as time";
    NSDictionary *dict = [db lookupRowForSQL:currentTime];
    NSString *addQry = [NSString stringWithFormat:@"insert into Playbackstatistic(trackid,time,isSync) values('%@','%@','0')",trackid,[dict objectForKey:@"time"]];
    [db performSQL:addQry];
    
}

-(NSArray *)getStatics{

   NSString *qry = @"select * from Playbackstatistic where isSync='0'";
   NSArray *ary = [db lookupAllForSQL:qry];
    return ary;
}
-(void)updateAllStatics{
    NSString *qry = @"update Playbackstatistic set isSync='1'";
    [db performSQL:qry];
}


-(void)trackVibeDownload:(BOOL)temp success:(DBMasterSuccessBlock)successBlock{
    NSString *qry =@"select * from vibes where is_update='1'";
    NSMutableArray *ary = [[db lookupAllForSQL:qry] mutableCopy];
    [self saveDownload:ary success:^(BOOL responseData) {
        successBlock(true);
    }];
}
-(void)saveDownload:(NSMutableArray *)ary success:(DBMasterSuccessBlock)successBlock{
    
    if ([ary count] >= 1) {
        NSMutableDictionary *dict = [ary objectAtIndex:0];
        [self downloadImages:dict success:^(BOOL responseData) {
            [ary removeObjectAtIndex:0];
            [self saveDownload:ary success:^(BOOL responseData) {
                successBlock(true);
            }];
        }];
    }else{
        successBlock(true);
        //[self downloadImages];
    }
}
/*
-(void)downloadImages:(NSMutableDictionary *)dict success:(DBMasterSuccessBlock)successBlock{
        NSString *guidName =[NSString stringWithFormat:@"Vieb_%@.png",[dict objectForKey:@"id"]];

        //vertical images
        NSString *VerticalguidName =[NSString stringWithFormat:@"Vieb_vertical_%@.png",[dict objectForKey:@"id"]];
    
        [[WebserviceCaller sharedSingleton] downloadImage:[dict objectForKey:@"image"] :guidName :[dict objectForKey:@"id"] :-1 success:^(id responseData) {
            NSString *viebId = [responseData objectForKey:@"vieb_id"];
            NSString *fileName = [NSString stringWithFormat:@"%@/%@",viebId,[responseData objectForKey:@"imageName"]];
            NSString *updateqry = [NSString stringWithFormat:@"update vibes set is_update='0',image_offline='%@' where id='%@'",fileName,viebId];
            [db performSQL:updateqry];
            
            [[WebserviceCaller sharedSingleton] downloadImage:[dict objectForKey:@"vertical_image"] :VerticalguidName :[dict objectForKey:@"id"] :-1 success:^(id responseData) {
                
                NSString *viebId = [responseData objectForKey:@"vieb_id"];
                NSString *fileName = [NSString stringWithFormat:@"%@/%@",viebId,[responseData objectForKey:@"imageName"]];
                NSString *updateqry = [NSString stringWithFormat:@"update vibes set is_update='0',vertical_image_offline='%@' where id='%@'",fileName,viebId];
                [db performSQL:updateqry];
                
                NSString *qry =[NSString stringWithFormat:@"select * from tracks where is_update='1' and vibes_id ='%@'",viebId];
                NSArray *ary = [db lookupAllForSQL:qry];
                
                [self downloadTrackImages:[ary mutableCopy] success:^(BOOL responseData) {
                    successBlock(true);
                }];
            }];
            //[self downloadTrackImages:viebId];
        }];
}
-(void)downloadTrackImages:(NSMutableArray *)ary success:(DBMasterSuccessBlock)successBlock{
    
    if ([ary count] >= 1) {
        NSMutableDictionary *dict = [ary objectAtIndex:0];
        [self downloadTrackImage:dict success:^(BOOL responseData) {
            [ary removeObjectAtIndex:0];
            [self downloadTrackImages:ary success:^(BOOL responseData) {
                successBlock(true);
            }];
        }];
    }else{
        successBlock(true);
        //[self downloadImages];
    }
}

-(void)downloadTrackImage:(NSMutableDictionary *)dict success:(DBMasterSuccessBlock)successBlock{

        //check if artist image already downloaded.
        NSArray *aryartist = [self checkArtistImageDownload:[dict objectForKey:@"artist_id"]];
        if ([aryartist count] >= 1){
            NSLog(@"%@",[dict objectForKey:@"id"]);
            NSDictionary *dict = [aryartist objectAtIndex:0];
            NSString *viebId    = [dict objectForKey:@"id"];
            NSString *fileName  = [dict objectForKey:@"artist_image_offline"];
            NSString *updateqry = [NSString stringWithFormat:@"update tracks set is_update='0',artist_image_offline='%@' where id='%@'",fileName,viebId];
            [db performSQL:updateqry];
            successBlock(true);
        }else{
            NSString *guidName =[NSString stringWithFormat:@"track_%@.png",[dict objectForKey:@"id"]];
            int directory = [[dict objectForKey:@"vibes_id"] intValue];
            [[WebserviceCaller sharedSingleton] downloadImage:[dict objectForKey:@"artist_image"] :guidName :[dict objectForKey:@"id"] :directory success:^(id responseData) {
                //NSLog(@"%@",responseData);
                NSString *viebId = [responseData objectForKey:@"vieb_id"];
                NSString *fileName = [NSString stringWithFormat:@"%@/%@",[NSString stringWithFormat:@"%d",directory],[responseData objectForKey:@"imageName"]];
                NSString *updateqry = [NSString stringWithFormat:@"update tracks set is_update='0',artist_image_offline='%@' where id='%@'",fileName,viebId];
                [db performSQL:updateqry];
                successBlock(true);
            }];
        }
}

*/
-(void)getListOfFavSong{
    //set limit because of only 10 songs from favorite list.
    NSString *qry = [NSString stringWithFormat:@"select * from tracks where is_favorite='1' order by RANDOM() limit 0,10"];
    NSArray *ary =[db lookupAllForSQL:qry];
    if ([ary count] >= 1) {
        //int count = ([ary count]*5)/100;
        int count = [ary count];
        for (NSDictionary *dic in ary) {
            //check if that song already in playlist then not add into list

            NSString *checkqry =[NSString stringWithFormat:@"select * from myTrack where track_id = '%@'",[dic objectForKey:@"id"]];
            NSArray *checkary =[db lookupAllForSQL:checkqry];
            if ([checkary count] == 0) {
                [[DataManager shareddbSingleton] addtrack:[dic objectForKey:@"vibes_id"]:[dic objectForKey:@"id"]];
            }
        }
    }
}

-(NSArray *)getFavList{
    NSArray *arytracks;
    NSString *qry = [NSString stringWithFormat:@"select * from tracks where is_favorite='1' order by RANDOM()"];
    NSArray *ary =[db lookupAllForSQL:qry];
    if ([ary count] >= 1) {
        arytracks =[[WebserviceCaller sharedSingleton] convertArray:ary :@"tracksShare"];
    }
    return arytracks;


}

-(void)unDownloadvibe:(NSString *)vibe_id{
    NSString *qry =[NSString stringWithFormat:@"update vibes set isOffline='0' where id='%@'",vibe_id];
    [db performSQL:qry];
    
    NSString *dbqry =[NSString stringWithFormat:@"update tracks set isDownloading='0' where vibes_id='%@'",vibe_id];
   [db performSQL:dbqry];
   

    [self removeFile:vibe_id];
}

-(void)removeFile:(NSString *)vibe_id{
    NSString *str=[NSString stringWithFormat:@"select * from tracks where vibes_id='%@'",vibe_id];
    for (NSMutableDictionary *dict in [db lookupAllForSQL:str]) {
        NSString*offlinUrl=[dict objectForKey:@"offline_url"];
        NSString *track_id=[dict objectForKey:@"id"];
        [self removeImage:offlinUrl:track_id];
    }
}

- (void)removeImage:(NSString *)fileName :(NSString *)trackId
{
    if ([fileName length]>=1) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
        NSError *error;
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        if (fileExists) {
            BOOL success = [fileManager removeItemAtPath:filePath error:&error];
            if (success) {
                NSLog(@"Delete file:%@",filePath);
                NSString *dbqry =[NSString stringWithFormat:@"update tracks set offline_url='' where id='%@'",trackId];
                [db performSQL:dbqry];
            }
            else
            {
                NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
            }
        }
    }
}


//like and favorite sync offline

-(void)saveFavorite:(NSString *)track_id :(NSString *)is_favorite{
    if ([self checkId:@"Likes" :@"track_id" :track_id]) {
        //update
       // NSLog(@"Update");
        NSString *qry =[NSString stringWithFormat:@"update Favorite set is_favorite = '%@' where track_id='%@'",is_favorite,track_id];
        [db performSQL:qry];
        
        
    }else{
        //insert
     //   NSLog(@"Insert");
        NSString *qry =[NSString stringWithFormat:@"insert into Favorite values('%@','%@','0')",track_id,is_favorite];
        [db performSQL:qry];

        
    }

}

-(void)saveLikes:(NSString *)track_id :(NSString *)is_dislike{
    if ([self checkId:@"Likes" :@"track_id" :track_id]) {
        //update
        NSString *qry =[NSString stringWithFormat:@"update Likes set is_dislike = '%@' where track_id='%@'",is_dislike,track_id];
        [db performSQL:qry];
    }else{
        //insert
        NSString *qry =[NSString stringWithFormat:@"insert into Likes values('%@','%@','0')",track_id,is_dislike];
        [db performSQL:qry];
    }

}

-(void)updateLike:(NSString *)track_id :(NSString *)is_dislike :(NSString *)sync{

    NSString *qry =[NSString stringWithFormat:@"update Likes set is_dislike = '%@',is_sync='%@' where track_id='%@'",is_dislike,sync,track_id];
    [db performSQL:qry];

}

-(NSArray *)getSyncLikes{
    NSString *str =@"select * from Likes where is_sync='1'";
    return [db lookupAllForSQL:str];
}


-(void)updateFav:(NSString *)track_id :(NSString *)is_Fav :(NSString *)sync{
    
    NSString *qry =[NSString stringWithFormat:@"update Favorite set is_favorite = '%@',is_sync='%@' where track_id='%@'",is_Fav,sync,track_id];
    [db performSQL:qry];
    
}

-(NSArray *)getSyncFav{
    NSString *str =@"select * from Favorite where is_sync='1'";
    return [db lookupAllForSQL:str];
}

-(CGFloat)undownloadAudio:(NSString *)vibe_id{
    
    NSString *qry =[NSString stringWithFormat:@"select count(*) as counter from tracks where isDownloading='2' and vibes_id ='%@'",vibe_id];
    NSDictionary *dict = [db lookupRowForSQL:qry];
    return [[dict objectForKey:@"counter"] floatValue];
    
}



-(BOOL)checkDownloadCounter{
    
    NSString *qry =@"select count(*) as counter from vibes where isOffline='1' or isOffline ='2'";
    NSDictionary *dict = [db lookupRowForSQL:qry];
    if ([[dict objectForKey:@"counter"] intValue]>=4) {
        return YES;
    }else{
        return NO;
    }
    return NO;
}


-(NSArray *)checkArtistImageDownload:(NSString *)artist_id{
    NSString *qry =[NSString stringWithFormat:@"SELECT artist_id,artist_image_offline FROM tracks where artist_id = '%@' limit 0,1",artist_id ];
    NSArray *ary= [db lookupAllForSQL:qry];
    if ([ary count]>=1) {
        NSMutableDictionary *dict = [ary objectAtIndex:0];
        if ([[dict objectForKey:@"artist_image_offline"] length] == 0) {
            return nil;
        }
    }
    
    return ary;
}


-(BOOL)checkFavTrackAdded:(NSString *)vibeid{
    
    NSString *qry =[NSString stringWithFormat:@"SELECT count(*) as counter from tracks where vibes_id = '%@'",vibeid ];
    NSDictionary *dict = [db lookupRowForSQL:qry];
    if([[dict valueForKey:@"counter"] intValue] >= 1){
        return false;
    }else{
        return true;
    }
    
}


@end
