//
//  HZRecordVC.m
//  HZAudioModuleOC
//
//  Created by MaHaoZhe on 2019/1/9.
//  Copyright © 2019 HachiTech. All rights reserved.
//

#import "HZRecordObj.h"
#import <AVFoundation/AVFoundation.h>
#import "HZAudioPlaybackObj.h"
#import "HZFMDBManager.h"

@interface HZRecordObj ()<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;//音频录音机

@property (nonatomic, strong) NSTimer *timer;//监听录音声波测里值

@property (nonatomic, strong) NSString *recordName;//音频名称

@property (nonatomic, strong) HZFMDBManager *DBManager;//数据库操作管理

@property (nonatomic, copy) RecorPowerChangedCallback powerCallback;

@property (nonatomic, copy) RecorPowerChangedCallback completeCallback;

@end

@implementation HZRecordObj

- (instancetype)initWithRecordName:(NSString *)name powerCallbask:(RecorPowerChangedCallback)power completeCallback:(RecorPowerChangedCallback)callback{
    
    if (self = [super init]) {
        [self setAudioSession];
        
        _powerCallback = power;
        _completeCallback = callback;
        //初始化录音机
        //创建录音文件路径
        NSURL *url = [HZHelp getRecordSavePathWithRecordName:name];
        //创建录音格式设置
        NSDictionary *setting = [self getAudioSetting];
        //创建录音机
        NSError *error = nil;
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate = self;
        _audioRecorder.meteringEnabled = YES;
        _recordName = name;
        if (error) {
            NSLog(@"创建录音机失败，错误：%@",error);
            return nil;
        }
    }
    
    return self;
}


//初始化音频回话
- (void)setAudioSession{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
}


/**
 录音文件设置

 @return 录音设置
 */
- (NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话d采样率
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道，这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数，分8，16，32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    
    return dicM;
}


- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}


- (void)audioPowerChange{
    [self.audioRecorder updateMeters];//更新测量值
    float power = [self.audioRecorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0‘
    CGFloat progress=(1.0/160.0)*(power+160.0);
    if (_powerCallback) {
        _powerCallback(progress);
    }
}


//暂停
- (void)pauseRecord{
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder pause];
        self.timer.fireDate = [NSDate distantFuture];
    }
}


//停止
- (void)stopRecord{
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder stop];//录制
        self.timer.fireDate = [NSDate distantFuture];
    }
}


//立刻录制，不限时长
- (void)record{
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record];//录制
        self.timer.fireDate = [NSDate distantPast];
    }
}


//立刻录制，录制N秒
- (void)recordDurationTime:(NSTimeInterval)duration{
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder recordForDuration:duration];//录制
        self.timer.fireDate = [NSDate distantPast];
    }
}


//延后N秒录制，不限时长
- (void)recordAtTime:(NSTimeInterval)time{
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder recordAtTime:time];//录制
        self.timer.fireDate = [NSDate distantPast];
    }
}


//延后N秒，录制N秒
- (void)recordAtTime:(NSTimeInterval)time DurationTime:(NSTimeInterval)duration{
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder recordAtTime:time forDuration:duration];//录制
        self.timer.fireDate = [NSDate distantPast];
    }
}


- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if (_audioRecorder) {
        if (self.completeCallback) {
            self.completeCallback(0);
        }
        [self.DBManager saveRecordName:self.recordName];
        _audioRecorder = nil;
        self.timer.fireDate = [NSDate distantFuture];
    }
}


- (BOOL)isRecording{
    return _audioRecorder.isRecording;
}

- (HZFMDBManager *)DBManager{
    if (!_DBManager) {
        _DBManager = [[HZFMDBManager alloc] init];
    }
    return _DBManager;
}
@end
