//
//  Global.h
//  iOSCodeStructure
//
//  Created by Nishant
//  Copyright (c) 2012 Nishant. All rights reserved.
//

//Device Compatibility
#define g_IS_IPHONE             ( [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] )
#define g_IS_IPOD               ( [[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"] )
#define g_IS_IPAD               ( [[[UIDevice currentDevice] model] isEqualToString:@"iPad"] )

#define FontHelveticaNeueLTStdLtWithSize(d) [UIFont fontWithName:@"HelveticaNeueLTStd-Lt" size:d]

//   OpenSans-Bold
//   OpenSans
//   OpenSans-Light
//   OpenSans-Semibold

#define CustomFontBoldWithSize(d) [UIFont fontWithName:@"OpenSans-Bold" size:d]
#define CustomFontRegularWithSize(d) [UIFont fontWithName:@"OpenSans" size:d]
#define CustomFontLightWithSize(d) [UIFont fontWithName:@"OpenSans-Light" size:d]
#define CustomFontSemiBoldWithSize(d) [UIFont fontWithName:@"OpenSans-Semibold" size:d]

#define g_IS_IPHONE_4_SCREEN    [[UIScreen mainScreen] bounds].size.height >= 480.0f && [[UIScreen mainScreen] bounds].size.height < 568.0f
#define g_IS_IPHONE_5_SCREEN    [[UIScreen mainScreen] bounds].size.height >= 568.0f && [[UIScreen mainScreen] bounds].size.height < 667.0f
#define g_IS_IPHONE_6_SCREEN    [[UIScreen mainScreen] bounds].size.height >= 667.0f && [[UIScreen mainScreen] bounds].size.height < 736.0f
#define g_IS_IPHONE_6P_SCREEN    [[UIScreen mainScreen] bounds].size.height >= 736.0f && [[UIScreen mainScreen] bounds].size.height < 1024.0f

#define g_IS_IOS_8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define g_IS_IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define g_IS_IOS_6 ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)



#define CustomFontMedium @"Lato-Regular"

//Color
#define RGB(r, g, b)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


//#define g_BaseURL @"http://moodvibe.staging.code-on.be/api/"
#define g_BaseURL @"http://mvbe.dj-matic.be/api/"
#define hide_after_ajnotification 5
#define SavedHTTPCookiesKey @"SavedHTTPCookies"

//nsuserDefault
#define deviceToken @"deviceToken"
#define userEMAIL @"useremail"
#define activatCode @"activationCode"
#define USERID @"userId"
#define CURRENTPLAYINDEX @"currentPlayIndex"


//default Notification

#define homeReloadCell @"1000"
#define homeSimpleReloadCell @"1001"
#define ReloadPlayInfo @"1002"
#define ReloadTable @"1003"
#define ReloadFavTable @"1004"
#define ReloadSingleCell @"1005"
#define reorderCell @"1006"
#define reloadAllSlider @"1007"
#define ReloadPlayInfo1 @"1008"
#define Tablescroll @"1009"
#define TablescrollDisable @"1010"

