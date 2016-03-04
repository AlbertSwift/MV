//
//  tracksShare.h
//  MoodVibe
//
//  Created by code-on on 8/10/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface tracksShare : NSObject

@property(nonatomic,retain)NSString *tracksShare_id;
@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSString *artist;
@property(nonatomic,retain)NSString *artist_id;
@property(nonatomic,retain)NSString *url;
@property(nonatomic,retain)NSString *vibes_id;
@property(nonatomic)BOOL is_favorite;
@property(nonatomic)BOOL is_dislike;
@property(nonatomic,retain)NSString *isDownloading;
@property(nonatomic,retain)NSString *offline_url;
@property(nonatomic,retain)NSString *artist_image;
@property(nonatomic,retain)NSString *artist_image_offline;
@end
