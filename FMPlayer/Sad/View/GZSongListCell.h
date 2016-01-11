//
//  GZSongListCell.h
//  Sad
//
//  Created by 孙国志 on 16/1/9.
//  Copyright © 2016年 grozy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GZSongItem;

@interface GZSongListCell : UITableViewCell

- (void)bindWithSongItem:(GZSongItem *)songItem;

@end
