//
//  HZAudioManager.m
//  HZAudioModuleOC
//
//  Created by MaHaoZhe on 2019/1/3.
//  Copyright © 2019 HachiTech. All rights reserved.
//

#import "HZAudioManager.h"

@implementation HZAudioManager

SINGLETON_FOR_CLASS(HZAudioManager);

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)playSoundEffect:(NSString *)soundName playType:(HZSoundEffectPlayType)palyType complete:(SoundEffectCompleteCallback)callback{
    __block SoundEffectCompleteCallback weakCallback = callback;
    switch (palyType) {
        case HZSoundEffectDefaultType:
        {
            [[HZSoundEffectObj sharedHZSoundEffectObj] playSoundEffect:soundName];
        }
            break;
        case HZSoundEffectDefaultCallbackType:
        {
            [[HZSoundEffectObj sharedHZSoundEffectObj] playSoundEffect:soundName complete:^(SystemSoundID soundID) {
                weakCallback(soundID);
            }];
        }
            break;
        case HZSoundEffectAlertType:
        {
            [[HZSoundEffectObj sharedHZSoundEffectObj] playSoundEffectAlert:soundName];
        }
            break;
        case HZSoundEffectAlertCallbackType:
        {
            [[HZSoundEffectObj sharedHZSoundEffectObj] playSoundEffectAlert:soundName complete:^(SystemSoundID soundID) {
                weakCallback(soundID);
            }];
        }
            break;
            
        default:
            break;
    }
}


/**
 串型队列

 @return 返回串型队列
 */

/*
 static dispatch_queue_t exposure_manager_creation_queue() {
 static dispatch_queue_t hq_exposure_manager_creation_queue;
 static dispatch_once_t onceToken;
 dispatch_once(&onceToken, ^{
 hq_exposure_manager_creation_queue = dispatch_queue_create("com.MaHaoZhe.HZAudioManager.creation", DISPATCH_QUEUE_SERIAL);
 });
 
 return hq_exposure_manager_creation_queue;
 }
 */

@end
