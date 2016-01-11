//
//  GZSongListCell.m
//  Sad
//
//  Created by 孙国志 on 16/1/9.
//  Copyright © 2016年 grozy. All rights reserved.
//

#import "GZSongListCell.h"
#import "UIImageView+AFNetworking.h"
#import "GZSongItem.h"

@interface GZSongListCell()

@property (nonatomic, strong) UIImageView *coverIcon;

@property (nonatomic, strong) UILabel *subtitleLabel;

@property (nonatomic, strong) UILabel *artistLabel;

@end

@implementation GZSongListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self.contentView addSubview:self.coverIcon];
        [self.contentView addSubview:self.subtitleLabel];
        [self.contentView addSubview:self.artistLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize coverIconSize = CGSizeMake(44.f, 44.f);
    CGFloat kGap = 10.f;
    _coverIcon.frame = CGRectMake(kGap, kGap, coverIconSize.width, coverIconSize.height);
    CGFloat subtitleLeft = CGRectGetMaxX(_coverIcon.frame) + kGap;
    _subtitleLabel.frame = CGRectMake(subtitleLeft, kGap, CGRectGetWidth(self.contentView.frame) - subtitleLeft, _subtitleLabel.font.lineHeight);
    _artistLabel.frame = CGRectMake(subtitleLeft, kGap / 2 + CGRectGetMaxY(_subtitleLabel.frame), CGRectGetWidth(_subtitleLabel.frame), _artistLabel.font.lineHeight);
}

- (void)bindWithSongItem:(GZSongItem *)songItem
{
    NSString *icon = [songItem.cover valueForKey:Tag_square];
    self.subtitleLabel.text = songItem.subtitle;
    self.artistLabel.text = songItem.artist;
    [self.coverIcon setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"default_cover"]];
}

#pragma mark - accessor

- (UIImageView *)coverIcon
{
    if (!_coverIcon)
    {
        _coverIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _coverIcon;
}

- (UILabel *)subtitleLabel
{
    if (!_subtitleLabel)
    {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = [UIFont systemFontOfSize:12.f];
    }
    return _subtitleLabel;
}

- (UILabel *)artistLabel
{
    if (!_artistLabel)
    {
        _artistLabel = [[UILabel alloc] init];
        _artistLabel.font = [UIFont systemFontOfSize:9.f];
        _artistLabel.textColor = [UIColor grayColor];
    }
    return _artistLabel;
}
@end
