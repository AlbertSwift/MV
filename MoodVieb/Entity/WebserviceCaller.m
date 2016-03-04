//
//  WebserviceCaller.m
//  BlockPrograming
//
//  Created by code-on on 1/1/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import "WebserviceCaller.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "AFImageRequestOperation.h"
#import<objc/runtime.h>

@implementation WebserviceCaller{
 
    AppDelegate *appDel;
}

static WebserviceCaller *singletonObj = NULL;
+ (WebserviceCaller *)sharedSingleton {
    @synchronized(self) {
        if (singletonObj == NULL)
            singletonObj = [[self alloc] init];
    }
    return(singletonObj);
}
- (id) init {
    appDel=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    return self;
}

-(void)baseWscalldispatch:(NSMutableDictionary *)params :(NSString *)fileNameURL
                  success:(WebMasterSuccessBlock)successBlock{
    if ([self isconnectedToNetwork]) {
        NSString *url= [NSString stringWithFormat:@"%@%@",g_BaseURL,fileNameURL];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        manager.responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 403)];
        [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"success"] boolValue]) {
                successBlock(responseObject);
            }else{
              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //        [self AjNotificationView:@"Server Error " :AJNotificationTypeRed];
          [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
    }
}

-(void)BaseWsCallGET:(NSMutableDictionary *)params :(NSString *)fileNameURL
          success:(WebMasterSuccessBlock)successBlock
          Failure:(WebMasterSuccessBlock)failureBlock{
    appDel=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if ([self isconnectedToNetwork]) {

    NSString *url= [NSString stringWithFormat:@"%@%@",g_BaseURL,fileNameURL];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        manager.responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 403)];
        [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
            if ([[responseObject objectForKey:@"success"] boolValue]) {
                successBlock(responseObject);
            }else{
                failureBlock(responseObject);
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
            [self AjNotificationView:LocalizedString(@"KeyErrorServreError", nil) :AJNotificationTypeRed];
            
        }];
   }
}
-(void)BaseWsCallPOST:(NSMutableDictionary *)params :(NSString *)fileNameURL
             success:(WebMasterSuccessBlock)successBlock
             Failure:(WebMasterSuccessBlock)failureBlock{
    appDel=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if ([self isconnectedToNetwork]) {
        
        NSString *url= [NSString stringWithFormat:@"%@%@",g_BaseURL,fileNameURL];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
         manager.responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 400)];
        [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
            if ([[responseObject objectForKey:@"success"] boolValue]) {
                successBlock(responseObject);
            }else{
                failureBlock(responseObject);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
        
            [self AjNotificationView:LocalizedString(@"KeyErrorServreError", nil) :AJNotificationTypeRed];

        }];
    }
}


-(void)baseImageUplaod:(NSMutableDictionary *)params :(NSString *)fileNameURL :(UIImage *)image :(NSString *)tag
                sucess:(WebMasterSuccessBlock)successBlock{
    NSString *url= [NSString stringWithFormat:@"%@%@",g_BaseURL,fileNameURL];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    AFHTTPRequestOperation *op = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:imageData name:tag fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [MBProgressHUD hideAllHUDsForView:appDel.window animated:YES];
//        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
//        [MBProgressHUD hideAllHUDsForView:appDel.window animated:YES];
    }];
    [op start];
}

