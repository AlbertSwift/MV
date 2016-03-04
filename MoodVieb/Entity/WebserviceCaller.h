//
//  WebserviceCaller.h
//  BlockPrograming
//
//  Created by code-on on 1/1/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFDownloadRequestOperation.h"
@class AppDelegate;
typedef void(^WebMasterSuccessBlock)(id responseData);
typedef void(^WebMasterFailureBlock)(id responseData);
typedef void(^WebMasterProgressBlock)(float responseData);

typedef void(^SiAlertSuccessBlock)();
typedef void(^SiAlertCancelBlock)();
typedef void(^DBSuccessBlock)();
typedef void(^DBFailurBlock)();


@interface WebserviceCaller : NSObject{
    //AFHTTPRequestOperation *fileoperation;
    AFHTTPRequestOperation *fileoperation;
}

+ (WebserviceCaller *)sharedSingleton;
-(void)baseWscalldispatch:(NSMutableDictionary *)params :(NSString *)fileNameURL
                  success:(WebMasterSuccessBlock)successBlock;
-(void)BaseWsCallGET:(NSMutableDictionary *)params :(NSString *)fileNameURL
          success:(WebMasterSuccessBlock)successBlock
          Failure:(WebMasterSuccessBlock)failureBlock;
-(void)BaseWsCallPOST:(NSMutableDictionary *)params :(NSString *)fileNameURL
             success:(WebMasterSuccessBlock)successBlock
             Failure:(WebMasterSuccessBlock)failureBlock;

-(void)BaseWsCallWithHud:(NSMutableDictionary *)params :(NSString *)fileNameURL  success:(WebMasterSuccessBlock)successBlock;
-(void)baseImageUplaod:(NSMutableDictionary *)params :(NSString *)fileNameURL :(UIImage *)image :(NSString *)tag
                sucess:(WebMasterSuccessBlock)successBlock;
-(void)baseMultipleImageUplaod:(NSMutableDictionary *)params :(NSString *)fileNameURL :(NSArray *)image :(NSArray *)tag
                        sucess:(WebMasterSuccessBlock)successBlock;

-(void)CustomAlert :(NSString *)title message:(NSString *)message OkButtonTitle:(NSString *)OkButtonTitle CancelButtonTitle:(NSString *)CancelButtonTitle
             success:(SiAlertSuccessBlock)successBlock
             Failure:(SiAlertCancelBlock)failure;
-(void)baseAudioUplaod:(NSMutableDictionary *)params :(NSString *)fileNameURL :(NSURL *)audioRecorderObjURL :(NSString *)tag
                sucess:(WebMasterSuccessBlock)successBlock;

-(void)AjNotificationView :(NSString *)title :(int)AJNotificationType;
- (BOOL)isconnectedToNetwork ;
-(id)convertDictonary:(NSMutableDictionary *)dict :(NSString *)aKey;
-(NSMutableArray *)convertArray:(NSArray *)ary :(NSString *)aKey;
-(void)downloadAudioFile:(NSString *)url :(NSString *)filename :(NSString *)trackid
                 success:(WebMasterSuccessBlock)successBlock
                progress:(WebMasterProgressBlock)progressBlock
                 Failure:(SiAlertCancelBlock)failure;

-(void) downloadImage :(NSString *)url :(NSString *)guideName :(NSString *)vieb_id :(int)dire success:(WebMasterSuccessBlock)successBlock;
-(void)downloadZipFile:(NSString *)url
               success:(WebMasterSuccessBlock)successBlock
              progress:(WebMasterProgressBlock)progressBlock
               Failure:(SiAlertCancelBlock)failure;
-(void)cancelDownload;
//statiscs
-(void)updateStatstics;
-(void)SyncLikes;
-(void)SyncFav;
@end
