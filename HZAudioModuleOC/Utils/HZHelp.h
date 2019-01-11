//
//  HZHelp.h
//  HZAudioModuleOC
//
//  Created by MaHaoZhe on 2019/1/9.
//  Copyright © 2019 HachiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZHelp : NSObject

+ (NSURL *)getRecordSavePathWithRecordName:(NSString *)RName;


+ (NSArray<NSString *> *)getAllRecordName;

@end

NS_ASSUME_NONNULL_END
