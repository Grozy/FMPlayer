//
//  GZPlayerView.h
//  Sad
//
//  Created by 孙国志 on 16/1/9.
//  Copyright © 2016年 grozy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GZSongViewDelegate <NSObject>

@optional
- (void)setProgress:(CGFloat)progress;

@end

@class GZSongItem;

@interface GZPlayerView : UIWindow

@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, weak) id<GZSongViewDelegate>delegate;

+ (instancetype)sharedInstance;

- (void)showInView:(UIView *)view;

- (void)setUp:(id)songItem;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
