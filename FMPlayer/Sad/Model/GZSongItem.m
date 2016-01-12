//
//  GZSongItem.m
//  Sad
//
//  Created by 孙国志 on 16/1/9.
//  Copyright © 2016年 grozy. All rights reserved.
//

#import "GZSongItem.h"

@implementation GZSongItem

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super initWithDict:dict])
    {
        NSString *artist = [dict valueForKey:Tag_artist];
        self.artist = artist.length > 0? artist: @"未知";
        self.cover = [dict valueForKey:Tag_cover];
        self.fileSize = [[dict valueForKey:Tag_file_size] integerValue];
        self.fileType = GZSongFileTypeMP3;
        self.streamLength = [[dict valueForKey:Tag_stream_length] integerValue];
        self.streamTime = [dict valueForKey:Tag_stream_time];
        self.subId = [[dict valueForKey:Tag_sub_id] integerValue];
        self.subtitle = [dict valueForKey:Tag_sub_title];
        self.subType = [dict valueForKey:Tag_sub_type];
        self.subUrl = [dict valueForKey:Tag_sub_url];
        self.title = [dict valueForKey:Tag_title];
        self.upId = [[dict valueForKey:Tag_up_id] integerValue];
        self.url = [dict valueForKey:Tag_url];
        self.wikiId = [[dict valueForKey:Tag_wiki_id] integerValue];
        self.wikiTitle = [dict valueForKey:Tag_wiki_title];
        self.wikiType = [dict valueForKey:Tag_wiki_type];
        self.wikiUrl = [dict valueForKey:Tag_wiki_url];
    }
    return self;
}

#pragma mark - DOUAudioFile
- (NSURL *)audioFileURL
{
    return [NSURL URLWithString:self.url];
}
@end
