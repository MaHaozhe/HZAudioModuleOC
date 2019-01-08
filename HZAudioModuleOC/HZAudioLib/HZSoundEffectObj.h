//
//  HZSoundEffectObj.h
//  HZAudioModuleOC
//
//  Created by MaHaoZhe on 2019/1/3.
//  Copyright © 2019 HachiTech. All rights reserved.
//  音效播放

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SoundEffectCompleteCallback)(SystemSoundID soundID);

@interface HZSoundEffectObj : NSObject

SINGLETON_FOR_HEADER(HZSoundEffectObj);

/**
 播放音效

 @param name 音频名称
 */
- (void)playSoundEffect:(NSString *)name;


/**
 播放音效并震动

 @param name 音频名称
 */
- (void)playSoundEffectAlert:(NSString *)name;


/**
 播放音效

 @param name 音频名称
 @param callback 成功回调
 */
- (void)playSoundEffect:(NSString *)name complete:(SoundEffectCompleteCallback)callback;


/**
 播放音效并震动

 @param name 音频名称
 @param callback 成功回调
 */
- (void)playSoundEffectAlert:(NSString *)name complete:(SoundEffectCompleteCallback)callback;


/**
 销毁音效

 @param soundID 声音ID
 */
- (void)disposeSoundEffectAlert:(SystemSoundID)soundID;


@end

NS_ASSUME_NONNULL_END
