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
@end

@implementation HZAudioPlaybackObj

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}


- (instancetype)initAudioPlayer:(NSURL *)audioUrl updateProgress:(nonnull UpdateProgressCallback)callback{
    if (self = [super init]) {
        
        _updateBlock = callback;
        
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
}


#pragma mark 时间格式化
- (NSString *)formatDateFromSecondToMinute:(CGFloat)time{
    
    NSString *timeStr = [NSString stringWithFormat:@"%02d:%02d",(int)time/60,(int)time%60];
    
    return timeStr;
}


- (void)dealloc{
    self.timer.fireDate = [NSDate distantPast];//停止定时器
    _timer = nil;
}


@end
