//
//  HomeViewController.m
//  Sad
//
//  Created by 孙国志 on 16/1/9.
//  Copyright © 2016年 grozy. All rights reserved.
//

#import "GZSongListViewController.h"
#import "GZMusicPlayerController.h"

#import "AFNetworking.h"
#import "MJRefresh.h"

#import "GZPlayerView.h"

#import "MeoApi.h"
#import "WXConst.h"

#import "GZSongItem.h"

#import "GZMusicHelper.h"

#import "GZSongListCell.h"

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;


@interface GZSongListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger pageNumber;
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *playlist;

@end

@implementation GZSongListViewController

- (instancetype)init
{
    if (self = [super init])
    {
        self.title = @"萌否电台";
        self.playlist = [NSMutableArray array];
        pageNumber = 1;
        
        [[GZMusicHelper sharedInstance] addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [[GZPlayerView sharedInstance] addTarget:self action:@selector(_openPlayerController:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[GZPlayerView sharedInstance] showInView:self.view];
    
    __weak GZSongListViewController *weakSelf = self;
    
    [self _addTableViewComplete:^{
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
}

- (void)dealloc
{
    [[GZMusicHelper sharedInstance] removeObserver:self forKeyPath:@"status"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"])
    {

    }
}

#pragma mark - ui setup

- (void)_addTableViewComplete:(void (^)())completeBlock
{
    [self.view addSubview:self.tableView];
    
    __weak GZSongListViewController *homeController = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [homeController _loadMore:NO];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [homeController _loadMore:YES];
    }];
    
    if (completeBlock)
        completeBlock();
}

#pragma mark - event
- (void)_openPlayerController:(id)sender
{
    GZMusicPlayerController *controller = [[GZMusicPlayerController alloc] init];
    [controller updateSongItem:[GZMusicHelper sharedInstance].audioItem];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - load data
- (void)_loadMore:(BOOL)value
{
    if (!value)
    {
        pageNumber = 1;
    }

    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] init];
    
    NSDictionary *parameters = @{
                                 @"api_key":kMeoAppKey,
                                 @"page":[NSString stringWithFormat:@"%ld", (long)pageNumber],
                                 };
    
    [sessionManager GET:[NSString stringWithFormat:@"%@",kMeoFMApi] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (!value)
            [self.playlist removeAllObjects];
        else
                pageNumber++;
        
        NSDictionary *response = [responseObject valueForKey:@"response"];
        NSArray *playlistInResponse = [response valueForKey:@"playlist"];
        NSMutableArray *playlist = [NSMutableArray array];
        
        for (NSDictionary *dictionary in playlistInResponse) {
            GZSongItem *songItem = [[GZSongItem alloc] initWithDict:dictionary];
            [playlist addObject:songItem];
        }
        
        [self.playlist addObjectsFromArray: playlist];
        [[GZMusicHelper sharedInstance] updatePlayList:self.playlist];
        [self.tableView reloadData];
        !value ? [self.tableView.mj_header endRefreshing]: [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !value ? [self.tableView.mj_header endRefreshing]: [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)player:(UIButton *)button
{
    [self.navigationController pushViewController:[GZMusicPlayerController player] animated:YES];
}

#pragma mark - timer

#pragma mark -  tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.playlist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZSongListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
        cell = [[GZSongListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    if (self.playlist.count)
    {
        GZSongItem *songItem = [self.playlist objectAtIndex:indexPath.row];
        [cell bindWithSongItem:songItem];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.play music at index
    GZSongItem *songItem = [self.playlist objectAtIndex:indexPath.row];
    if (![songItem.url isEqualToString:[[GZMusicHelper sharedInstance].audioItem audioFileURL].absoluteString])
    {
        [[GZMusicHelper sharedInstance] playAudioItemAtIndex:indexPath.row];
    }
    //2.rotate right navigationBar item
    [[GZMusicPlayerController player] updateSongItem:songItem];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.f;
}

#pragma mark - accessor
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, CGRectGetHeight(self.view.frame) - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [UIView new];
    }
    return _tableView;
}

@end
