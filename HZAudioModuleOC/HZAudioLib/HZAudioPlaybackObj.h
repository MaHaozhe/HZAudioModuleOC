//
//  HZAudioPlaybackObj.h
//  HZAudioModuleOC
//
//  Created by MaHaoZhe on 2019/1/4.
//  Copyright © 2019 HachiTech. All rights reserved.
//  音频播放器-audioplayer 只能播放单一音频文件

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^UpdateProgressCallback)(CGFloat progress,NSString *progressStr,NSString *totalTimeStr);

@interface HZAudioPlaybackObj : NSObject

@property (nonatomic, assign) CGFloat totalTime;

/**
 初始化播放器

 @param audioUrl 音频本地/网络地址
 */
- (instancetype)initAudioPlayer:(NSURL *)audioUrl updateProgress:(UpdateProgressCallback)callback;


/**
 播放音频
 */
- (void)playAudio;


/**
 暂停音频
 */
- (void)pauseAudio;


/**
 停止播放
 */
- (void)stopAudio;


/**
 设置当前要播放的时间点

 @param currentTime 当前选中时间点
 */
- (void)setCurrentTime:(CGFloat)currentTime;

@end

NS_ASSUME_NONNULL_END
