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

+ (instancetype)sharedInstance;

- (void)playWithAudioItem:(id <DOUAudioFile>)audioItem;

- (void)pause;

- (void)stop;

@end