-(void)baseAudioUplaod:(NSMutableDictionary *)params :(NSString *)fileNameURL :(NSURL *)audioRecorderObjURL :(NSString *)tag
                sucess:(WebMasterSuccessBlock)successBlock{
 //   [MBProgressHUD showHUDAddedTo:appDel.window animated:YES];

    NSArray *parts = [audioRecorderObjURL.absoluteString componentsSeparatedByString:@"/"];
    NSString *guideName = [parts lastObject];
    NSString *url= [NSString stringWithFormat:@"%@%@",g_BaseURL,fileNameURL];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url
                                                                                             parameters:params
                                                                              constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                                  [formData appendPartWithFileURL:audioRecorderObjURL name:tag fileName:guideName mimeType:@"audio/m4a" error:nil];
                                                                              } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
    //    [MBProgressHUD hideHUDForView:appDel.window animated:YES];
        if (error) {
            [self AjNotificationView:LocalizedString(@"KeyErrorServreError", nil) :AJNotificationTypeRed];
 //           [MBProgressHUD hideHUDForView:appDel.window animated:YES];
        } else {
            if ([[responseObject objectForKey:@"FLAG"] boolValue]) {
                successBlock(responseObject);
            }else{
                [self AjNotificationView:[responseObject objectForKey:@"MESSAGE"]:AJNotificationTypeRed];
            }
        }
    } ];
    [uploadTask resume];
}

-(void)baseMultipleImageUplaod:(NSMutableDictionary *)params :(NSString *)fileNameURL :(NSArray *)image :(NSArray *)tag
                sucess:(WebMasterSuccessBlock)successBlock{
    
   if ([image count] == [tag count]) {
    NSString *url= [NSString stringWithFormat:@"%@%@",g_BaseURL,fileNameURL];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
        AFHTTPRequestOperation *op = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //do not put image inside parameters dictionary as I did, but append it!
            int i=0;
            for (UIImage *img in image) {
                    NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
                    [formData appendPartWithFileData:imageData name:[tag objectAtIndex:i] fileName:@"photo.jpg"   mimeType:@"image/jpeg"];
                i++;
            }
                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        successBlock(responseObject);
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"%@",error);
                }];
        [op start];
    }
}

-(void)CustomAlert:(NSString *)title message:(NSString *)message OkButtonTitle:(NSString *)OkButtonTitle CancelButtonTitle:(NSString *)CancelButtonTitle success:(SiAlertSuccessBlock)successBlock Failure:(SiAlertCancelBlock)failure{
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:title andMessage:message];
    [alertView addButtonWithTitle:LocalizedString(OkButtonTitle, nil)
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView)
     {
         successBlock();
     }];
    [alertView addButtonWithTitle:LocalizedString(CancelButtonTitle, nil)
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView)
     {
         failure();
     }];
    alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromTop;
    [alertView show];
    
}

-(void)AjNotificationView :(NSString *)title :(int)AJNotificationType{
//    UIView *view=[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    [AJNotificationView showNoticeInView:appDel.window type:AJNotificationType title:title linedBackground:AJLinedBackgroundTypeAnimated hideAfter:1.5 offset:0 delay:0 detailDisclosure:YES response:^{
        NSLog(@"Notification Call");
    }];
}

- (BOOL)isconnectedToNetwork {
    
    //return false;
    //    if([AFNetworkReachabilityManager sharedManager].reachable)
    //        [[AlertView sharedAlertView] showAlertWithOKButton:LocalizedString(@"keyInternetConnectionError", @"")];
    //
    //    return [AFNetworkReachabilityManager sharedManager].reachable;
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
//    if(networkStatus == NotReachable)
//    {
//        [self CustomAlert:LocalizedString(@"KeyErrorInternetErrorTitle", nil) message:LocalizedString(@"KeyErrorInternetErrorDetail", nil) OkButtonTitle:@"OK" CancelButtonTitle:@"Cancel" success:^{
//            [self isconnectedToNetwork];
//        } Failure:^{
//        }];
//    }
//return NO;
    
   return !(networkStatus == NotReachable);

}


