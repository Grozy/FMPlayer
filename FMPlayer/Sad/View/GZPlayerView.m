//
//  GZPlayerView.m
//  Sad
//
//  Created by 孙国志 on 16/1/9.
//  Copyright © 2016年 grozy. All rights reserved.
//

#import "GZPlayerView.h"
#import "UIImageView+AFNetworking.h"
#import "GZSongItem.h"
#import "UIColor-Expanded.h"
#import "MarqueeLabel.h"

static GZPlayerView *sharedInstance = nil;

@interface GZPlayerView()

@property (nonatomic, strong) UIButton *backgroundView;

@property (nonatomic, strong) UIImageView *coverIcon;

@property (nonatomic, strong) MarqueeLabel *titleLabel;

@property (nonatomic, strong) UILabel *subtitleLabel;

@end

@implementation GZPlayerView

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[self alloc] initWithFrame:CGRectZero];
    });
    return sharedInstance;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self makeKeyWindow];
        self.windowLevel = UIWindowLevelAlert + 1;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 1.;
        [self addSubview:self.backgroundView];
        [self.backgroundView addSubview:self.coverIcon];
        [self.backgroundView addSubview:self.titleLabel];
        [self.backgroundView addSubview:self.subtitleLabel];
        [self.backgroundView addSubview:self.slider];
    }
    return self;
}

- (void)showInView:(UIView *)view
{
    self.frame = CGRectMake(0, CGRectGetHeight(view.frame) - 64, CGRectGetWidth(view.frame), 64);
    self.backgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), 64);
    self.hidden = NO;
    CGFloat kGap = 10.f;
    CGFloat coverWidht = 44.f;
    self.coverIcon.frame = CGRectMake(kGap, kGap, coverWidht, coverWidht);
    CGFloat sliderLeft = kGap * 2 + coverWidht;
    self.slider.frame = CGRectMake(sliderLeft, kGap, CGRectGetWidth(self.frame) - sliderLeft - kGap, 5);
    
    self.titleLabel.frame = CGRectMake(sliderLeft, CGRectGetMaxY(self.slider.frame) + kGap - 2, CGRectGetWidth(self.slider.frame) / 2, self.titleLabel.font.lineHeight);
    self.subtitleLabel.frame = CGRectMake(sliderLeft, CGRectGetMaxY(self.titleLabel.frame) + 5, CGRectGetWidth(self.slider.frame), self.subtitleLabel.font.lineHeight);
}

- (void)setUp:(GZSongItem *)songItem
{
    NSString *icon = [songItem.cover valueForKey:Tag_square];
    [self.coverIcon setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"default_cover"]];
    self.titleLabel.text = songItem.subtitle;
    [self.subtitleLabel setText: songItem.artist];
    [self.titleLabel unpauseLabel];
}

- (UIImageView *)coverIcon
{
    if (!_coverIcon)
    {
        _coverIcon = [[UIImageView alloc] init];
        _coverIcon.image = [UIImage imageNamed:@"default_cover"];
    }
    return _coverIcon;
}

- (UISlider *)slider
{
    if (!_slider)
    {
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _slider.minimumValue = 0.f;
        _slider.maximumValue = 1.f;
        _slider.tintColor = [UIColor colorWithRGBHex:0xFFC7D6];
        UIImage *thumbImage = [UIImage imageNamed:@"thumbImage"];
        [_slider setThumbImage:thumbImage forState:UIControlStateNormal];
        [_slider addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (MarqueeLabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
        _titleLabel.userInteractionEnabled = YES;
        _titleLabel.font = [UIFont systemFontOfSize:12.f];
//        _titleLabel.marqueeType = MLContinuous;
//        _titleLabel.scrollDuration = 15.0;
//        _titleLabel.animationCurve = UIViewAnimationOptionCurveEaseInOut;
//        _titleLabel.fadeLength = 10.0f;
//        _titleLabel.leadingBuffer = 30.0f;
//        _titleLabel.trailingBuffer = 20.0f;
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if (!_subtitleLabel)
    {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = [UIFont systemFontOfSize:9.f];
        _subtitleLabel.textColor = [UIColor grayColor];
    }
    return _subtitleLabel;
}

- (UIButton *)backgroundView
{
    if (!_backgroundView)
    {
        _backgroundView = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [GZPlayerView createImageWithColor:[UIColor whiteColor]];
        [_backgroundView setBackgroundImage:image forState:UIControlStateNormal];
        image = [GZPlayerView createImageWithColor:[UIColor colorWithRGBHex:0xE9E8D2]];
        [_backgroundView setBackgroundImage:image forState:UIControlStateHighlighted];
        [_backgroundView addTarget:self action:@selector(aa) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroundView;
}

+(UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)aa
{
    
}

- (void)changeValue:(UISlider *)slider
{
    if ([self.delegate respondsToSelector:@selector(setProgress:)])
    {
        [self.delegate setProgress:slider.value];
    }
}
@end
