//
//  RS_SliderView.m
//  RS_SliderView
//
//  Created by Roman Simenok on 13.02.15.
//  Copyright (c) 2015 Roman Simenok. All rights reserved.
//

#import "RS_SliderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RS_SliderView

-(id)initWithFrame:(CGRect)frame andOrientation:(Orientation)orientation {
    if (self = [super initWithFrame:frame]) {
        [self setOrientation:orientation];
        [self initSlider];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        if (self.frame.size.width>self.frame.size.height) {
            [self setOrientation:Horizontal];
        }else{
            [self setOrientation:Vertical];
        }
        
        [self initSlider];
    }
    return self;
}

-(void)initSlider {
    isHandleHidden = NO;
    self.minView = [[UIView alloc] init];
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.minView addGestureRecognizer:singleFingerTap];
    
    self.maxView = [[UIView alloc] init];

    UITapGestureRecognizer *singleFingerTap1 =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap1:)];
    [self.maxView addGestureRecognizer:singleFingerTap1];

    
    self.handleView = [[UIView alloc] init];
    self.handleView.layer.cornerRadius = viewCornerRadius;
    self.handleView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *singleFingerTap2 =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap1:)];
     [self.handleView addGestureRecognizer:singleFingerTap2];
    
    switch (self.orientation) {
        case Vertical:
            self.label = [[UILabel alloc] init];
            [self.label setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
            self.label.frame = self.bounds;
            break;
        case Horizontal:
            self.label = [[UILabel alloc] initWithFrame:self.bounds];
            break;
        default:
            break;
    }
    
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont fontWithName:@"Helvetica" size:24];
    [self addSubview:self.minView];
    [self addSubview:self.maxView];
    [self addSubview:self.label];
    [self addSubview:self.handleView];
    
    self.layer.cornerRadius = viewCornerRadius;
    self.layer.masksToBounds = YES;
    [self.layer setBorderWidth:border_Width];
    
    // set defauld value for slider. Value should be between 0 and 1
    [self setValue:0.0 withAnimation:NO completion:nil];
}

- (void)handleSingleTap1:(UITapGestureRecognizer *)recognizer {
    //    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    //Do stuff here...
}
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
//    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    //Do stuff here...
}
#pragma mark - Set Value

-(void)setValue:(float)value withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion {
    NSAssert((value >= 0.0)&&(value <= 1.0), @"Value must be between 0 and 1");
    
    if (value < 0) {
        value = 0;
    }
    
    if (value > 1) {
        value = 1;
    }
    
    CGPoint point;
    switch (self.orientation) {
        case Vertical:
            point = CGPointMake(0, (1-value) * self.frame.size.height);
            break;
        case Horizontal:
            point = CGPointMake(value * self.frame.size.width, 0);
            break;
        default:
            break;
    }
    
    if(isAnimate) {
        __weak __typeof(self)weakSelf = self;
        
        [UIView animateWithDuration:animationSpeed animations:^ {
            [weakSelf changeStarForegroundViewWithPoint:point];
            
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
    } else {
        [self changeStarForegroundViewWithPoint:point];
    }
}

#pragma mark - Other methods

-(void)setOrientation:(Orientation)orientation {
    _orientation = orientation;
}

-(void)setColorsForBackground:(UIColor *)bCol foreground:(UIColor *)fCol handle:(UIColor *)hCol border:(UIColor *)brdrCol {
    self.backgroundColor = bCol;
    self.minView.backgroundColor = fCol;
    self.maxView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.handleView.backgroundColor = hCol;
    [self.layer setBorderColor:brdrCol.CGColor];
}

-(void)removeRoundCorners:(BOOL)corners removeBorder:(BOOL)borders {
    if (corners) {
        self.layer.cornerRadius = 0.0;
        self.layer.masksToBounds = YES;
    }
    if (borders) {
        [self.layer setBorderWidth:0.0];
    }
}

-(void)hideHandle {
    self.handleView.hidden = YES;
    isHandleHidden = YES;
    [self.handleView removeFromSuperview];
}

#pragma mark - Touch Events

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.disabe) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:TablescrollDisable object:nil];
    
    //timer start
   
    [[Singleton sharedSingleton] startTimer];
    
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [Singleton sharedSingleton].isCurrentSliderTouch = self.tag;
    switch (self.orientation) {
        case Vertical:
            if (!(point.y < 0) && !(point.y > self.frame.size.height)) {
                [self changeStarForegroundViewWithPoint:point];
            }
            break;
        case Horizontal:
            if (!(point.x < 0) && !(point.x > self.frame.size.width)) {
                [self changeStarForegroundViewWithPoint:point];
            }
            break;
        default:
            break;
    }
    
    if ((point.x >= 0) && point.x <= self.frame.size.width) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(sliderValueChanged:)]) {
            [self.delegate sliderValueChanged:self];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.disabe) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:Tablescroll object:nil];

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak __typeof(self)weakSelf = self;
    
    [UIView animateWithDuration:animationSpeed animations:^ {
        [weakSelf changeStarForegroundViewWithPoint:point];
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(sliderValueChangeEnded:)]) {
            [self.delegate sliderValueChangeEnded:self];
        }
    }];
}