-(id)convertDictonary:(NSMutableDictionary *)dict :(NSString *)aKey{
    Class klass = NSClassFromString(aKey);
    if (klass) {
        // class exists
        id instance = [[klass alloc] init];
        uint count;
        objc_property_t* properties = class_copyPropertyList(klass, &count);
        NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count ; i++)
        {
            const char* propertyName = property_getName(properties[i]);
            [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        }
        
        for( NSString *DataKey in [dict allKeys] )
        {
            if ([DataKey isEqualToString:@"id"]) {
                [instance setValue:[dict valueForKey:@"id"] forKey:[NSString stringWithFormat:@"%@_id",aKey]];
            }else if([[dict valueForKey:DataKey] isKindOfClass:[NSArray class]]){
                id subinstance = [self convertArray:[dict valueForKey:DataKey] :[NSString stringWithFormat:@"%@Share",DataKey]];
                [instance setValue:subinstance forKey:[NSString stringWithFormat:@"ary%@",DataKey]];
            }else{
                if ([propertyArray containsObject:DataKey]) {
                    [instance setValue:[dict valueForKey:DataKey] forKey:DataKey];
                }
            }
            
        }
        return instance;
    } else {
        // class doesn't exist
        return dict;
    }
    return nil;
}

-(NSMutableArray *)convertArray:(NSArray *)ary :(NSString *)aKey{
    NSMutableArray *returnArray = [[NSMutableArray alloc]init];
    for (NSMutableDictionary *dict in ary) {
        id instance = [self convertDictonary:dict :aKey];
        [returnArray addObject:instance];
    }
    return returnArray;
}

-(void) downloadImage :(NSString *)url :(NSString *)guideName :(NSString *)vieb_id :(int)dire success:(WebMasterSuccessBlock)successBlock{

    NSString *documentsDirectory = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    NSString *checkdataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%@",vieb_id,guideName]];

    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:checkdataPath];
    if (fileExists) {
        
        NSDictionary *dict =@{@"vieb_id":vieb_id,@"imageName":guideName};
        successBlock(dict);

    }else{
        
        NSString *photourl = url;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:photourl]];
        AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(UIImage *image) {
            __block int dir=dire;
            //create directory if not exists
            if (dir ==-1) {
                NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",vieb_id]];
                if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
                    [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
                    
                }
                dir=[vieb_id intValue];
            }
            
            // Get dir
            NSString *pathString = [NSString stringWithFormat:@"%@/%d/%@",documentsDirectory,dir, guideName];
            // NSLog(@"%@",pathString);
            // Save Image
            NSData *imageData = UIImageJPEGRepresentation(image, 90);
            [imageData writeToFile:pathString atomically:YES];
            // [self UpLoadImage:vieb_id :pathString :@"1" :serverid];
            NSDictionary *dict =@{@"vieb_id":vieb_id,@"imageName":guideName};
            successBlock(dict);
            
        }];
        [operation start];
    }

}


-(void)downloadAudioFile:(NSString *)url :(NSString *)filename :(NSString *)trackid
                 success:(WebMasterSuccessBlock)successBlock
                progress:(WebMasterProgressBlock)progressBlock
                 Failure:(SiAlertCancelBlock)failure
{
    if ([self isconnectedToNetwork]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        fileoperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        NSString *pdfName = filename;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:pdfName];
        fileoperation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
       
        
        [fileoperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Successfully downloaded file to %@", path);
            [[DataManager shareddbSingleton] updateDownLoadStatus:trackid :@"2" :filename];
            successBlock(filename);
            [fileoperation cancel];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            failure();
        }];
        [fileoperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {

            float totalmb= totalBytesExpectedToRead / (1024*1024);
            float downloadedmb = totalBytesRead / (1024 * 1024);
            float progress= downloadedmb/ totalmb;
            if (progress>=100) {
                successBlock(filename);
                [fileoperation cancel];
            }else{
                progressBlock(progress);
            }
            NSLog(@"%f",progress);
        }];
        
        [fileoperation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
        }];
        [fileoperation start];
    }
}


