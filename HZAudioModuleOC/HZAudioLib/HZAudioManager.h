//
//  HZAudioManager.h
//  HZAudioModuleOC
//
//  Created by MaHaoZhe on 2019/1/3.
//  Copyright © 2019 HachiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HZSoundEffectObj.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    HZSoundEffectDefaultType,           //普通播放
    HZSoundEffectDefaultCallbackType,   //普通播放有回调
    HZSoundEffectAlertType,             //震动播放
    HZSoundEffectAlertCallbackType,     //震动播放有回调
} HZSoundEffectPlayType;

@interface HZAudioManager : NSObject

SINGLETON_FOR_HEADER(HZAudioManager);


/**
 播放音效

 @param soundName 音频文件名
 @param palyType 播放方式
 @param callback 完成回调
 */
- (void)playSoundEffect:(NSString *)soundName playType:(HZSoundEffectPlayType)palyType complete:(SoundEffectCompleteCallback)callback;

@end

NS_ASSUME_NONNULL_END