#pragma mark - Change Slider Foreground With Point

- (void)changeStarForegroundViewWithPoint:(CGPoint)point {

    
    CGPoint p = point;
    switch (self.orientation) {
        case Vertical: {
            if (p.y < 0) {
                p.y = 0;
            }
            
            if (p.y > self.frame.size.height) {
                p.y = self.frame.size.height;
            }
            
            self.value = 1-(p.y / self.frame.size.height);
            self.minView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, p.y-self.frame.size.height);
            
            if (!isHandleHidden) {
                if (self.minView.frame.origin.y <= 0) {
                    self.handleView.frame = CGRectMake(border_Width, 0, self.frame.size.width-border_Width*2, handleWidth);
                }else if (self.minView.frame.origin.y >= self.frame.size.height) {
                    self.handleView.frame = CGRectMake(border_Width, self.frame.size.height-handleWidth, self.frame.size.width-border_Width*2, handleWidth);
                }else{
                    self.handleView.frame = CGRectMake(border_Width, self.minView.frame.origin.y-handleWidth/2, self.frame.size.width-border_Width*2, handleWidth);
                }
            }
        }
            break;
        case Horizontal: {
            if (p.x < 0) {
                p.x = 0;
            }
            
            if (p.x > self.frame.size.width) {
                p.x = self.frame.size.width;
            }
            
            self.value = p.x / self.frame.size.width;
            self.minView.frame = CGRectMake(-10, 0, p.x, self.frame.size.height);
            
            if (!isHandleHidden) {
                if (self.minView.frame.size.width <= 0) {
                    self.handleView.frame = CGRectMake(0, border_Width, handleWidth, self.minView.frame.size.height-border_Width);
                    [self.delegate sliderValueChanged:self]; // or use sliderValueChangeEnded method
                }else if (self.minView.frame.size.width >= self.frame.size.width) {
                    self.handleView.frame = CGRectMake(self.minView.frame.size.width-handleWidth, border_Width, handleWidth, self.minView.frame.size.height-border_Width*2);
                    [self.delegate sliderValueChanged:self]; // or use sliderValueChangeEnded method
                }else{
                    self.handleView.frame = CGRectMake(self.minView.frame.size.width-handleWidth/2, border_Width, handleWidth, self.minView.frame.size.height-border_Width*2);
                }
                self.maxView.frame = CGRectMake(self.handleView.frame.origin.x + self.handleView.frame.size.width/2, 0, self.frame.size.width, self.frame.size.height);
            }
        }
            break;
        default:
            break;
    }
}

@end
