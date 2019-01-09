//
//  MusicPlayerVC.m
//  HZAudioModuleOC
//
//  Created by MaHaoZhe on 2019/1/9.
//  Copyright © 2019 HachiTech. All rights reserved.
//

#import "HZMusicPlayerVC.h"
#import <MediaPlayer/MediaPlayer.h>

@interface HZMusicPlayerVC ()<MPMediaPickerControllerDelegate>

@property (nonatomic,strong) MPMediaPickerController *mediaPicker;//媒体选择控制器
@property (nonatomic,strong) MPMusicPlayerController *musicPlayer; //音乐播放器

@end

@implementation HZMusicPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadsubViews];
}


- (void)loadsubViews{
    UIButton *palyBtn = [self loadCustomBtnWithTitle:@"播放" action:@selector(playClick:)];
    UIButton *stopBtn = [self loadCustomBtnWithTitle:@"停止" action:@selector(stopClick:)];
    UIButton *puaseBtn = [self loadCustomBtnWithTitle:@"暂停" action:@selector(puaseClick:)];
    UIButton *nextBtn = [self loadCustomBtnWithTitle:@"下一首" action:@selector(nextClick:)];
    UIButton *prevBtn = [self loadCustomBtnWithTitle:@"上一首" action:@selector(prevClick:)];
    UIButton *selectBtn = [self loadCustomBtnWithTitle:@"选中" action:@selector(selectClick:)];
    
    [self.view addSubview:palyBtn];
    [self.view addSubview:stopBtn];
    [self.view addSubview:puaseBtn];
    [self.view addSubview:nextBtn];
    [self.view addSubview:prevBtn];
    [self.view addSubview:selectBtn];
    
    [@[palyBtn,stopBtn,puaseBtn,nextBtn,prevBtn,selectBtn] mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:44 leadSpacing:120 tailSpacing:120];
    [@[palyBtn,stopBtn,puaseBtn,nextBtn,prevBtn,selectBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(150));
    }];
    
}


-(UIButton *)loadCustomBtnWithTitle:(NSString *)title action:(SEL)action{
    UIButton *customBtn = [[UIButton alloc] init];
    [customBtn setTitle:title forState:UIControlStateNormal];
    [customBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    customBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    customBtn.layer.cornerRadius = 5;
    customBtn.layer.masksToBounds = YES;
    [customBtn setBackgroundColor:[UIColor redColor]];
    [customBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return customBtn;
}


-(void)dealloc{
    [self.musicPlayer endGeneratingPlaybackNotifications];
    self.musicPlayer = nil;
    self.mediaPicker = nil;
}

/**
 *  获得音乐播放器
 *
 *  @return 音乐播放器
 */
-(MPMusicPlayerController *)musicPlayer{
    if (!_musicPlayer) {
        _musicPlayer=[MPMusicPlayerController systemMusicPlayer];
        [_musicPlayer beginGeneratingPlaybackNotifications];//开启通知，否则监控不到MPMusicPlayerController的通知
        [self addNotification];//添加通知
        //如果不使用MPMediaPickerController可以使用如下方法获得音乐库媒体队列
//        [_musicPlayer setQueueWithItemCollection:[self getLocalMediaItemCollection]];
    }
    return _musicPlayer;
}

/**
 *  创建媒体选择器
 *
 *  @return 媒体选择器
 */
-(MPMediaPickerController *)mediaPicker{
    if (!_mediaPicker) {
        //初始化媒体选择器，这里设置媒体类型为音乐，其实这里也可以选择视频、广播等
//                _mediaPicker=[[MPMediaPickerController alloc]initWithMediaTypes:MPMediaTypeMusic];
        _mediaPicker=[[MPMediaPickerController alloc]initWithMediaTypes:MPMediaTypeAny];
        _mediaPicker.allowsPickingMultipleItems=YES;//允许多选
//                _mediaPicker.showsCloudItems=YES;//显示icloud选项
        _mediaPicker.prompt=@"请选择要播放的音乐";
        _mediaPicker.delegate=self;//设置选择器代理
    }
    return _mediaPicker;
}

/**
 *  取得媒体队列
 *
 *  @return 媒体队列
 */
-(MPMediaQuery *)getLocalMediaQuery{
    MPMediaQuery *mediaQueue=[MPMediaQuery songsQuery];
    for (MPMediaItem *item in mediaQueue.items) {
        NSLog(@"标题：%@,%@",item.title,item.albumTitle);
    }
    return mediaQueue;
}

/**
 *  取得媒体集合
 *
 *  @return 媒体集合
 */
-(MPMediaItemCollection *)getLocalMediaItemCollection{
    MPMediaQuery *mediaQueue=[MPMediaQuery songsQuery];
    NSMutableArray *array=[NSMutableArray array];
    for (MPMediaItem *item in mediaQueue.items) {
        [array addObject:item];
        NSLog(@"标题：%@,%@",item.title,item.albumTitle);
    }
    MPMediaItemCollection *mediaItemCollection=[[MPMediaItemCollection alloc]initWithItems:[array copy]];
    return mediaItemCollection;
}

#pragma mark - MPMediaPickerController代理方法
//选择完成
-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    MPMediaItem *mediaItem=[mediaItemCollection.items firstObject];//第一个播放音乐
    //注意很多音乐信息如标题、专辑、表演者、封面、时长等信息都可以通过MPMediaItem的valueForKey:方法得到,但是从iOS7开始都有对应的属性可以直接访问
    //    NSString *title= [mediaItem valueForKey:MPMediaItemPropertyAlbumTitle];
    //    NSString *artist= [mediaItem valueForKey:MPMediaItemPropertyAlbumArtist];
    //    MPMediaItemArtwork *artwork= [mediaItem valueForKey:MPMediaItemPropertyArtwork];
    //UIImage *image=[artwork imageWithSize:CGSizeMake(100, 100)];//专辑图片
    NSLog(@"标题：%@,表演者：%@,专辑：%@",mediaItem.title ,mediaItem.artist,mediaItem.albumTitle);
    [self.musicPlayer setQueueWithItemCollection:mediaItemCollection];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//取消选择
-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 通知
/**
 *  添加通知
 */
-(void)addNotification{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(playbackStateChange:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.musicPlayer];
}

/**
 *  播放状态改变通知
 *
 *  @param notification 通知对象
 */
-(void)playbackStateChange:(NSNotification *)notification{
    switch (self.musicPlayer.playbackState) {
        case MPMusicPlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMusicPlaybackStatePaused:
            NSLog(@"播放暂停.");
            break;
        case MPMusicPlaybackStateStopped:
            NSLog(@"播放停止.");
            break;
        default:
            break;
    }
}

#pragma mark - UI事件
- (void)selectClick:(UIButton *)sender {
    [self presentViewController:self.mediaPicker animated:YES completion:nil];
//    [self.navigationController pushViewController:self.mediaPicker animated:YES];
}

- (void)playClick:(UIButton *)sender {
    [self.musicPlayer play];
}

- (void)puaseClick:(UIButton *)sender {
    [self.musicPlayer pause];
}

- (void)stopClick:(UIButton *)sender {
    [self.musicPlayer stop];
}

- (void)nextClick:(UIButton *)sender {
    [self.musicPlayer skipToNextItem];
}

- (void)prevClick:(UIButton *)sender {
    [self.musicPlayer skipToPreviousItem];
}
@end
