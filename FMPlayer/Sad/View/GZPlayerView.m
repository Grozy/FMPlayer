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

/*
 * 音乐封面->之后更换为button，同时作为音乐的播放按钮
 */
@property (nonatomic, strong) UIImageView *coverIcon;

//曲目
@property (nonatomic, strong) MarqueeLabel *titleLabel;

//艺术家
@property (nonatomic, strong) MarqueeLabel *subtitleLabel;

//下一曲
@property (nonatomic, strong) UIButton *nextButton;

//收藏
@property (nonatomic, strong) UIButton *collectionButton;

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
#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self makeKeyWindow];
        self.hidden = NO;
        self.windowLevel = UIWindowLevelAlert + 1;
        
        [self _setViewStyle];
        [self _addSubView];
    }
    return self;
}

#pragma mark - ui setup
- (void)_setViewStyle
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 1.;
}

- (void)_addSubView
{
    [self addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.coverIcon];
    [self.backgroundView addSubview:self.titleLabel];
    [self.backgroundView addSubview:self.subtitleLabel];
    [self.backgroundView addSubview:self.slider];
    [self.backgroundView addSubview:self.collectionButton];
    [self.backgroundView addSubview:self.nextButton];
}

- (void)showInView:(UIView *)view
{
    self.frame = CGRectMake(0, CGRectGetHeight(view.frame) - 64, CGRectGetWidth(view.frame), 64);
    self.backgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), 64);
    
    CGFloat kGap = 10.f;
    CGFloat coverWidht = 44.f;
    self.coverIcon.frame = CGRectMake(kGap, kGap, coverWidht, coverWidht);
    
    CGFloat sliderLeft = kGap * 2 + coverWidht;
    self.slider.frame = CGRectMake(sliderLeft, kGap, CGRectGetWidth(self.frame) - sliderLeft - kGap, 5);
    
    CGFloat buttonSize = 35.f;
    CGFloat bottomOfSlider = CGRectGetMaxY(self.slider.frame);
    
    self.collectionButton.frame = CGRectMake(CGRectGetWidth(self.frame) - kGap - buttonSize, bottomOfSlider + kGap * 2 / 3, buttonSize, buttonSize);
    
    self.nextButton.frame = CGRectMake(CGRectGetMinX(self.collectionButton.frame) - kGap - buttonSize, bottomOfSlider + kGap *2 / 3, buttonSize, buttonSize);
    
    self.titleLabel.frame = CGRectMake(sliderLeft, bottomOfSlider + kGap - 2, CGRectGetMinX(self.nextButton.frame)  - sliderLeft - kGap, self.titleLabel.font.lineHeight);
    
    self.subtitleLabel.frame = CGRectMake(sliderLeft, CGRectGetMaxY(self.titleLabel.frame) + 5, CGRectGetWidth(self.titleLabel.frame) , self.subtitleLabel.font.lineHeight);
}

- (void)setUp:(GZSongItem *)songItem
{
    //主线程更新界面
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *icon = [songItem.cover valueForKey:Tag_square];
        [self.coverIcon setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"default_cover"]];
        self.titleLabel.text = songItem.subtitle;
        [self.subtitleLabel setText: songItem.artist];
        [self.titleLabel unpauseLabel];
    });
}

#pragma mark - Setter & Getter
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
        [_slider addTarget:self action:@selector(_changeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (MarqueeLabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:12.f];
        _titleLabel.animationCurve = UIViewAnimationOptionCurveEaseInOut;
    }
    return _titleLabel;
}

- (MarqueeLabel *)subtitleLabel
{
    if (!_subtitleLabel)
    {
        _subtitleLabel = [[MarqueeLabel alloc] init];
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
        UIImage *image = [GZPlayerView _createImageWithColor:[UIColor whiteColor]];
        [_backgroundView setBackgroundImage:image forState:UIControlStateNormal];
        image = [GZPlayerView _createImageWithColor:[UIColor colorWithRGBHex:0xE9E8D2]];
        [_backgroundView setBackgroundImage:image forState:UIControlStateHighlighted];
    }
    return _backgroundView;
}

- (UIButton *)collectionButton
{
    if (!_collectionButton)
    {
        _collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectionButton.backgroundColor = [UIColor blueColor];
        [_collectionButton addTarget:self action:@selector(_markLike) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionButton;
}

- (UIButton *)nextButton
{
    if (!_nextButton)
    {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.backgroundColor = [UIColor redColor];
        [_nextButton addTarget:self action:@selector(_next) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

+ (UIImage*)_createImageWithColor:(UIColor*) color
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

- (void)_next
{
    if ([self.delegate respondsToSelector:@selector(nextSong)])
    {
        [self.delegate nextSong];
    }
}

- (void)_markLike
{
    if ([self.delegate respondsToSelector:@selector(markLike)])
    {
        [self.delegate markLike];
    }
}

- (void)_changeValue:(UISlider *)slider
{
    if ([self.delegate respondsToSelector:@selector(setProgress:)])
    {
        [self.delegate setProgress:slider.value];
    }
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [_backgroundView addTarget:target action:action forControlEvents:controlEvents];
}
@end
