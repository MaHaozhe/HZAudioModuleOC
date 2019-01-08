//
//  MUtilMacro.h
//  HZAudioModuleOC
//
//  Created by MaHaoZhe on 2019/1/3.
//  Copyright © 2019 HachiTech. All rights reserved.
//

#ifndef MUtilMacro_h
#define MUtilMacro_h

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;
//屏幕宽高
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width

#endif /* MUtilMacro_h */
