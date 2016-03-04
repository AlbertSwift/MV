//
//  RS_SliderView.h
//  RS_SliderView
//
//  Created by Roman Simenok on 13.02.15.
//  Copyright (c) 2015 Roman Simenok. All rights reserved.
//

#define handleWidth 26.0 // handle width
#define border_Width 0.0 // size of border under the slider
#define viewCornerRadius 0.0 // view corners radius
#define animationSpeed 0.1 // speed when slider change position on tap

#import <UIKit/UIKit.h>

@class RS_SliderView;

typedef enum{
    Vertical,
    Horizontal
} Orientation;

@protocol RSliderViewDelegate <NSObject>

@optional

-(void)sliderValueChanged:(RS_SliderView *)sender; // calls when user is swiping slider
-(void)sliderValueChangeEnded:(RS_SliderView *)sender; // calls when user touchUpInside or toucUpOutside slider

@end

@interface RS_SliderView : UIView {
    BOOL isHandleHidden;
    int Timecounter;
    NSTimer *timer;

}

@property (nonatomic, strong) UIView *minView;
@property (nonatomic, strong) UIView *maxView;
@property (nonatomic, strong) UIView *handleView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) float value;
@property (nonatomic, assign) BOOL disabe;

@property (nonatomic, weak) id <RSliderViewDelegate> delegate;

@property (nonatomic, assign) Orientation orientation;

-(void)setValue:(float)value withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion;
-(void)setColorsForBackground:(UIColor *)bCol foreground:(UIColor *)fCol handle:(UIColor *)hCol border:(UIColor *)brdrCol;
-(void)removeRoundCorners:(BOOL)corners removeBorder:(BOOL)border;
-(void)hideHandle;

-(id)initWithFrame:(CGRect)frame andOrientation:(Orientation)orientation;

@end
