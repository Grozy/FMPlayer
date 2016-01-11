//
//  GZMusicPlayerController.m
//  Sad
//
//  Created by 孙国志 on 16/1/9.
//  Copyright © 2016年 grozy. All rights reserved.
//

#import "GZMusicPlayerController.h"
#import "GZSongItem.h"
#import "GZMusicHelper.h"

static GZMusicPlayerController *player = nil;

@interface GZMusicPlayerController()

@property (nonatomic, strong) GZSongItem *songItem;

@end

@implementation GZMusicPlayerController

+ (instancetype)player
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[self alloc] init];
    });
    return player;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.view.backgroundColor = [UIColor whiteColor];
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)updateSongItem:(GZSongItem *)songItem
{
    self.songItem = songItem;
    self.title = songItem.subtitle;
}

- (void)updatePlayList:(NSArray <GZSongItem *>*)songItem
{
    
}


@end
