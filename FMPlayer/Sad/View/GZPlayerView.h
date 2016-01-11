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

@property (nonatomic, weak) id<GZSongViewDelegate>delegate;

@property (nonatomic, strong) UISlider *slider;

+ (instancetype)sharedInstance;

- (void)showInView:(UIView *)view;

- (void)setUp:(id)songItem;

@end
