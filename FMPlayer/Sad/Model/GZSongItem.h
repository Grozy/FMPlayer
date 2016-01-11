//
//  GZSongItem.h
//  Sad
//
//  Created by 孙国志 on 16/1/9.
//  Copyright © 2016年 grozy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GZStoreItem.h"
#import "DOUAudioFile.h"

typedef NS_ENUM(NSUInteger, GZSongFileType) {
    GZSongFileTypeMP3,
};

@interface GZSongItem : GZStoreItem<DOUAudioFile>

@property (nonatomic, copy) NSString *artist;

@property (nonatomic, copy) NSDictionary *cover;

@property (nonatomic, assign) NSInteger fileSize;

@property (nonatomic, assign) GZSongFileType fileType;

@property (nonatomic, assign) NSInteger streamLength;

@property (nonatomic, copy) NSString *streamTime;

@property (nonatomic, assign) NSInteger subId;

@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, copy) NSString *subType;

@property (nonatomic, copy) NSString *subUrl;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) NSInteger upId;

@property (nonatomic, assign) NSInteger wikiId;

@property (nonatomic, copy) NSString *wikiTitle;

@property (nonatomic, copy) NSString *wikiType;

@property (nonatomic, copy) NSString *wikiUrl;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
