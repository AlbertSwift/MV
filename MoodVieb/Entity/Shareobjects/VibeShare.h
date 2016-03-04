//
//  VibeShare.h
//  MoodVibe
//
//  Created by code-on on 8/10/15.
//  Copyright (c) 2015 code-on. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VibeShare : NSObject


@property(nonatomic,retain)NSString *VibeShare_id;
@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSString *image;
@property(nonatomic,retain)NSString *vertical_image;
@property(nonatomic,retain)NSArray  *arytracks;


//local storage
@property(nonatomic,assign)BOOL isInPlaylist;
@property(nonatomic,assign)float percentage;
@property(nonatomic,retain)NSString *isOffline;
@property(nonatomic,retain)NSString *image_offline;
@property(nonatomic,retain)NSString *vertical_image_offline;
@property(nonatomic,retain)NSString *is_update;


//custom show
@property(nonatomic,assign)BOOL isSliderShow;


@end
