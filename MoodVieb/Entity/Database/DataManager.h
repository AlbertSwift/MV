//
//  DataManager.h
//  
//
//  Created by code-on on 4/3/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKDatabase.h"
#import "VibeShare.h"
#import "tracksShare.h"

typedef void(^DBMasterSuccessBlock)(BOOL responseData);
typedef void(^DBMasterFailureBlock)(BOOL responseData);


@interface DataManager : NSObject{
}
+ (DataManager *)shareddbSingleton;

-(BOOL)checkId :(NSString *)strcolId :(NSString *)strId :(NSString *)tableName;
//-(void)saveVibes:(NSMutableArray *)ary success:(DBMasterSuccessBlock)successBlock;
-(void)saveVibes:(VibeShare *)vibeshare success:(DBMasterSuccessBlock)successBlock;

-(void)saveTrack:(NSMutableArray *)ary success:(DBMasterSuccessBlock)successBlock;
-(void)saveTrack:(NSMutableArray *)ary :(NSString *)Vibe_id success:(DBMasterSuccessBlock)successBlock;
-(NSMutableArray *)getVibes;
-(NSDictionary *)getVibesDetail:(NSString *)viebId;
-(NSArray *)getListOfTrackFromPer:(NSString *)vieb_id :(float)percantage;
-(void)updateAllMyPlaylist:(int)totalSelVibe;
-(void)addintoPlaylist:(int)vibeId :(float)per;
-(void)removePlaylist:(int)vibeId;
-(VibeShare *)getPlayListDetail:(VibeShare *)shareobj;
-(int)CountSelectedPlaylist;
-(float)getTotalPercentage;
-(NSArray *)getListOfAllPlaylist;
-(void)updatePercentage:(int)vibeId :(float)per;

-(void)favTrack:(NSString *)trackid :(NSString *)favStatus;
-(void)likeTrack:(NSString *)trackid :(NSString *)likeStatus;
-(void)addtrack:(NSString *)vieb_id :(NSString *)trackid;
-(void)clearTrack;
-(NSArray *)getMyTracks;
-(tracksShare *)trackDetail:(NSString *)trackid;
-(NSArray *)getTrackList:(NSString *)viebId;
//offline
-(void)downloadvieboffline:(NSString *)viebId;
-(void)updateTrackOffline:(NSString *)offline_url :(NSString *)isDownloading :(NSString *)track_id;
-(void)updateDownLoadStatus:(NSString *)trackId :(NSString *)isDownloading :(NSString *)offline_url;
-(void)startDownloading;

-(void)unDownloadvibe:(NSString *)vibe_id;
-(void)downloadTrackImages:(NSMutableArray *)ary success:(DBMasterSuccessBlock)successBlock;
//playback statstic
-(void)addStatics:(NSString *)trackid;
-(NSArray *)getStatics;
-(void)updateAllStatics;
-(int)isVibeDownloaded:(NSString *)viebid;

//favorite
-(void)getListOfFavSong;
-(NSArray *)getFavList;

//additional
-(NSArray *)getMyTracksV1;
- (void)removeImage:(NSString *)fileName;
-(BOOL)checkFavTrackAdded:(NSString *)vibeid;


-(CGFloat)undownloadAudio:(NSString *)vibe_id;
//track like nd favorite sync methods

-(void)updateLike:(NSString *)track_id :(NSString *)is_dislike :(NSString *)sync;
-(NSArray *)getSyncLikes;

-(void)updateFav:(NSString *)track_id :(NSString *)is_Fav :(NSString *)sync;
-(NSArray *)getSyncFav;
-(BOOL)checkDownloadCounter;
-(void)downloadImages:(NSMutableArray *)ary;
-(void)downloadImages:(VibeShare *)shareobj success:(DBMasterSuccessBlock)successBlock;
-(void)trackVibeDownload:(BOOL)temp success:(DBMasterSuccessBlock)successBlock;

-(void)downloadTrackImages1:(NSMutableArray *)ary :(NSString *)vibeid success:(DBMasterSuccessBlock)successBlock;
@end
