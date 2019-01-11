//
//  HZRecordVC.h
//  HZAudioModuleOC
//
//  Created by MaHaoZhe on 2019/1/9.
//  Copyright © 2019 HachiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^RecorPowerChangedCallback)(CGFloat power);

@interface HZRecordObj : NSObject

@property (nonatomic, assign, readonly) BOOL isRecording;//是否正在录音

/**
 初始化录音机

 @param name 录制音频的标题
 @return 录音管理类
 */
- (instancetype)initWithRecordName:(NSString *)name powerCallbask:(RecorPowerChangedCallback)power completeCallback:(RecorPowerChangedCallback)callback;


/**
 延后N秒，录制N秒

 @param time 指定录制的时间
 @param duration 需要录制音频的时间长度
 */
- (void)recordAtTime:(NSTimeInterval)time DurationTime:(NSTimeInterval)duration;


/**
 延后N秒录制，不限时长

 @param time 指定录制的时间
 */
- (void)recordAtTime:(NSTimeInterval)time;


/**
 立刻录制，录制N秒

 @param duration 需要录制音频的时间长度
 */
- (void)recordDurationTime:(NSTimeInterval)duration;


/**
 立刻录制，不限时长
 */
- (void)record;


/**
 停止
 */
- (void)stopRecord;


/**
 暂停
 */
- (void)pauseRecord;


@end

NS_ASSUME_NONNULL_END
