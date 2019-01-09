//
//  HZAudioPlaybackObj.m
//  HZAudioModuleOC
//
//  Created by MaHaoZhe on 2019/1/4.
//  Copyright © 2019 HachiTech. All rights reserved.
//

#import "HZAudioPlaybackObj.h"
#import <AVFoundation/AVFoundation.h>

@interface HZAudioPlaybackObj ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;//播放器

@property (nonatomic, strong) NSTimer *timer;//用于刷新音频信息

@property (nonatomic, copy) UpdateProgressCallback updateBlock;//更新进度回调

@property (nonatomic, copy) DeviceStatusChangedCallback deviceBlock;//设备状态变化回调

@end

@implementation HZAudioPlaybackObj

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}


- (instancetype)initAudioPlayer:(NSURL *)audioUrl updateProgress:(nonnull UpdateProgressCallback)callback DeviceStatusChangedCallback:(DeviceStatusChangedCallback)deviceCallback{
    if (self = [super init]) {
        
        _updateBlock = callback;
        _deviceBlock = deviceCallback;
        
        if (!_audioPlayer) {
            NSError *error = nil;
            //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
            _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:&error];
            //设置播放器属性
            _audioPlayer.delegate = self;
            _audioPlayer.numberOfLoops = 0;//设置为0不循环
            [_audioPlayer prepareToPlay];//加载音频文件到缓存
            if (error) {
                //初始化音频播放器错误
            }
            _totalTime = _audioPlayer.duration;
            
            //设置后台播放模式
            AVAudioSession *audioSession=[AVAudioSession sharedInstance];
            [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
            //测试用不用这个都可以使用蓝牙耳机
//            [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
            [audioSession setActive:YES error:nil];
            //添加通知，拔出耳机后暂停播放
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
            
            //开启远程控制
            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        }
    }
    return self;
    
}


- (void)playAudio{
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
        self.timer.fireDate = [NSDate distantPast];//恢复定时器
    }
}


- (void)pauseAudio{
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer pause];
        self.timer.fireDate = [NSDate distantFuture];//暂停定时器
    }
}


- (void)stopAudio{
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
        self.timer.fireDate = [NSDate distantFuture];//暂停定时器
    }
}


- (void)updateProgress{
    float progress = self.audioPlayer.currentTime/self.audioPlayer.duration;
    if (_updateBlock) {
        _updateBlock(progress,[self formatDateFromSecondToMinute:self.audioPlayer.currentTime],[self formatDateFromSecondToMinute:self.audioPlayer.duration]);
    }
}


- (void)setCurrentTime:(CGFloat)currentTime{
    self.audioPlayer.currentTime = currentTime;
}


- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    }
    return _timer;
}


#pragma mark - 音频 delegate 方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"音频播放完成。。。");
    //根据实际情况播放完成可以将会话关闭，其他音频应用继续播放
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}


/**
 *  一旦输出改变则执行此方法
 *
 *  @param notification 输出改变通知对象
 */
-(void)routeChange:(NSNotification *)notification{
    //一开始是耳机：关闭耳机，暂停；重新打开耳机，开始播放
    //一开始是手机：打开耳机，耳机播放音乐；关闭耳机，暂停；重新打开耳机，继续播放
    //此处用的是蓝牙耳机
    
    NSDictionary *dic=notification.userInfo;
    int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    //表示旧输出不可用
    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        [self.audioPlayer pause];
        self.deviceBlock(HZAudioDeviceChangeStatusPause);
    }
    
    //新链接设备可用
    if (changeReason == AVAudioSessionRouteChangeReasonNewDeviceAvailable) {
        [self.audioPlayer play];
        self.deviceBlock(HZAudioDeviceChangeStatusPlay);
    }
}


#pragma mark 时间格式化
- (NSString *)formatDateFromSecondToMinute:(CGFloat)time{
    
    NSString *timeStr = [NSString stringWithFormat:@"%02d:%02d",(int)time/60,(int)time%60];
    
    return timeStr;
}


- (void)releaseObj{
    if (_timer) {
        self.timer.fireDate = [NSDate distantPast];//停止定时器
        _timer = nil;
    }
    //关闭远程控制
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}


@end
