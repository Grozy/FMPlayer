//
//  GZMusicHelper.m
//  Sad
//
//  Created by 孙国志 on 16/1/9.
//  Copyright © 2016年 grozy. All rights reserved.
//

#import "GZMusicHelper.h"
#import "DOUAudioStreamer.h"
#import "GZPlayerView.h"

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

static GZMusicHelper *sharedInstance = nil;

@interface GZMusicHelper()<GZSongViewDelegate>
{
    EGZPlayModel _playModel;
}
@property (nonatomic, assign, readwrite) EGZHelperStreamStatus status;

@property (nonatomic, strong, readwrite) id<DOUAudioFile>audioItem;

@property (nonatomic, strong) DOUAudioStreamer *streamer;

@property (nonatomic, strong) NSArray *playList;

@property (nonatomic, assign, readwrite) NSInteger currentPlayingIdx;

@end

@implementation GZMusicHelper

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _playModel = EGZPlayModelPlaylist;
        [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(_timerAction:) userInfo:nil repeats:YES];
        [GZPlayerView sharedInstance].delegate = self;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{

    if (context == kDurationKVOKey) {
        [self performSelector:@selector(_timerAction:)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if ([keyPath isEqualToString:@"timingOffset"])
    {
        NSLog(@"%@", change);
    }
    else if ([keyPath isEqualToString:@"status"])
    {
        self.status = [[change valueForKey:@"new"] integerValue];
        if (EGZHelperStreamStatusFinished == _status)
        {
            [self.streamer setCurrentTime:0];
        }
        if (EGZHelperStreamStatusFinished == self.status)
        {
            switch (_playModel)
            {
                case EGZPlayModelPlaylist:
                {
                    NSInteger currentIdx = ++self.currentPlayingIdx % self.playList.count;
                    [self playAudioItemAtIndex:currentIdx];
                    break;
                }
                case EGZPlayModelRandom:
                {
                    break;
                }
                case EGZPlayModelSingle:
                {
                    [self playAudioItemAtIndex:self.currentPlayingIdx];
                    break;
                }
                default:
                    break;
            }
        }
    }
    else
    {
        NSLog(@"%@", change);
    }
}

- (void)_resetStreamerWithAudioFile:(id<DOUAudioFile>)file
{
    [self _cancelStreamer];
    _streamer = [DOUAudioStreamer streamerWithAudioFile:file];
    [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
    [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
    [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
    [_streamer addObserver:self forKeyPath:@"currentTime" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)_cancelStreamer
{
    if (_streamer)
    {
        [_streamer pause];
        [_streamer removeObserver:self forKeyPath:@"status"];
        [_streamer removeObserver:self forKeyPath:@"duration"];
        [_streamer removeObserver:self forKeyPath:@"bufferingRatio"];
        [_streamer removeObserver:self forKeyPath:@"currentTime"];
        
        _streamer = nil;
    }
}

- (void)playAudioItemAtIndex:(NSInteger)idx
{
    self.currentPlayingIdx = idx;
    self.audioItem = [self.playList objectAtIndex:idx];
    
    [[GZPlayerView sharedInstance] setUp:self.audioItem];
    [self _resetStreamerWithAudioFile:self.audioItem];
    [_streamer play];
}

- (void)updatePlayList:(NSArray <GZSongItem *>*)playList
{
    self.playList = playList;
}

- (void)pause
{
    [_streamer pause];
}

- (void)stop
{
    [self _cancelStreamer];
}

- (EGZHelperStreamStatus)status
{
    return _status;
}

- (void)setProgress:(CGFloat)progress
{
    [self.streamer setCurrentTime:progress * self.streamer.duration];
}

- (void)targing:(UISlider *)slider
{
    
}

- (void)_timerAction:(id)timer
{
    if ([_streamer duration] == 0.0)
    {
        [[GZPlayerView sharedInstance].slider setValue:0.0f animated:NO];
    }
    else
    {
        [[GZPlayerView sharedInstance].slider setValue:[_streamer currentTime] / [_streamer duration] animated:YES];
    }
}

- (void)setCurrentPlayModel:(EGZPlayModel)playModel
{
    _playModel = playModel;
}

@end
