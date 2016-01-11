//
//  GZMusicHelper.h
//  Sad
//
//  Created by 孙国志 on 16/1/9.
//  Copyright © 2016年 grozy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUAudioFile.h"
#import "DOUAudioStreamer.h"

typedef NS_ENUM(NSUInteger, EGZPlayModel) {
    EGZPlayModelSingle, //单曲循环
    EGZPlayModelRandom, //随机播放
    EGZPlayModelPlaylist,   //列表播放
};

typedef NS_ENUM(NSUInteger, EGZHelperStreamStatus) {
    EGZHelperStreamStatusPlaying=   DOUAudioStreamerPlaying,
    EGZHelperStreamStatusPaused =   DOUAudioStreamerPaused,
    EGZHelperStreamStatusIdle   =   DOUAudioStreamerIdle,
    EGZHelperStreamStatusFinished   =   DOUAudioStreamerFinished,
    EGZHelperStreamStatusBuffering  =   DOUAudioStreamerBuffering,
    EGZHelperStreamStatusError  =   DOUAudioStreamerError,
};

@interface GZMusicHelper : NSObject

@property (nonatomic, strong, readonly) id<DOUAudioFile>audioItem;

@property (nonatomic, assign, readonly) EGZHelperStreamStatus status;

@property (nonatomic, assign, readonly) NSInteger currentPlayingIdx;

+ (instancetype)sharedInstance;

- (void)playAudioItemAtIndex:(NSInteger)idx;

- (void)updatePlayList:(NSArray *)playList;

- (void)pause;

- (void)stop;

- (void)setCurrentPlayModel:(EGZPlayModel)playModel;

@end
