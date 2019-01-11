//
//  HZFMDBManager.h
//  HZAudioModuleOC
//
//  Created by MaHaoZhe on 2019/1/10.
//  Copyright © 2019 HachiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HZRecordModel;
@interface HZFMDBManager : NSObject

#pragma mark - 录音

/**
 存储录音

 @param name 录音名称
 */
- (void)saveRecordName:(NSString *)name;


/**
 查询录音名称

 @param recordID 录音ID
 @return 返回录音名称
 */
- (NSString *)queryRecordNameForID:(NSString *)recordID;


/**
 查询所有录音

 @return 返回所有录音
 */
- (NSArray<HZRecordModel *> *)queryAllRecord;

/**
 删除录音

 @param recordID 录音ID
 @return 是否删除成功
 */
- (BOOL)deleteRecordForID:(NSString *)recordID;

@end

NS_ASSUME_NONNULL_END
