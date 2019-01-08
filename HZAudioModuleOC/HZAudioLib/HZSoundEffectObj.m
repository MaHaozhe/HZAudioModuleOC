//
//  HZSoundEffectObj.m
//  HZAudioModuleOC
//
//  Created by MaHaoZhe on 2019/1/3.
//  Copyright © 2019 HachiTech. All rights reserved.
//

#import "HZSoundEffectObj.h"

//定义一个全局静态变量指针用于保存当前类的地址
static HZSoundEffectObj *selfClass =nil;

@interface HZSoundEffectObj ()

@property (nonatomic, copy) SoundEffectCompleteCallback callback;

@end

@implementation HZSoundEffectObj

SINGLETON_FOR_CLASS(HZSoundEffectObj);

-(instancetype)init{
    if (self = [super init]) {
        //函数指针指向本身
        selfClass =self;
        
    }
    return self;
}


//播放完成回调（iOS 9 之前） c 函数
void soundCompleteCallback(SystemSoundID soundID,void * clientData){
    AudioServicesDisposeSystemSoundID(soundID);
    AudioServicesRemoveSystemSoundCompletion(soundID);
    //C函数调用OC方法
    [selfClass soundCallBack:soundID];
}


//播放完成回调
-(void)soundCallBack:(SystemSoundID)soundID{
    if (self.callback) {
        self.callback(soundID);
    }
}


-(void)playSoundEffect:(NSString *)name{
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    //1.获得系统声音ID
    SystemSoundID soundID = 0;
    
    /**
     生成系统声音ID
     
     @param CFURLRef 音频URL
     @return 声音ID（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    
    //2.播放音频
    AudioServicesPlaySystemSound(soundID);
}


-(void)playSoundEffectAlert:(NSString *)name{
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    //1.获得系统声音ID
    SystemSoundID soundID = 0;
    
    /**
     生成系统声音ID
     
     @param CFURLRef 音频URL
     @return 声音ID（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    
    //2.播放音频
    AudioServicesPlayAlertSound(soundID);
}


-(void)playSoundEffect:(NSString *)name complete:(SoundEffectCompleteCallback)callback{
    
    self.callback = callback;
    
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    //1.获得系统声音ID
    SystemSoundID soundID = 0;
    /**
     生成系统声音ID
     
     @param CFURLRef 音频URL
     @return 声音ID（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    
    if (@available(iOS 9.0, *)) {
        AudioServicesPlaySystemSoundWithCompletion(soundID, ^{
            AudioServicesDisposeSystemSoundID(soundID);
            AudioServicesRemoveSystemSoundCompletion(soundID);

            callback(soundID);
        });
    } else {
        //如果需要在播放返程之后d执行某些操作，调用如下方法注册一个播放完成回调函数
        AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
        
        //2.播放音频
        AudioServicesPlaySystemSound(soundID);
    }
}


-(void)playSoundEffectAlert:(NSString *)name complete:(SoundEffectCompleteCallback)callback{
    
    self.callback = callback;
    
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    //1.获得系统声音ID
    SystemSoundID soundID = 0;
    /**
     生成系统声音ID
     
     @param CFURLRef 音频URL
     @return 声音ID（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    
    if (@available(iOS 9.0, *)) {
        //2.播放音频 iOS 9 以上系统
        AudioServicesPlayAlertSoundWithCompletion(soundID, ^{
            AudioServicesDisposeSystemSoundID(soundID);
            AudioServicesRemoveSystemSoundCompletion(soundID);
            callback(soundID);
        });
    } else {
        //如果需要在播放返程之后d执行某些操作，调用如下方法注册一个播放完成回调函数
        AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
        //2.播放音频
        AudioServicesPlayAlertSound(soundID);
    }
}


- (void)disposeSoundEffectAlert:(SystemSoundID)soundID{
    AudioServicesDisposeSystemSoundID(soundID);
}

@end