-(void)downloadZipFile:(NSString *)url
                 success:(WebMasterSuccessBlock)successBlock
                progress:(WebMasterProgressBlock)progressBlock
                 Failure:(SiAlertCancelBlock)failure
{
    if ([self isconnectedToNetwork]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        fileoperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        NSString *pdfName = @"Images.zip";
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:pdfName];
        fileoperation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
        
        
        [fileoperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Successfully downloaded file to %@", path);
            successBlock(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            failure();
        }];
        [fileoperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            
            float totalmb= totalBytesExpectedToRead / (1024*1024);
            float downloadedmb = totalBytesRead / (1024 * 1024);
            float progress= downloadedmb/ totalmb;
            if (progress>=100) {
            }else{
                progressBlock(progress);
            }
            NSLog(@"%f",progress);
        }];
        
        [fileoperation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
        }];
        [fileoperation start];
    }
}


-(void)cancelDownload{
    [fileoperation cancel];
}


#pragma mark
#pragma mark - statistics

-(void)updateStatstics{
    NSArray *ary =[[DataManager shareddbSingleton]getStatics];
    NSMutableArray *dataDic = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in ary) {
        NSDictionary *temp=@{@"track":[dict objectForKey:@"trackid"],@"timestamp":[dict objectForKey:@"time"]};
        [dataDic addObject:temp];
    }
    if ([ary count]>=1) {
        //calll websservices
        NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
        NSMutableDictionary *param =[[NSMutableDictionary alloc] init];
        [param setObject:jsonString forKey:@"data"];
        [self BaseWsCallPOST:param :@"play-stats/" success:^(id responseData) {
            NSLog(@"sucess");
            [[DataManager shareddbSingleton] updateAllStatics];
        } Failure:^(id responseData) {
            NSLog(@"Fail");
        }];
    }
}
-(void)SyncLikes{

    for (NSMutableDictionary *dict in [[DataManager shareddbSingleton] getSyncLikes]) {
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:[[Singleton sharedSingleton] getUserDefault:userEMAIL] forKey:@"email"];
        [param setObject:[[Singleton sharedSingleton] getUserDefault:activatCode] forKey:@"code"];
        [param setObject:[dict objectForKey:@"track_id"] forKey:@"track"];
        
        if ([[dict objectForKey:@"is_dislike"]boolValue]) {
            NSLog(@"add dislike");
            [[WebserviceCaller sharedSingleton] baseWscalldispatch:param :@"add-dislike/" success:^(id responseData) {
                [[DataManager shareddbSingleton] updateLike:[dict objectForKey:@"track_id"] :@"1" :@"0"];

            }];
        }else{
            NSLog(@"remove dislike");
            [[WebserviceCaller sharedSingleton] baseWscalldispatch:param :@"remove-dislike/" success:^(id responseData) {
                [[DataManager shareddbSingleton] updateLike:[dict objectForKey:@"track_id"] :@"1" :@"0"];
            }];
        }
    }
}

-(void)SyncFav{
    
    for (NSMutableDictionary *dict in [[DataManager shareddbSingleton] getSyncFav]) {
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:[[Singleton sharedSingleton] getUserDefault:userEMAIL] forKey:@"email"];
        [param setObject:[[Singleton sharedSingleton] getUserDefault:activatCode] forKey:@"code"];
        [param setObject:[dict objectForKey:@"track_id"] forKey:@"track"];
        
        if ([[dict objectForKey:@"is_favorite"]boolValue]) {
            NSLog(@"add dislike");
            [[WebserviceCaller sharedSingleton] baseWscalldispatch:param :@"add-favorite/" success:^(id responseData) {
                [[DataManager shareddbSingleton] updateFav:[dict objectForKey:@"track_id"] :@"1" :@"0"];
                
            }];
        }else{
            NSLog(@"remove dislike");
            [[WebserviceCaller sharedSingleton] baseWscalldispatch:param :@"remove-favorite/" success:^(id responseData) {
                [[DataManager shareddbSingleton] updateFav:[dict objectForKey:@"track_id"] :@"1" :@"0"];
            }];
        }
    }
}
@end
