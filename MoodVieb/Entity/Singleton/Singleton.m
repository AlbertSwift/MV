//
//  Singleton.m
//  InstagramApp
//
//  Created by Webinfoways on 15/02/13.
//  Copyright (c) 2013 WebPlanex. All rights reserved.
//

#import "Singleton.h"
#import "AppDelegate.h"
@implementation Singleton
static Singleton *singletonObj = NULL;
@synthesize currentSelectedTab,myPlaylist,items;

+ (Singleton *)sharedSingleton {
    @synchronized(self) {
        if (singletonObj == NULL)
        singletonObj = [[self alloc] init];
        
    }
    return(singletonObj);
}

-(void)setcurrentSelectedTab:(int)myString{
    self.currentSelectedTab=myString;
}
-(int)getcurrentSelectedTab{
    return self.currentSelectedTab;
    
}
-(NSString *)getUserDefault:(NSString *)pref{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *val = @"";
    
    if (standardUserDefaults)
        val = [standardUserDefaults objectForKey: pref];
    
    return val;
}

-(void)setUserDefault:(NSString *)myString :(NSString *)pref  {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:myString forKey:pref];
        [standardUserDefaults synchronize];
    }
}
-(void)AjNotificationView :(NSString *)title :(int)AJNotificationType{
    appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [AJNotificationView showNoticeInView:appDel.window type:AJNotificationType title:title linedBackground:AJLinedBackgroundTypeAnimated hideAfter:1.5 offset:0 delay:0 detailDisclosure:YES response:^{
    }];
}

-(NSMutableAttributedString *)CreateAttributeStringStartEnd :(int)FontSize :(NSString *)text :(int)startString :(int)endString :(UIColor *)color anothercolor:(UIColor *)othercolor{
   // UIFont *boldFont = CustomFontDemiWithSize(FontSize);
    UIFont *regularFont = CustomFontRegularWithSize (FontSize);
    UIColor *foregroundColor = color;

    // Create the attributes
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           regularFont, NSFontAttributeName,
                           othercolor, NSForegroundColorAttributeName, nil];
    NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                              regularFont, NSFontAttributeName,foregroundColor, NSForegroundColorAttributeName, nil];
    const NSRange range = NSMakeRange(startString,endString); // range of " 2012/10/14 ". Ideally this should not be hardcoded
    // Create the attributed string (text + attributes)
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:text
                                           attributes:subAttrs];
    [attributedText setAttributes:attrs range:range];
    return attributedText;
}




//chat

- (CGSize)getSizeFromString :(NSString *)message width:(float)width fontName:(UIFont *)fontName
{
    CGRect labelBounds = [message boundingRectWithSize:CGSizeMake(width, 100000)
                                               options:NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName: fontName}
                                               context:nil];
    
    return CGSizeMake(ceilf(labelBounds.size.width), ceilf(labelBounds.size.height));
}

- (NSString *)removeNull:(NSString *)str
{
    str = [NSString stringWithFormat:@"%@",str];
    if (!str)
        return @"";
    else if([str isEqualToString:@"<null>"])
        return @"";
    else if([str isEqualToString:@"(null)"])
        return @"";
    else if([str isEqualToString:@"N/A"])
        return @"";
    else if([str isEqualToString:@"n/a"])
        return @"";
    else
        return str;
}
- (UIColor *) colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

-(void)setAdArray:(NSArray *)aryAdv{
    aryAdSidebar = [[NSMutableArray alloc] init];
    aryAdFullScreen = [[NSMutableArray alloc] init];
    for (AdShare *shareobj in aryAdv) {
        if ([shareobj.type isEqualToString:@"fullscreen"]) {
            [aryAdFullScreen addObject:shareobj];
        }else if ([shareobj.type isEqualToString:@"sidebar"]){
            [aryAdSidebar addObject:shareobj];
        }
    }
    
}
-(AdShare *)getAd:(NSString *)type{
    int min=0;
    int max=0;
    if ([type isEqualToString:@"fullscreen"]) {
        max = (int)[aryAdFullScreen count];
    int rndValue = min + arc4random() % (max - min);
        return [aryAdFullScreen objectAtIndex:rndValue];
    }else if ([type isEqualToString:@"sidebar"]){
        max = (int)[aryAdSidebar count];
        int rndValue = min + arc4random() % (max - min);
        return [aryAdSidebar objectAtIndex:rndValue];
    }
    return nil;
}

-(void)createPlaylist{
    appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    items = [[NSMutableArray alloc] init];
    [items removeAllObjects];
    NSArray *ary= [[DataManager shareddbSingleton] getListOfAllPlaylist];
    [[DataManager shareddbSingleton] clearTrack];
    for (NSMutableDictionary *dic in ary) {
       float percentage =[[dic objectForKey:@"per"] floatValue];
       NSArray *Itemary =[[DataManager shareddbSingleton] getListOfTrackFromPer:[dic objectForKey:@"vieb_id"] :percentage];
        [items addObjectsFromArray:Itemary];
        
//           for (tracksShare *shareobj in Itemary) {
//                [[DataManager shareddbSingleton] addtrack:[dic objectForKey:@"vieb_id"]:shareobj.tracksShare_id];
//            }
        
        //[self  performSelector:@selector(test) withObject:nil afterDelay:1];
        //get list of favorite
//        [[DataManager shareddbSingleton] getListOfFavSong];
    }
    
    itemAry = items;
    [self  performSelector:@selector(loopPlaylist) withObject:nil afterDelay:0.1];
}


-(void)loopPlaylist{
    appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [MBProgressHUD showHUDAddedTo:appDel.window animated:YES];
    
    for (tracksShare *shareobj in itemAry) {
            [[DataManager shareddbSingleton] addtrack:shareobj.vibes_id:shareobj.tracksShare_id];
        }
    [[DataManager shareddbSingleton] getListOfFavSong];
    [MBProgressHUD hideAllHUDsForView:appDel.window animated:YES];
    
}


-(BOOL)CheckLocalImage:(NSString *)filename{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",filename]];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:getImagePath];
    return fileExists;

}

-(UIImage *)getLocalImage:(NSString *)filename{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",filename]];
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    return img;
}

-(void)startTimer{
    self.timeCounter=0;
    if (timer.isValid) {
        [timer invalidate];
    }
    timer=[NSTimer scheduledTimerWithTimeInterval:1 block:^{
        self.timeCounter++;
        NSLog(@"Timer:%d",[Singleton sharedSingleton].timeCounter);
        if (self.timeCounter >=8) {
            [timer invalidate];
            [[NSNotificationCenter defaultCenter] postNotificationName:ReloadTable object:nil];

        }
    } repeats:YES];
}

-(void)endTimer{
    [timer invalidate];
}

@end
